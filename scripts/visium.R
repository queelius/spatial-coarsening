# Real-data Visium analysis: apply spatial-coarsening framework
# diagnostics to 10x V1 adult mouse coronal brain dataset.
#
# Inputs:
#   data/filtered_feature_bc_matrix/*: 10x sparse matrix
#   data/analysis/clustering/graphclust/clusters.csv: 10x graph-based clusters
#   data/analysis/clustering/kmeans_10_clusters/clusters.csv: K-means K=10
#
# Outputs:
#   results_visium.rds  named list of diagnostics
#
# Method-agnostic, framework-only: rank condition + cell-total
# consistency + singular-value spectrum.

suppressPackageStartupMessages({
    library(Matrix)
})

script_dir <- local({
    args <- commandArgs(trailingOnly = FALSE)
    f <- grep("^--file=", args, value = TRUE)
    if (length(f) == 1L) dirname(normalizePath(sub("^--file=", "", f)))
    else normalizePath(".")
})
proj_root <- normalizePath(file.path(script_dir, ".."))
data_dir <- file.path(proj_root, "data")
source(file.path(script_dir, "sim.R"))   # reuse fit_nmf, rank_diagnostic

set.seed(20260523)

# ---------------------------------------------------------------
# Load the filtered Visium matrix
# ---------------------------------------------------------------
cat("[1/5] Loading Visium matrix...\n")

m_dir <- file.path(data_dir, "filtered_feature_bc_matrix")
X_raw <- readMM(gzfile(file.path(m_dir, "matrix.mtx.gz"), "r"))  # genes x spots
barcodes <- readLines(gzfile(file.path(m_dir, "barcodes.tsv.gz"), "r"))
features <- read.table(gzfile(file.path(m_dir, "features.tsv.gz"), "r"),
                       sep = "\t", quote = "", header = FALSE,
                       col.names = c("ensembl", "symbol", "type"))
rownames(X_raw) <- features$ensembl
colnames(X_raw) <- barcodes

# Standard orientation: spots x genes. Transpose.
X_raw <- t(X_raw)
cat(sprintf("    %d spots x %d genes loaded.\n", nrow(X_raw), ncol(X_raw)))

# Library size per spot (= N_s)
N_s <- rowSums(X_raw)
cat(sprintf("    median UMI per spot: %.0f, range [%d, %d]\n",
            median(N_s), min(N_s), max(N_s)))

# ---------------------------------------------------------------
# Restrict to high-variance genes (computational tractability + signal)
# ---------------------------------------------------------------
cat("[2/5] Selecting high-variance genes...\n")
# Mean and variance of log-normalized expression per gene
norm_X <- log1p(sweep(X_raw, 1, N_s, FUN = "/") * 1e4)
gene_means <- Matrix::colMeans(norm_X)
gene_vars  <- apply(norm_X, 2, var)
# Pick top-2000 variable genes
n_hvg <- 2000
hvg_idx <- order(gene_vars, decreasing = TRUE)[seq_len(n_hvg)]
X_hvg <- as.matrix(X_raw[, hvg_idx])
gene_symbols_hvg <- features$symbol[hvg_idx]
cat(sprintf("    using top %d high-variance genes\n", n_hvg))

# Empirical mean per (spot, gene)
Xbar <- X_hvg / N_s
cat(sprintf("    Xbar matrix: %d x %d\n", nrow(Xbar), ncol(Xbar)))

# Expected Poisson noise floor on Xbar, in Frobenius-relative units.
# Var[Xbar_sj] = lambda_sj / N_s, estimated by Xbar_sj / N_s. So the
# Frobenius noise floor of the residual matrix (under a perfectly-fitting
# model) is sqrt(sum_{sj} Xbar_sj / N_s), and the relative noise floor is
# that divided by ||Xbar||_F.
poisson_floor_frob_rel <- sqrt(sum(Xbar / N_s)) / sqrt(sum(Xbar^2))
cat(sprintf("    expected Poisson noise floor on Xbar: Frobenius-relative %.3g\n",
            poisson_floor_frob_rel))

# ---------------------------------------------------------------
# Singular-value spectrum (effective rank diagnostic)
# ---------------------------------------------------------------
cat("[3/5] Singular value spectrum...\n")
# Centered log-normalized expression for SVD
X_log <- log1p(Xbar * 1e4)
X_log_c <- X_log - matrix(colMeans(X_log), nrow = nrow(X_log), ncol = ncol(X_log), byrow = TRUE)
sv <- svd(X_log_c, nu = 0, nv = 0)$d
sv_norm <- sv / sv[1]
eff_rank_1pct <- sum(sv_norm > 0.01)
eff_rank_5pct <- sum(sv_norm > 0.05)
cat(sprintf("    sigma_1 = %.3g, sigma_30 = %.3g (rel %.3g)\n",
            sv[1], sv[30], sv[30]/sv[1]))
cat(sprintf("    effective rank @ 1%% threshold: %d; @ 5%%: %d\n",
            eff_rank_1pct, eff_rank_5pct))

# ---------------------------------------------------------------
# Load 10x clusters and treat as cell-type proxy
# ---------------------------------------------------------------
cat("[4/5] Loading 10x clusters...\n")

load_cluster <- function(path) {
    df <- read.csv(file.path(data_dir, "analysis", "clustering", path, "clusters.csv"),
                   stringsAsFactors = FALSE)
    # Align to our barcode order
    match_idx <- match(barcodes, df$Barcode)
    df$Cluster[match_idx]
}

cluster_graph  <- load_cluster("graphclust")    # variable K (10 in this dataset)
cluster_k10    <- load_cluster("kmeans_10_clusters")

K_g <- length(unique(cluster_graph))
K_k <- length(unique(cluster_k10))
cat(sprintf("    graph-based clusters: K=%d; K-means K=%d\n", K_g, K_k))

# Hard-assignment composition matrix (S x K)
hard_P <- function(cluster_vec) {
    K <- length(unique(cluster_vec))
    P <- matrix(0, nrow = length(cluster_vec), ncol = K)
    for (k in seq_len(K)) P[cluster_vec == k, k] <- 1
    P
}

P_hard_graph <- hard_P(cluster_graph)
P_hard_k10   <- hard_P(cluster_k10)

# Pseudo-bulk cell-type-specific mean expression: each row of mu_pb is
# average Xbar across spots in that cluster.
pseudobulk_mu <- function(Xbar, cluster_vec) {
    K <- length(unique(cluster_vec))
    mu <- matrix(0, nrow = ncol(Xbar), ncol = K)
    for (k in seq_len(K)) mu[, k] <- colMeans(Xbar[cluster_vec == k, , drop = FALSE])
    mu
}

mu_pb_graph <- pseudobulk_mu(Xbar, cluster_graph)
mu_pb_k10   <- pseudobulk_mu(Xbar, cluster_k10)

# Cell-total residual with hard cluster assignment + pseudo-bulk mu
# (this is the simplest "deconvolution method": each spot = mean of its cluster)
fitted_hard_graph <- P_hard_graph %*% t(mu_pb_graph)
fitted_hard_k10   <- P_hard_k10   %*% t(mu_pb_k10)

residual_metric <- function(fitted, Xbar, eps = 1e-6) {
    err <- fitted - Xbar
    rel <- abs(err) / pmax(abs(Xbar), eps)
    list(abs_max = max(abs(err)),
         abs_median = median(abs(err)),
         rel_max = max(rel),
         rel_median = median(rel),
         frob_rel = sqrt(sum(err^2)) / sqrt(sum(Xbar^2)),
         spot_mean_match = {
             # Cell-total claim: sum_j fitted_sj should equal sum_j Xbar_sj
             # (total expression per spot). Report max relative deviation.
             obs_sums <- rowSums(Xbar)
             fit_sums <- rowSums(fitted)
             max(abs(fit_sums - obs_sums) / pmax(obs_sums, eps))
         })
}

resid_hard_graph <- residual_metric(fitted_hard_graph, Xbar)
resid_hard_k10   <- residual_metric(fitted_hard_k10, Xbar)

# Rank of hard composition matrices (each row is e_k)
rank_hard_graph <- rank_diagnostic(P_hard_graph)
rank_hard_k10   <- rank_diagnostic(P_hard_k10)

cat(sprintf("    hard-cluster (K=%d): cell-total median residual = %.3g\n",
            K_g, resid_hard_graph$abs_median))

# ---------------------------------------------------------------
# Soft composition via NMF: K=10 and K=20
# ---------------------------------------------------------------
cat("[5/5] NMF at K=10 and K=20 (this is the slow part)...\n")

n_iter_nmf <- 150

t0 <- Sys.time()
fit_k10 <- fit_nmf(Xbar, K = 10, n_iter = n_iter_nmf, seed = 1)
t1 <- Sys.time()
cat(sprintf("    K=10 NMF: %.1f sec\n", as.numeric(difftime(t1, t0, units = "secs"))))

fit_k20 <- fit_nmf(Xbar, K = 20, n_iter = n_iter_nmf, seed = 2)
t2 <- Sys.time()
cat(sprintf("    K=20 NMF: %.1f sec\n", as.numeric(difftime(t2, t1, units = "secs"))))

fitted_nmf_k10 <- fit_k10$P %*% t(fit_k10$mu)
fitted_nmf_k20 <- fit_k20$P %*% t(fit_k20$mu)
resid_nmf_k10 <- residual_metric(fitted_nmf_k10, Xbar)
resid_nmf_k20 <- residual_metric(fitted_nmf_k20, Xbar)
rank_nmf_k10  <- rank_diagnostic(fit_k10$P)
rank_nmf_k20  <- rank_diagnostic(fit_k20$P)

# Replicate variance at K=20 (M-min1): repeat NMF over 5 random inits
# to quantify seed-to-seed variability of the 0.077 Frobenius residual.
cat("    K=20 NMF replicate variance (5 seeds)...\n")
nmf_k20_seeds <- 1:5
frob_replicates <- numeric(length(nmf_k20_seeds))
for (s_idx in seq_along(nmf_k20_seeds)) {
    fit_s <- fit_nmf(Xbar, K = 20, n_iter = n_iter_nmf, seed = nmf_k20_seeds[s_idx])
    resid_s <- residual_metric(fit_s$P %*% t(fit_s$mu), Xbar)
    frob_replicates[s_idx] <- resid_s$frob_rel
    cat(sprintf("      seed %d: Frobenius-relative residual = %.4f\n",
                nmf_k20_seeds[s_idx], resid_s$frob_rel))
}
frob_k20_mean <- mean(frob_replicates)
frob_k20_sd   <- sd(frob_replicates)
cat(sprintf("    K=20 across %d seeds: %.4f +/- %.4f\n",
            length(nmf_k20_seeds), frob_k20_mean, frob_k20_sd))

cat(sprintf("    NMF K=10: cell-total median residual = %.3g (rank P = %d/%d)\n",
            resid_nmf_k10$abs_median, rank_nmf_k10$rank, 10))
cat(sprintf("    NMF K=20: cell-total median residual = %.3g (rank P = %d/%d)\n",
            resid_nmf_k20$abs_median, rank_nmf_k20$rank, 20))

# ---------------------------------------------------------------
# Singleton-augmentation check: construct a deliberately-impoverished
# scenario from the real dataset, then show singletons restore rank.
#
# Scenario: suppose the experiment sampled only a region of the brain
# that contains spots from a strict subset of cell types (say, 5 of
# the 10 K-means clusters). The composition matrix P over those spots
# spans only 5 dimensions of the 10-dimensional cell-type space.
# Singleton augmentation (one cell per missing cell type, from a
# single-cell-resolution reference) restores rank to 10.
# ---------------------------------------------------------------
K_target <- K_k                      # 10
n_present <- 5                       # cell types observed in restricted region
present_clusters <- 1:n_present
spots_restricted <- which(cluster_k10 %in% present_clusters)

# Hard-assignment composition over restricted spots, padded to K_target cols
P_restricted <- matrix(0, length(spots_restricted), K_target)
for (k in present_clusters) {
    rows <- which(cluster_k10[spots_restricted] == k)
    P_restricted[rows, k] <- 1
}
rank_restricted <- rank_diagnostic(P_restricted)
# Singleton augmentation: a reference platform gives one cell per type
singleton_rows <- diag(K_target)
P_augmented <- rbind(P_restricted, singleton_rows)
rank_augmented <- rank_diagnostic(P_augmented)

cat(sprintf("    restricted-region scenario: %d spots from %d/%d cell types\n",
            length(spots_restricted), n_present, K_target))
cat(sprintf("    rank(spots only)        = %d / %d\n",
            rank_restricted$rank, K_target))
cat(sprintf("    rank(spots + singletons) = %d / %d (min sv = %.3g)\n",
            rank_augmented$rank, K_target, rank_augmented$min_sv))

# ---------------------------------------------------------------
# Effective rank of the NMF-inferred composition matrix at K=20
# Tests the framework's prediction that biological co-occurrence
# can collapse effective rank below the nominal K.
# ---------------------------------------------------------------
sv_P_nmf_k20 <- svd(fit_k20$P, nu = 0, nv = 0)$d
eff_rank_P_k20_1pct <- sum(sv_P_nmf_k20 > 0.01 * sv_P_nmf_k20[1])
eff_rank_P_k20_5pct <- sum(sv_P_nmf_k20 > 0.05 * sv_P_nmf_k20[1])
cond_number_P_k20 <- sv_P_nmf_k20[1] / sv_P_nmf_k20[20]
cat(sprintf("    NMF K=20 inferred composition: eff-rank @1%% = %d, @5%% = %d, ",
            eff_rank_P_k20_1pct, eff_rank_P_k20_5pct))
cat(sprintf("kappa = %.3g\n", cond_number_P_k20))

# ---------------------------------------------------------------
# Save and summarize
# ---------------------------------------------------------------
results_visium <- list(
    seed = 20260523,
    timestamp = Sys.time(),
    dataset = "10x V1_Adult_Mouse_Brain (filtered)",
    n_spots = nrow(X_raw),
    n_genes_total = ncol(X_raw),
    n_genes_hvg = n_hvg,
    median_umi_per_spot = median(N_s),
    poisson_floor_frob_rel = poisson_floor_frob_rel,
    sv_spectrum = sv,
    sv_norm = sv_norm,
    eff_rank_1pct = eff_rank_1pct,
    eff_rank_5pct = eff_rank_5pct,
    K_graph = K_g,
    K_kmeans10 = K_k,
    hard_clusters = list(
        graph = list(
            K = K_g,
            cell_total = resid_hard_graph,
            rank_P = rank_hard_graph
        ),
        kmeans10 = list(
            K = K_k,
            cell_total = resid_hard_k10,
            rank_P = rank_hard_k10
        )
    ),
    nmf = list(
        K10 = list(cell_total = resid_nmf_k10, rank_P = rank_nmf_k10),
        K20 = list(cell_total = resid_nmf_k20, rank_P = rank_nmf_k20),
        K20_replicates = list(
            seeds = nmf_k20_seeds,
            frob_rel = frob_replicates,
            mean = frob_k20_mean,
            sd = frob_k20_sd
        )
    ),
    rank_restoration = list(
        K_target = K_target,
        n_present = n_present,
        n_spots_restricted = length(spots_restricted),
        rank_spots_only = rank_restricted$rank,
        rank_with_singletons = rank_augmented$rank,
        min_sv_augmented = rank_augmented$min_sv
    ),
    nmf_effective_rank = list(
        K = 20,
        eff_rank_1pct = eff_rank_P_k20_1pct,
        eff_rank_5pct = eff_rank_P_k20_5pct,
        condition_number = cond_number_P_k20,
        sv = sv_P_nmf_k20
    )
)

saveRDS(results_visium, file = file.path(proj_root, "results_visium.rds"))

cat("\n========== VISIUM SUMMARY ==========\n")
cat(sprintf("Dataset: %d spots x %d genes (HVG subset: %d)\n",
            results_visium$n_spots, results_visium$n_genes_total, n_hvg))
cat(sprintf("Median UMI per spot: %.0f\n", results_visium$median_umi_per_spot))
cat(sprintf("\nSV spectrum: effective rank @ 1%% = %d, @ 5%% = %d\n",
            eff_rank_1pct, eff_rank_5pct))
cat(sprintf("\nCell-total residual (median abs / Frobenius rel / spot-sum max-rel):\n"))
cat(sprintf("  hard clusters (K=%d, graph):  %.3g / %.3g / %.3g\n",
            K_g, resid_hard_graph$abs_median, resid_hard_graph$frob_rel,
            resid_hard_graph$spot_mean_match))
cat(sprintf("  hard clusters (K=%d, kmeans): %.3g / %.3g / %.3g\n",
            K_k, resid_hard_k10$abs_median, resid_hard_k10$frob_rel,
            resid_hard_k10$spot_mean_match))
cat(sprintf("  NMF K=10:                     %.3g / %.3g / %.3g\n",
            resid_nmf_k10$abs_median, resid_nmf_k10$frob_rel,
            resid_nmf_k10$spot_mean_match))
cat(sprintf("  NMF K=20:                     %.3g / %.3g / %.3g\n",
            resid_nmf_k20$abs_median, resid_nmf_k20$frob_rel,
            resid_nmf_k20$spot_mean_match))
cat(sprintf("\nRank restoration (restricted region, %d spots from %d/%d types):\n",
            length(spots_restricted), n_present, K_target))
cat(sprintf("  rank(spots only)        = %d / %d\n",
            rank_restricted$rank, K_target))
cat(sprintf("  rank(spots + singletons) = %d / %d (min sv = %.3g)\n",
            rank_augmented$rank, K_target, rank_augmented$min_sv))
cat(sprintf("\nNMF K=20 inferred composition effective rank: @1%% = %d, @5%% = %d, kappa = %.3g\n",
            eff_rank_P_k20_1pct, eff_rank_P_k20_5pct, cond_number_P_k20))

cat("\nSaved to results_visium.rds\n")
