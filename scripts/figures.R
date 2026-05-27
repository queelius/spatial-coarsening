# Generate PDF figures for the validation section.
# Reads results.rds, writes figures/rank_diagnostic.pdf and
# figures/marker_bias.pdf.
#
# Usage:
#   cd papers/spatial-coarsening
#   Rscript scripts/figures.R

script_dir <- local({
    args <- commandArgs(trailingOnly = FALSE)
    file_arg <- grep("^--file=", args, value = TRUE)
    if (length(file_arg) == 1L) {
        dirname(normalizePath(sub("^--file=", "", file_arg)))
    } else {
        normalizePath(".")
    }
})

proj_root <- normalizePath(file.path(script_dir, ".."))
results <- readRDS(file.path(proj_root, "results.rds"))
fig_dir <- file.path(proj_root, "figures")
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

# -----------------------------------------------------------------
# Figure 1: rank-condition diagnostic at K = 10
# Subpanel A: full-rank probability vs S/K (separately by alpha)
# Subpanel B: median minimum singular value vs alpha (separately by S/K)
# -----------------------------------------------------------------

rank_data <- subset(results$exp1_rank, K == 10)

pdf(file.path(fig_dir, "rank_diagnostic.pdf"), width = 7, height = 3.2)
op <- par(mfrow = c(1, 2), mar = c(4.2, 4.2, 2.2, 1), mgp = c(2.4, 0.8, 0))

# Panel A: full-rank probability vs S/K
alphas <- sort(unique(rank_data$alpha))
cols <- hcl.colors(length(alphas), palette = "viridis", rev = TRUE)
plot(NA, xlim = range(rank_data$S_per_K), ylim = c(-0.02, 1.05),
     xlab = "S / K", ylab = "P(full column rank)",
     main = "A. Rank condition (K=10)",
     log = "x", cex.main = 0.95)
for (a_idx in seq_along(alphas)) {
    sub <- subset(rank_data, alpha == alphas[a_idx])
    sub <- sub[order(sub$S_per_K), ]
    lines(sub$S_per_K, sub$full_rank_prob, col = cols[a_idx], lwd = 2)
    points(sub$S_per_K, sub$full_rank_prob, col = cols[a_idx], pch = 19, cex = 0.9)
}
abline(v = 1, lty = 3, col = "grey50")
legend("right", legend = sprintf("a=%.1f", alphas),
       col = cols, lwd = 2, bty = "n", cex = 0.75,
       title = "Dirichlet")

# Panel B: conditioning (median min singular value) vs alpha,
# only for S/K >= 1 (where rank is full)
sub_b <- subset(rank_data, S_per_K >= 1 & !is.na(median_min_sv))
ratios <- sort(unique(sub_b$S_per_K))
cols2 <- hcl.colors(length(ratios), palette = "plasma", rev = TRUE)
y_lim <- range(sub_b$median_min_sv)
plot(NA, xlim = range(sub_b$alpha), ylim = y_lim,
     xlab = expression("Dirichlet concentration " * alpha),
     ylab = expression("median " * sigma[min](P)),
     main = "B. Conditioning",
     log = "xy", cex.main = 0.95)
for (r_idx in seq_along(ratios)) {
    sub <- subset(sub_b, S_per_K == ratios[r_idx])
    sub <- sub[order(sub$alpha), ]
    lines(sub$alpha, sub$median_min_sv, col = cols2[r_idx], lwd = 2)
    points(sub$alpha, sub$median_min_sv, col = cols2[r_idx], pch = 19, cex = 0.9)
}
legend("bottomright", legend = sprintf("S/K=%g", ratios),
       col = cols2, lwd = 2, bty = "n", cex = 0.75)

par(op)
dev.off()
cat("Wrote", file.path(fig_dir, "rank_diagnostic.pdf"), "\n")

# -----------------------------------------------------------------
# Figure 2: marker-gene bias vs panel size |M|
# -----------------------------------------------------------------

bias_data <- results$exp3_summary
slope <- results$exp3_loglog_slope

pdf(file.path(fig_dir, "marker_bias.pdf"), width = 4.4, height = 3.4)
op <- par(mar = c(4.2, 4.2, 2.0, 1.0), mgp = c(2.4, 0.8, 0))

x_lim <- range(bias_data$M)
y_lim <- range(c(bias_data$median_tv, bias_data$q90_tv))
plot(NA, xlim = x_lim, ylim = y_lim,
     xlab = expression("marker-gene panel size " * "|" * M * "|"),
     ylab = "total-variation bias of composition",
     main = "Marker-gene bias",
     log = "xy", cex.main = 0.95)

# 90th-percentile band
polygon(c(bias_data$M, rev(bias_data$M)),
        c(bias_data$median_tv, rev(bias_data$q90_tv)),
        col = adjustcolor("steelblue", 0.18), border = NA)

# Median trace
lines(bias_data$M, bias_data$median_tv, col = "steelblue4", lwd = 2)
points(bias_data$M, bias_data$median_tv, col = "steelblue4", pch = 19)

# Reference line: 1/sqrt(M), normalized to pass through the median bias
# at the smallest |M|.
m_ref <- bias_data$M
y_ref_sqrt <- bias_data$median_tv[1] * sqrt(bias_data$M[1] / m_ref)
lines(m_ref, y_ref_sqrt, col = "grey40", lty = 2, lwd = 1.5)

# Empirical fitted slope reference
y_ref_emp <- bias_data$median_tv[1] * (bias_data$M[1] / m_ref)^(-slope)
# slope is negative; (M/M_ref)^slope = (M/M_ref)^(-0.78) and we want
# decreasing. y_ref_emp = y0 * (M/M0)^slope works because slope is negative.
y_ref_emp <- bias_data$median_tv[1] * (m_ref / bias_data$M[1])^slope
lines(m_ref, y_ref_emp, col = "firebrick", lty = 3, lwd = 1.5)

legend("topright", bty = "n", cex = 0.8,
       legend = c("median bias",
                  expression(1 / sqrt("|" * M * "|") * " reference"),
                  sprintf("fit slope = %.2f", slope)),
       col = c("steelblue4", "grey40", "firebrick"),
       lty = c(1, 2, 3), lwd = c(2, 1.5, 1.5),
       pch = c(19, NA, NA))

par(op)
dev.off()
cat("Wrote", file.path(fig_dir, "marker_bias.pdf"), "\n")

# -----------------------------------------------------------------
# Figure 3: real-data Visium singular-value spectrum + cell-total residual
# Optional; only generated if results_visium.rds exists.
# -----------------------------------------------------------------

visium_path <- file.path(proj_root, "results_visium.rds")
if (file.exists(visium_path)) {
    visium <- readRDS(visium_path)

    pdf(file.path(fig_dir, "visium_spectrum.pdf"), width = 7, height = 3.2)
    op <- par(mfrow = c(1, 2), mar = c(4.2, 4.2, 2.2, 1), mgp = c(2.4, 0.8, 0))

    # Panel A: SV spectrum of centered log-normalized expression
    sv <- visium$sv_spectrum
    k_show <- 50
    rel_sv <- sv[seq_len(k_show)] / sv[1]
    plot(seq_len(k_show), rel_sv, type = "b", pch = 19, cex = 0.7,
         log = "y", lwd = 1.5, col = "steelblue4",
         xlab = "singular-value index k",
         ylab = expression(sigma[k] / sigma[1]),
         main = "A. Visium expression spectrum",
         cex.main = 0.95)
    abline(h = c(0.05, 0.01), lty = c(2, 3), col = "grey50")
    text(k_show, 0.05, "5%", pos = 4, cex = 0.7, col = "grey40", xpd = NA)
    text(k_show, 0.01, "1%", pos = 4, cex = 0.7, col = "grey40", xpd = NA)
    # Mark 10x graph-clusters and K-means K=10
    abline(v = c(visium$K_graph, visium$K_kmeans10), lty = 4, col = "firebrick", lwd = 1)
    legend("topright", bty = "n", cex = 0.75,
           legend = c(sprintf("graph K=%d", visium$K_graph),
                      sprintf("K-means K=%d", visium$K_kmeans10)),
           col = "firebrick", lty = 4)

    # Panel B: cell-total Frobenius-relative residual across estimators
    fits <- c("hard\nK=7", "hard\nK=10", "NMF\nK=10", "NMF\nK=20")
    frob_vals <- c(visium$hard_clusters$graph$cell_total$frob_rel,
                   visium$hard_clusters$kmeans10$cell_total$frob_rel,
                   visium$nmf$K10$cell_total$frob_rel,
                   visium$nmf$K20$cell_total$frob_rel)
    bp <- barplot(frob_vals, names.arg = fits,
                  col = c("grey75", "grey60", "steelblue3", "steelblue4"),
                  border = NA,
                  ylim = c(0, max(frob_vals) * 1.18),
                  ylab = expression("Frobenius relative residual"),
                  main = "B. Cell-total fit on real data",
                  cex.main = 0.95, cex.names = 0.85, las = 1)
    text(bp, frob_vals, sprintf("%.2f", frob_vals), pos = 3, cex = 0.85)

    par(op)
    dev.off()
    cat("Wrote", file.path(fig_dir, "visium_spectrum.pdf"), "\n")
}
