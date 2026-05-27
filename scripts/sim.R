# Spatial-transcriptomics simulation: data-generating process and fitters.
# Sourced by run.R.
#
# DGP: K cell types, J genes, S spots.
# mu[j,k]       per-cell-type, per-gene mean expression (log-normal).
# p[s,]         per-spot composition vector (Dirichlet).
# X[s,j]        observed spot count, Poisson(N_s * sum_k p[s,k] * mu[j,k]).
#
# All fitters work on the empirical mean Xbar = X / N (S x J), so they are
# scale-agnostic with respect to N.

suppressPackageStartupMessages({
    invisible(NULL)  # base R only, no external deps
})

# -----------------------------------------------------------------
# Dirichlet sampler (base R; avoids dependency on gtools or MCMCpack)
# -----------------------------------------------------------------

rdirichlet_simple <- function(n, alpha) {
    K <- length(alpha)
    g <- matrix(rgamma(n * K, shape = alpha), nrow = n, ncol = K, byrow = TRUE)
    g / rowSums(g)
}

# -----------------------------------------------------------------
# Ground-truth generation
# -----------------------------------------------------------------

#' Log-normal per-cell-type, per-gene mean expression matrix.
#' Returns J x K matrix.
make_mu <- function(J, K, log_sd = 1.0, floor = 0.05) {
    mu <- matrix(exp(rnorm(J * K, mean = 0, sd = log_sd)), nrow = J, ncol = K)
    pmax(mu, floor)
}

#' Per-spot composition matrix (S x K) drawn from Dirichlet(alpha).
make_P <- function(S, K, alpha = 1.0) {
    rdirichlet_simple(S, rep(alpha, K))
}

#' Generate ST count matrix.
#'
#' @param P        S x K composition matrix.
#' @param mu       J x K per-cell-type expression matrix.
#' @param N_s      per-spot expected total count (scalar or length-S).
sim_st <- function(P, mu, N_s = 100) {
    S <- nrow(P); K <- ncol(P); J <- nrow(mu)
    if (length(N_s) == 1L) N_s <- rep(N_s, S)
    lambda <- (P %*% t(mu)) * N_s   # S x J, expected count
    X <- matrix(rpois(S * J, as.vector(lambda)), nrow = S, ncol = J)
    list(X = X, N_s = N_s, Xbar = X / N_s, lambda = lambda / N_s,
         P_true = P, mu_true = mu)
}

# -----------------------------------------------------------------
# Diagnostics on the composition matrix P
# -----------------------------------------------------------------

#' Numerical rank of P at given tolerance, via SVD.
#' Returns the integer rank, plus the smallest singular value.
rank_diagnostic <- function(P, tol = 1e-8) {
    sv <- svd(P, nu = 0, nv = 0)$d
    list(rank = sum(sv > tol * sv[1]), min_sv = sv[length(sv)], sv = sv)
}

# -----------------------------------------------------------------
# Estimators
# -----------------------------------------------------------------

#' Estimate per-cell-type mean expression given known P (oracle).
#' Solves Xbar ~ P %*% t(mu), gene by gene, via OLS.
#' Returns J x K matrix.
fit_mu_given_P <- function(Xbar, P) {
    qrP <- qr(P)
    if (qrP$rank < ncol(P)) {
        # Use Moore-Penrose pseudoinverse if P is rank-deficient.
        sv <- svd(P)
        tol <- max(dim(P)) * .Machine$double.eps * max(sv$d)
        d_inv <- ifelse(sv$d > tol, 1 / sv$d, 0)
        Pplus <- sv$v %*% diag(d_inv, ncol(P), ncol(P)) %*% t(sv$u)
        t(Pplus %*% Xbar)
    } else {
        coef <- qr.coef(qrP, Xbar)   # K x J
        t(coef)
    }
}

#' Estimate composition p_s given known mu (oracle).
#' Constraint: components nonnegative, sum to 1.
#' Closed-form OLS first; project to simplex.
fit_P_given_mu <- function(Xbar, mu) {
    S <- nrow(Xbar); K <- ncol(mu)
    qrM <- qr(mu)
    if (qrM$rank < K) {
        sv <- svd(mu)
        tol <- max(dim(mu)) * .Machine$double.eps * max(sv$d)
        d_inv <- ifelse(sv$d > tol, 1 / sv$d, 0)
        muplus <- sv$v %*% diag(d_inv, K, K) %*% t(sv$u)
        Phat <- Xbar %*% t(muplus)
    } else {
        Phat <- t(qr.coef(qrM, t(Xbar)))   # S x K
    }
    Phat <- t(apply(Phat, 1, project_simplex))
    Phat
}

#' Euclidean projection of a vector onto the probability simplex.
#' Wang & Carreira-Perpinan (2013) algorithm.
project_simplex <- function(v) {
    K <- length(v)
    u <- sort(v, decreasing = TRUE)
    cssv <- cumsum(u) - 1
    rho <- max(which(u - cssv / seq_len(K) > 0), 0)
    if (rho == 0) return(rep(1 / K, K))
    theta <- cssv[rho] / rho
    pmax(v - theta, 0)
}

#' Per-spot Poisson MLE for composition, with known cell-type signature.
#' Implements the core RCTD-style estimator: maximize the Poisson
#' likelihood
#'   log L = sum_{j} X_{sj} log(N_s sum_k p_{sk} mu_{jk}) - N_s sum_k p_{sk} mu_{jk}
#' subject to p_s in the simplex.
#' Uses EM-style multiplicative updates with row-normalization to the simplex.
#'
#' This implements RCTD's mathematical core (per-spot Poisson MLE with
#' fixed cell-type expression mu); the full spacexr package adds
#' platform-effect terms and confidence intervals that are orthogonal
#' to the identifiability claims we test.
fit_P_rctd_like <- function(X, mu, N_s, n_iter = 100, eps = 1e-10) {
    S <- nrow(X); J <- nrow(mu); K <- ncol(mu)
    if (length(N_s) == 1L) N_s <- rep(N_s, S)
    P <- matrix(1 / K, nrow = S, ncol = K)
    mu_col_sums <- colSums(mu)   # sum_j mu_{jk} per cell type
    for (it in seq_len(n_iter)) {
        lambda <- (P %*% t(mu)) * N_s
        lambda <- pmax(lambda, eps)
        ratio <- X / lambda                 # X_sj / lambda_sj
        # numer[s,k] = sum_j mu_{jk} * X_{sj} / lambda_{sj}
        numer <- ratio %*% mu
        # multiplicative update with normalizer sum_j mu_jk
        P <- P * sweep(numer, 2, pmax(mu_col_sums, eps), "/")
        # project to simplex by row normalization
        rs <- pmax(rowSums(P), eps)
        P <- P / rs
    }
    P
}

#' Joint NMF estimator (Frobenius, Lee-Seung multiplicative updates).
#' Returns Phat (S x K), muhat (J x K). No constraints on column sums of P;
#' for cell-total residual check, only fitted Xhat = Phat %*% t(muhat) matters.
#'
#' Optional convergence trace: if `trace_iters` is non-null, returns the
#' Frobenius residual at each listed iteration. Useful for diagnosing
#' whether multiplicative updates have reached a stationary point.
fit_nmf <- function(Xbar, K, n_iter = 200, seed = NULL, eps = 1e-10,
                    trace_iters = NULL) {
    if (!is.null(seed)) set.seed(seed)
    S <- nrow(Xbar); J <- ncol(Xbar)
    P <- matrix(runif(S * K, 0.1, 0.9), S, K)
    M <- matrix(runif(K * J, 0.1, 0.9), K, J)   # M = t(mu)
    trace <- if (!is.null(trace_iters))
        data.frame(iter = trace_iters,
                   frob_resid = NA_real_, abs_max = NA_real_)
    else NULL
    for (i in seq_len(n_iter)) {
        # Update M: M <- M * (P^T Xbar) / (P^T P M)
        num <- crossprod(P, Xbar)
        den <- crossprod(P) %*% M
        M <- M * num / pmax(den, eps)
        # Update P: P <- P * (Xbar M^T) / (P M M^T)
        num <- Xbar %*% t(M)
        den <- P %*% tcrossprod(M)
        P <- P * num / pmax(den, eps)
        if (!is.null(trace) && i %in% trace_iters) {
            fitted <- P %*% M
            ix <- which(trace$iter == i)
            trace$frob_resid[ix] <- sqrt(sum((fitted - Xbar)^2))
            trace$abs_max[ix] <- max(abs(fitted - Xbar))
        }
    }
    list(P = P, mu = t(M), trace = trace)
}

# -----------------------------------------------------------------
# Cell-total residual: theorem 2 diagnostic
# -----------------------------------------------------------------

#' For an estimator that returns (P, mu), compute the relative
#' cell-total residual: max_{s,j} |fitted - Xbar| / Xbar.
#' Returns scalar (max relative error) plus the median and mean for reporting.
cell_total_residual <- function(fit, Xbar, eps = 1e-6) {
    fitted <- fit$P %*% t(fit$mu)
    denom <- pmax(abs(Xbar), eps)
    rel <- abs(fitted - Xbar) / denom
    list(max = max(rel), median = median(rel), mean = mean(rel),
         abs_max = max(abs(fitted - Xbar)),
         abs_median = median(abs(fitted - Xbar)))
}

# -----------------------------------------------------------------
# Marker-gene bias: theorem 3 diagnostic
# -----------------------------------------------------------------

#' Estimate per-spot composition using only a subset of marker genes.
#' Returns the median row-wise L1 error against true P.
marker_bias <- function(sim, marker_idx) {
    Xbar_sub <- sim$Xbar[, marker_idx, drop = FALSE]
    mu_sub   <- sim$mu_true[marker_idx, , drop = FALSE]
    Phat <- fit_P_given_mu(Xbar_sub, mu_sub)
    err_rows <- rowSums(abs(Phat - sim$P_true)) / 2  # L1/2 = total variation per spot
    list(median_tv = median(err_rows), mean_tv = mean(err_rows),
         q90_tv = quantile(err_rows, 0.9, names = FALSE))
}
