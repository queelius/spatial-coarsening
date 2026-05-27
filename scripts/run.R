# Run experiments for spatial-coarsening validation.
#
# Outputs results to results.rds at the script's directory.
# Console summary printed at the end.
#
# Usage:
#   cd papers/spatial-coarsening
#   Rscript scripts/run.R

# -----------------------------------------------------------------
# Setup
# -----------------------------------------------------------------

script_dir <- local({
    args <- commandArgs(trailingOnly = FALSE)
    file_arg <- grep("^--file=", args, value = TRUE)
    if (length(file_arg) == 1L) {
        d <- dirname(normalizePath(sub("^--file=", "", file_arg)))
    } else if (file.exists("scripts/sim.R")) {
        d <- normalizePath("scripts")
    } else {
        d <- normalizePath(".")
    }
    d
})
source(file.path(script_dir, "sim.R"))

set.seed(20260517)

# -----------------------------------------------------------------
# Experiment 1: rank-condition probability vs (S, K, alpha)
# -----------------------------------------------------------------

cat("[1/4] Rank-condition probability sweep...\n")

exp1_grid <- expand.grid(
    alpha = c(0.1, 0.3, 0.5, 1.0, 2.0),
    S_per_K = c(0.5, 0.8, 1, 2, 5, 10),    # include underdetermined S < K cases
    K = c(5, 10, 20),
    stringsAsFactors = FALSE
)
exp1_grid$S <- pmax(ceiling(exp1_grid$S_per_K * exp1_grid$K), 1L)
n_rep_rank <- 200
exp1_grid$full_rank_prob <- NA_real_
exp1_grid$median_min_sv  <- NA_real_

for (i in seq_len(nrow(exp1_grid))) {
    K <- exp1_grid$K[i]
    S <- exp1_grid$S[i]
    alpha <- exp1_grid$alpha[i]
    is_full <- logical(n_rep_rank)
    min_svs <- numeric(n_rep_rank)
    for (r in seq_len(n_rep_rank)) {
        P <- make_P(S, K, alpha)
        diag_r <- rank_diagnostic(P)
        is_full[r] <- (diag_r$rank == K)
        # For S < K there is no K-th singular value (P is wide); record NA.
        min_svs[r] <- if (S >= K) diag_r$min_sv else NA_real_
    }
    exp1_grid$full_rank_prob[i] <- mean(is_full)
    exp1_grid$median_min_sv[i]  <- median(min_svs, na.rm = TRUE)
}

cat("    done.\n")

# -----------------------------------------------------------------
# Experiment 2: cell-total consistency residual vs N_s
# -----------------------------------------------------------------

cat("[2/4] Cell-total consistency: noiseless control + noisy sweep...\n")

# Noiseless control: feed the true mean directly, NMF should recover it
# at machine precision (the theorem in its limit form). To answer the
# methodology-auditor's M-C1 question (does multiplicative-update NMF
# reach a true stationary point on noiseless input?), we trace residual
# over many iterations and report the final value.
K_n <- 5; S_n <- 500; J_n <- 50
P_n  <- make_P(S_n, K_n, alpha = 1.0)
mu_n <- make_mu(J_n, K_n, log_sd = 1.0)
Xbar_noiseless <- P_n %*% t(mu_n)

trace_iters <- c(100, 500, 1000, 5000, 10000, 20000, 50000)
fit_n_long <- fit_nmf(Xbar_noiseless, K_n,
                      n_iter = max(trace_iters), seed = 1,
                      trace_iters = trace_iters)
resid_n_long <- cell_total_residual(fit_n_long, Xbar_noiseless)
exp2_noiseless <- list(
    abs_max = resid_n_long$abs_max,
    abs_median = resid_n_long$abs_median,
    rel_max = resid_n_long$max,
    rel_median = resid_n_long$median,
    trace = fit_n_long$trace
)
cat("    noiseless NMF, multiplicative-update convergence trace:\n")
for (r in seq_len(nrow(fit_n_long$trace))) {
    cat(sprintf("      iter %6d: Frobenius resid = %.3g, max abs = %.3g\n",
                fit_n_long$trace$iter[r],
                fit_n_long$trace$frob_resid[r],
                fit_n_long$trace$abs_max[r]))
}

# Oracle cell-total: given true mu, fit P via OLS-projection-to-simplex.
# This is the simplest convex MLE-style estimator. The fitted-X = Phat %*% t(mu)
# should equal the projection of Xbar onto the column space of mu, which is
# Xbar itself when Xbar is rank K and lies in that span.
N_grid_oracle <- c(10, 100, 1000, 10000)
exp2_oracle <- data.frame(
    N_s = N_grid_oracle,
    rep = seq_along(N_grid_oracle),
    max_abs = NA_real_,
    median_abs = NA_real_,
    max_rel = NA_real_,
    median_rel = NA_real_
)
for (i in seq_len(nrow(exp2_oracle))) {
    P_o  <- make_P(S_n, K_n, alpha = 1.0)
    sim_o <- sim_st(P_o, mu_n, N_s = exp2_oracle$N_s[i])
    Phat <- fit_P_given_mu(sim_o$Xbar, mu_n)
    fitted <- Phat %*% t(mu_n)
    err <- fitted - sim_o$Xbar
    rel <- abs(err) / pmax(abs(sim_o$Xbar), 1e-6)
    exp2_oracle$max_abs[i] <- max(abs(err))
    exp2_oracle$median_abs[i] <- median(abs(err))
    exp2_oracle$max_rel[i] <- max(rel)
    exp2_oracle$median_rel[i] <- median(rel)
}
# Noiseless oracle: pass true mean directly
P_o  <- make_P(S_n, K_n, alpha = 1.0)
true_mean <- P_o %*% t(mu_n)
Phat_o <- fit_P_given_mu(true_mean, mu_n)
fitted_o <- Phat_o %*% t(mu_n)
exp2_oracle_noiseless <- list(
    max_abs = max(abs(fitted_o - true_mean)),
    median_abs = median(abs(fitted_o - true_mean))
)
cat(sprintf("    noiseless oracle (true mu, OLS P): max abs = %.3g (median %.3g)\n",
            exp2_oracle_noiseless$max_abs, exp2_oracle_noiseless$median_abs))

K_ct <- 5; S_ct <- 500; J_ct <- 50
N_grid <- c(10, 30, 100, 300, 1000, 3000)
n_rep_ct <- 25

exp2_results <- data.frame(
    N_s = rep(N_grid, each = n_rep_ct),
    rep = rep(seq_len(n_rep_ct), times = length(N_grid)),
    max_rel = NA_real_,
    median_rel = NA_real_,
    abs_max = NA_real_,
    abs_median = NA_real_
)

mu_ct <- make_mu(J_ct, K_ct, log_sd = 1.0)

for (i in seq_len(nrow(exp2_results))) {
    P_ct <- make_P(S_ct, K_ct, alpha = 1.0)
    sim_ct <- sim_st(P_ct, mu_ct, N_s = exp2_results$N_s[i])
    fit <- fit_nmf(sim_ct$Xbar, K_ct, n_iter = 250, seed = i)
    resid <- cell_total_residual(fit, sim_ct$Xbar)
    exp2_results$max_rel[i] <- resid$max
    exp2_results$median_rel[i] <- resid$median
    exp2_results$abs_max[i] <- resid$abs_max
    exp2_results$abs_median[i] <- resid$abs_median
}

# Aggregate over replicates
exp2_summary <- aggregate(
    cbind(max_rel, median_rel, abs_max, abs_median) ~ N_s,
    data = exp2_results, FUN = median
)

cat("    done.\n")

# -----------------------------------------------------------------
# Experiment 3: marker-gene bias vs panel size |M|
# -----------------------------------------------------------------

cat("[3/4] Marker-gene bias sweep (small-K + Visium-scale)...\n")

run_marker_sweep <- function(K_m, S_m, J_m, N_m, M_grid, n_rep_m, seed_base) {
    mu_m <- make_mu(J_m, K_m, log_sd = 1.0)
    diff_score <- apply(mu_m, 1, function(x) max(x) - min(x))
    marker_order <- order(diff_score, decreasing = TRUE)

    out <- data.frame(
        M = rep(M_grid, each = n_rep_m),
        rep = rep(seq_len(n_rep_m), times = length(M_grid)),
        median_tv = NA_real_,
        q90_tv = NA_real_
    )
    for (i in seq_len(nrow(out))) {
        set.seed(seed_base + i)
        P_m <- make_P(S_m, K_m, alpha = 1.0)
        sim_m <- sim_st(P_m, mu_m, N_s = N_m)
        M_size <- out$M[i]
        if (M_size > J_m) { out$median_tv[i] <- NA; next }
        marker_idx <- marker_order[seq_len(M_size)]
        bias <- marker_bias(sim_m, marker_idx)
        out$median_tv[i] <- bias$median_tv
        out$q90_tv[i] <- bias$q90_tv
    }
    summary <- aggregate(
        cbind(median_tv, q90_tv) ~ M, data = out, FUN = median
    )
    summary$one_over_sqrt_M <- 1 / sqrt(summary$M)
    slope <- coef(lm(log(median_tv) ~ log(M), data = summary))[["log(M)"]]
    list(raw = out, summary = summary, slope = slope,
         K = K_m, S = S_m, J = J_m, N_s = N_m)
}

# Small-K regime (matches the original simulation; K=5 stresses the iid baseline)
exp3a <- run_marker_sweep(K_m = 5, S_m = 500, J_m = 200, N_m = 100,
                          M_grid = c(5, 10, 25, 50, 100, 200),
                          n_rep_m = 25, seed_base = 100)

# Visium-scale regime (M-min2: matches the real-data K=30; |M| sweeps from
# severely-undercovered to comfortable)
exp3b <- run_marker_sweep(K_m = 30, S_m = 2700, J_m = 500, N_m = 500,
                          M_grid = c(30, 60, 100, 200, 400, 500),
                          n_rep_m = 15, seed_base = 200)

cat(sprintf("    K=5,  log-log slope of bias on |M|: %.3f\n",  exp3a$slope))
cat(sprintf("    K=30, log-log slope of bias on |M|: %.3f\n",  exp3b$slope))

# Backwards-compatible names so the existing figures script keeps working
exp3_results <- exp3a$raw
exp3_summary <- exp3a$summary
exp3_loglog_slope <- exp3a$slope

# -----------------------------------------------------------------
# Experiment 4: Visium-like case, structured tissue patches showing
# rank deficiency that singleton augmentation repairs
# -----------------------------------------------------------------

cat("[4/4] Visium-like case (S=2700, K=30): random + structured...\n")

K_v <- 30; S_v <- 2700; J_v <- 200; N_v <- 500
mu_v <- make_mu(J_v, K_v, log_sd = 1.0)

# 4a: random Dirichlet composition; well-conditioned, full rank.
P_v_random <- make_P(S_v, K_v, alpha = 0.5)
rank_random <- rank_diagnostic(P_v_random)

# 4b: structured tissue, the case that exposes rank deficiency.
# G tissue regions, each spot is exactly one of G distinct compositions
# (no per-spot perturbation). The row space of P is G-dimensional, so
# rank(P) = G < K and the deconvolution problem is unidentifiable from
# spot data alone.
G <- 6           # number of distinct tissue regions
n_types_per_region <- 6
build_region_template <- function(K, region_idx, n_types_per_region) {
    template <- numeric(K)
    start <- ((region_idx - 1) * (n_types_per_region - 1)) %% K + 1
    idxs <- ((start - 1 + 0:(n_types_per_region - 1)) %% K) + 1
    template[idxs] <- rdirichlet_simple(1, rep(1, n_types_per_region))
    template
}
templates <- t(sapply(seq_len(G),
                     build_region_template, K = K_v,
                     n_types_per_region = n_types_per_region))
region_assign <- sample.int(G, S_v, replace = TRUE)
P_v_struct <- templates[region_assign, , drop = FALSE]   # S x K, only G distinct rows

rank_struct <- rank_diagnostic(P_v_struct)
# Also report effective rank at 1% tolerance, since spatial structure in
# real tissue is approximate rather than exact: count singular values
# above 1% of the largest.
eff_rank_at <- function(sv, frac = 0.01) sum(sv > frac * sv[1])
sv_struct_full <- svd(P_v_struct, nu = 0, nv = 0)$d
sv_struct_full <- c(sv_struct_full, rep(0, K_v - length(sv_struct_full)))
eff_rank_struct <- eff_rank_at(sv_struct_full, 0.01)

# Singleton augmentation: add a balanced reference of K rows (one e_k each).
# Singleton rows are a stack of identity-like compositions (a single-cell-
# resolution platform gives one composition per measured cell).
P_v_struct_aug <- rbind(P_v_struct, diag(K_v))
rank_struct_aug <- rank_diagnostic(P_v_struct_aug)

# Cell-total consistency on the random Visium-like dataset (well-conditioned)
sim_v <- sim_st(P_v_random, mu_v, N_s = N_v)
fit_v <- fit_nmf(sim_v$Xbar, K_v, n_iter = 300, seed = 42)
resid_v <- cell_total_residual(fit_v, sim_v$Xbar)

# Top-200 genes relative residual, robust median statistic
gene_means <- colMeans(sim_v$Xbar)
top_genes <- order(gene_means, decreasing = TRUE)[seq_len(min(200, J_v))]
fitted_v <- fit_v$P %*% t(fit_v$mu)
rel_top <- abs(fitted_v[, top_genes] - sim_v$Xbar[, top_genes]) /
           pmax(abs(sim_v$Xbar[, top_genes]), 1e-6)
visium_top200_max_rel <- max(rel_top)
visium_top200_median_rel <- median(rel_top)

exp4 <- list(
    K = K_v, S = S_v, J = J_v, N_s = N_v,
    random = list(
        alpha = 0.5,
        rank = rank_random$rank,
        min_sv = rank_random$min_sv
    ),
    structured = list(
        G = G,
        n_types_per_region = n_types_per_region,
        rank_spots_only = rank_struct$rank,
        eff_rank_spots_only_1pct = eff_rank_struct,
        min_sv_spots_only = rank_struct$min_sv,
        rank_with_singletons = rank_struct_aug$rank,
        min_sv_with_singletons = rank_struct_aug$min_sv
    ),
    cell_total_residual = resid_v,
    visium_top200_max_rel = visium_top200_max_rel,
    visium_top200_median_rel = visium_top200_median_rel
)

cat("    done.\n")

# -----------------------------------------------------------------
# Save and summarize
# -----------------------------------------------------------------

results <- list(
    seed = 20260517,
    timestamp = Sys.time(),
    exp1_rank = exp1_grid,
    exp2_noiseless_nmf = exp2_noiseless,
    exp2_oracle = exp2_oracle,
    exp2_oracle_noiseless = exp2_oracle_noiseless,
    exp2_cell_total_raw = exp2_results,
    exp2_summary = exp2_summary,
    exp3_marker_raw = exp3_results,
    exp3_summary = exp3_summary,
    exp3_loglog_slope = exp3_loglog_slope,
    exp3a_K5  = exp3a,
    exp3b_K30 = exp3b,
    exp4_visium = exp4
)

saveRDS(results, file = file.path(script_dir, "..", "results.rds"))

cat("\n========== SUMMARY ==========\n")
cat("\nExp1 (rank-condition probability over (alpha, S, K)):\n")
print(exp1_grid)

cat("\nExp2a noiseless cell-total reconstruction:\n")
cat(sprintf("  NMF:    max abs residual = %.3g, median %.3g\n",
            exp2_noiseless$abs_max, exp2_noiseless$abs_median))
cat(sprintf("  Oracle: max abs residual = %.3g, median %.3g\n",
            exp2_oracle_noiseless$max_abs, exp2_oracle_noiseless$median_abs))
cat("\nExp2b oracle cell-total residual (true mu, fit P), vs N_s:\n")
print(exp2_oracle)
cat("\nExp2c noisy NMF cell-total residual (median across replicates):\n")
print(exp2_summary)

cat("\nExp3 marker bias (median across replicates):\n")
print(exp3_summary)
cat(sprintf("Log-log slope of median TV bias vs |M|: %.3f (theory: -0.5)\n",
            exp3_loglog_slope))

cat("\nExp4 Visium-like (K=30, S=2700, J=200, N_s=500):\n")
cat(sprintf("  random Dirichlet(0.5):     rank = %d / %d (min sv = %.3g)\n",
            exp4$random$rank, exp4$K, exp4$random$min_sv))
cat(sprintf("  structured (G=%d patches): rank = %d / %d (eff-rank at 1%% = %d)\n",
            exp4$structured$G, exp4$structured$rank_spots_only, exp4$K,
            exp4$structured$eff_rank_spots_only_1pct))
cat(sprintf("  structured + singletons:   rank = %d / %d (min sv = %.3g)\n",
            exp4$structured$rank_with_singletons, exp4$K,
            exp4$structured$min_sv_with_singletons))
cat(sprintf("  cell-total median relative residual (random) = %.3g\n",
            exp4$cell_total_residual$median))
cat(sprintf("  top-200 genes median relative residual       = %.3g\n",
            exp4$visium_top200_median_rel))

cat("\nResults saved to results.rds\n")
