# Head-to-head: oracle (OLS) vs RCTD-style (Poisson MLE) on the
# synthetic Visium-scale data from Exp4 of run.R. The framework's
# prediction is that identifiability is a property of inputs, not
# methods, so both should recover composition well when the rank
# condition holds and both should fail in the same way when it
# does not. This script tests that prediction.
#
# Output: results_rctd.rds + console summary.

script_dir <- local({
    args <- commandArgs(trailingOnly = FALSE)
    f <- grep("^--file=", args, value = TRUE)
    if (length(f) == 1L) dirname(normalizePath(sub("^--file=", "", f)))
    else normalizePath(".")
})
proj_root <- normalizePath(file.path(script_dir, ".."))
source(file.path(script_dir, "sim.R"))

set.seed(20260524)

# -----------------------------------------------------------------
# Common DGP: Visium-scale, K=30, S=2700, J=200, N_s=500
# -----------------------------------------------------------------
K <- 30; S <- 2700; J <- 200; N_s <- 500
mu <- make_mu(J, K, log_sd = 1.0)

# Per-spot TV distance ||p_hat - p_true||_1 / 2
spot_tv <- function(Phat, Ptrue) rowSums(abs(Phat - Ptrue)) / 2

run_compare <- function(P_true, label) {
    cat(sprintf("--- %s ---\n", label))
    cat(sprintf("    rank(P_true) = %d / %d (min sv on K cols = %.3g)\n",
                rank_diagnostic(P_true)$rank, K,
                rank_diagnostic(P_true)$min_sv))
    sim <- sim_st(P_true, mu, N_s = N_s)
    t0 <- Sys.time()
    P_oracle <- fit_P_given_mu(sim$Xbar, mu)
    t1 <- Sys.time()
    P_rctd <- fit_P_rctd_like(sim$X, mu, N_s = N_s, n_iter = 100)
    t2 <- Sys.time()
    tv_oracle <- spot_tv(P_oracle, P_true)
    tv_rctd   <- spot_tv(P_rctd,   P_true)
    cat(sprintf("    oracle (OLS+simplex): median TV = %.3g, q90 = %.3g (%.1f sec)\n",
                median(tv_oracle), quantile(tv_oracle, 0.9, names = FALSE),
                as.numeric(difftime(t1, t0, units = "secs"))))
    cat(sprintf("    RCTD-style Poisson MLE: median TV = %.3g, q90 = %.3g (%.1f sec)\n",
                median(tv_rctd), quantile(tv_rctd, 0.9, names = FALSE),
                as.numeric(difftime(t2, t1, units = "secs"))))
    # Rank correlation: do the two methods agree on which spots are hard?
    rho <- cor(tv_oracle, tv_rctd, method = "spearman")
    cat(sprintf("    Spearman correlation of per-spot TV across methods: %.3f\n", rho))
    list(label = label,
         rank_P = rank_diagnostic(P_true)$rank,
         min_sv = rank_diagnostic(P_true)$min_sv,
         tv_oracle = tv_oracle,
         tv_rctd = tv_rctd,
         spearman_methods = rho,
         summary = data.frame(
             method = c("oracle", "rctd_like"),
             median_tv = c(median(tv_oracle), median(tv_rctd)),
             q90_tv = c(quantile(tv_oracle, 0.9, names = FALSE),
                        quantile(tv_rctd,   0.9, names = FALSE))
         ))
}

# -----------------------------------------------------------------
# Scenario 1: random Dirichlet(0.5); rank P = K, condition holds
# -----------------------------------------------------------------
P_rand <- make_P(S, K, alpha = 0.5)
scenario_random <- run_compare(P_rand, "Random Dirichlet(0.5)")

# -----------------------------------------------------------------
# Scenario 2: structured G=6 tissue patches; rank P = G < K, condition fails
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
scenario_structured <- run_compare(P_struct, "Structured G=6 patches (rank deficient)")

# -----------------------------------------------------------------
# Scenario 3: structured + singletons (singleton augmentation
# restores rank; the framework predicts both methods now recover)
# -----------------------------------------------------------------
P_struct_aug <- rbind(P_struct, diag(K))
scenario_aug <- run_compare(P_struct_aug,
                            "Structured + singleton augmentation (rank restored)")

# -----------------------------------------------------------------
# Save and summarize
# -----------------------------------------------------------------
results_rctd <- list(
    seed = 20260524,
    timestamp = Sys.time(),
    K = K, S = S, J = J, N_s = N_s,
    scenarios = list(
        random = scenario_random,
        structured = scenario_structured,
        structured_aug = scenario_aug
    )
)
saveRDS(results_rctd, file.path(proj_root, "results_rctd.rds"))

cat("\n========== RCTD-vs-oracle SUMMARY ==========\n")
for (s in results_rctd$scenarios) {
    cat(sprintf("%s:\n  rank(P)=%d, sigma_min=%.3g\n",
                s$label, s$rank_P, s$min_sv))
    print(s$summary)
    cat(sprintf("  Spearman per-spot agreement: %.3f\n\n", s$spearman_methods))
}
cat("Saved to results_rctd.rds\n")
