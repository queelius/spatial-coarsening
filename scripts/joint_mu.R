# Joint (P, mu) recovery experiment: tests Theorem 1's prediction
# directly. When rank(P) < K, joint NMF cannot recover the
# cell-type-specific expression mu_true even from noiseless data,
# because mu is non-identifiable in the framework's strict sense.
# Singleton augmentation restores rank to K and recovery succeeds.
#
# This is the M-M1 follow-up that yesterday's rctd_compare.R did not
# test: that script supplied mu as known, so it only exercised
# Theorem 4 (per-spot p recovery), not Theorem 1 (joint mu recovery).
#
# Output: results_joint_mu.rds + console summary.

script_dir <- local({
    args <- commandArgs(trailingOnly = FALSE)
    f <- grep("^--file=", args, value = TRUE)
    if (length(f) == 1L) dirname(normalizePath(sub("^--file=", "", f)))
    else normalizePath(".")
})
proj_root <- normalizePath(file.path(script_dir, ".."))
source(file.path(script_dir, "sim.R"))

set.seed(20260527)

# -----------------------------------------------------------------
# Common DGP: Visium-scale, K=30 cell types, J=200 genes
# -----------------------------------------------------------------
K <- 30; S <- 2700; J <- 200; N_s <- 500
mu_true <- make_mu(J, K, log_sd = 1.0)        # J x K
cat(sprintf("Truth: K=%d, S=%d, J=%d, N_s=%d\n", K, S, J, N_s))
cat(sprintf("Mu_true Frobenius norm: %.3g\n", sqrt(sum(mu_true^2))))
cat(sprintf("Mu_true rank: %d (max %d)\n",
            rank_diagnostic(mu_true)$rank, min(J, K)))

# -----------------------------------------------------------------
# Greedy column matching by maximum cosine similarity.
# Returns: permutation perm such that mu_hat[, perm] is best aligned
# column-by-column to mu_true.
# -----------------------------------------------------------------
align_columns <- function(mu_true, mu_hat) {
    cs <- function(a, b) sum(a * b) / sqrt(sum(a^2) * sum(b^2))
    K1 <- ncol(mu_true); K2 <- ncol(mu_hat)
    cost <- matrix(0, K1, K2)
    for (i in seq_len(K1)) for (j in seq_len(K2))
        cost[i, j] <- cs(mu_true[, i], mu_hat[, j])
    perm <- rep(NA_integer_, K1)
    used <- logical(K2)
    # Greedy: process true columns in order of best available match
    for (step in seq_len(K1)) {
        best_score <- -Inf
        best_i <- NA; best_j <- NA
        for (i in which(is.na(perm))) {
            for (j in which(!used)) {
                if (cost[i, j] > best_score) {
                    best_score <- cost[i, j]; best_i <- i; best_j <- j
                }
            }
        }
        perm[best_i] <- best_j
        used[best_j] <- TRUE
    }
    list(perm = perm,
         cosine_per_col = sapply(seq_len(K1),
            function(i) cs(mu_true[, i], mu_hat[, perm[i]])))
}

# -----------------------------------------------------------------
# Subspace agreement: principal-angle measure of column-span overlap.
# A theory-grounded measure: 1.0 if spans agree, 0.0 if orthogonal.
# Computed as ||proj(mu_true onto colspan(mu_hat))||_F^2 / ||mu_true||_F^2.
# -----------------------------------------------------------------
subspace_agreement <- function(mu_true, mu_hat) {
    # QR decomposition of mu_hat to get an orthonormal basis for its column span
    qr_hat <- qr(mu_hat)
    Q <- qr.Q(qr_hat)[, seq_len(qr_hat$rank), drop = FALSE]
    # Project mu_true onto the span
    proj <- Q %*% (t(Q) %*% mu_true)
    sum(proj^2) / sum(mu_true^2)
}

# -----------------------------------------------------------------
# Scenario builder
# -----------------------------------------------------------------
run_scenario <- function(P_true, mu_true, N_s, label, n_iter_nmf = 300, seed = 1) {
    cat(sprintf("\n=== %s ===\n", label))
    r <- rank_diagnostic(P_true)
    cat(sprintf("  rank(P_true) = %d / %d\n", r$rank, K))
    sim <- sim_st(P_true, mu_true, N_s = N_s)

    # Joint NMF at K_target = K
    fit <- fit_nmf(sim$Xbar, K = K, n_iter = n_iter_nmf, seed = seed)

    # Diagnostics:
    fitted <- fit$P %*% t(fit$mu)
    frob_resid <- sqrt(sum((fitted - sim$Xbar)^2)) / sqrt(sum(sim$Xbar^2))
    span_agree <- subspace_agreement(mu_true, fit$mu)
    alignment <- align_columns(mu_true, fit$mu)
    cat(sprintf("  Frobenius-relative residual on Xbar: %.4f\n", frob_resid))
    cat(sprintf("  Subspace agreement (mu_true vs span(mu_hat)): %.4f\n", span_agree))
    cat(sprintf("  Median per-cell-type cosine similarity: %.4f\n",
                median(alignment$cosine_per_col)))
    cat(sprintf("  Q1, Q3 cosine: %.4f, %.4f\n",
                quantile(alignment$cosine_per_col, 0.25, names = FALSE),
                quantile(alignment$cosine_per_col, 0.75, names = FALSE)))

    list(label = label,
         rank_P_true = r$rank,
         frob_resid = frob_resid,
         subspace_agreement = span_agree,
         alignment = alignment,
         median_cosine = median(alignment$cosine_per_col),
         q1_cosine = quantile(alignment$cosine_per_col, 0.25, names = FALSE),
         q3_cosine = quantile(alignment$cosine_per_col, 0.75, names = FALSE))
}

# -----------------------------------------------------------------
# Scenario A: structured G=6 tissue patches. rank(P_true) = 6.
# Theorem 1 prediction: mu is non-identifiable.
# -----------------------------------------------------------------
G <- 6
n_types_per_region <- 6
build_region_template <- function(K, region_idx, n_types_per_region) {
    template <- numeric(K)
    start <- ((region_idx - 1) * (n_types_per_region - 1)) %% K + 1
    idxs <- ((start - 1 + 0:(n_types_per_region - 1)) %% K) + 1
    template[idxs] <- rdirichlet_simple(1, rep(1, n_types_per_region))
    template
}
templates <- t(sapply(seq_len(G), build_region_template,
                     K = K, n_types_per_region = n_types_per_region))
region_assign <- sample.int(G, S, replace = TRUE)
P_struct <- templates[region_assign, , drop = FALSE]

result_struct <- run_scenario(P_struct, mu_true, N_s,
    "Structured G=6 patches (rank-deficient)")

# -----------------------------------------------------------------
# Scenario B: structured + K singleton rows. rank(P_true) = K.
# Theorem 1 prediction: mu is identifiable.
# -----------------------------------------------------------------
P_struct_aug <- rbind(P_struct, diag(K))
result_struct_aug <- run_scenario(P_struct_aug, mu_true, N_s,
    "Structured + singleton augmentation (rank-restored)")

# -----------------------------------------------------------------
# Scenario C (control): random Dirichlet(0.5). rank(P_true) = K.
# Should match scenario B in recovery quality.
# -----------------------------------------------------------------
P_random <- make_P(S, K, alpha = 0.5)
result_random <- run_scenario(P_random, mu_true, N_s,
    "Random Dirichlet(0.5) (rank-full, control)")

# -----------------------------------------------------------------
# Save
# -----------------------------------------------------------------
results_joint_mu <- list(
    seed = 20260527,
    K = K, S = S, J = J, N_s = N_s,
    scenarios = list(
        structured     = result_struct,
        structured_aug = result_struct_aug,
        random         = result_random
    )
)
saveRDS(results_joint_mu, file.path(proj_root, "results_joint_mu.rds"))

cat("\n========== JOINT (mu, P) RECOVERY SUMMARY ==========\n")
cat(sprintf("Median per-cell-type cosine similarity (recovered vs true mu):\n"))
cat(sprintf("  Structured G=6 (rank %d):              %.3f\n",
            result_struct$rank_P_true, result_struct$median_cosine))
cat(sprintf("  Structured + singletons (rank %d):     %.3f\n",
            result_struct_aug$rank_P_true, result_struct_aug$median_cosine))
cat(sprintf("  Random Dirichlet(0.5) (rank %d):       %.3f\n",
            result_random$rank_P_true, result_random$median_cosine))
cat(sprintf("\nSubspace agreement (mu_true projected onto span(mu_hat)):\n"))
cat(sprintf("  Structured G=6:              %.3f\n",     result_struct$subspace_agreement))
cat(sprintf("  Structured + singletons:     %.3f\n",     result_struct_aug$subspace_agreement))
cat(sprintf("  Random Dirichlet(0.5):       %.3f\n",     result_random$subspace_agreement))

cat("\nSaved to results_joint_mu.rds\n")
