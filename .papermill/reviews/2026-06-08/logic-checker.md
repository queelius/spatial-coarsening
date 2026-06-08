# Logic and proof check: spatial-coarsening (2026-06-08)

Scope: proof correctness, logical-chain integrity, claim-to-support coupling.
All three theorems and the RCTD worked derivation were checked line by line
against the manuscript text; the two load-bearing numerical claims (kernel
dimension, saturated vs non-saturated residual) were reproduced by running
`scripts/cell_total_kernel.R`.

## Verdict: SOUND. No critical or major logic findings.

The proofs are correct and the empirical claims are correctly scoped. This is a
mature draft; the prior rounds closed the substantive logic items
(intersection-of-kernels correction, Poisson-sampling statement, positivity
caveat in the necessary direction). What remains is minor polish.

## Theorem-by-theorem

### thm:rank (identifiability of cell-type-specific expression): SOUND
- Statement is precise: Poisson sampling, `P` known, identifiability of
  `mu_j in R_{>=0}^K` iff `P` has full column rank `K`.
- Necessary direction: correct. Picks `v != 0` with `Pv = 0`, perturbs
  `mu_j' = mu_j + v`, and explicitly restricts to the case where `mu_j` has all
  positive entries so the perturbation stays in the nonnegative orthant. This is
  the right way to handle the constrained domain: it is a local (interior)
  non-identifiability argument, which is exactly what is needed. The reduction
  "identifiability of mu_j is equivalent to identifiability of the mean vector
  m_j = P mu_j, because the Poisson family is parametrized by its mean" is
  correct.
- Sufficient direction: correct. `P^T P` invertible under full column rank;
  injective linear map; explicit left inverse `mu_j = (P^T P)^{-1} P^T m_j`.
- rmk:rank-extensions (i)-(iii): all three are correct. (i) sample-size
  independence of identifiability vs the separate consistency regularity
  condition is stated cleanly; (ii) cell-type-independent dropout folds into a
  known multiplicative constant; (iii) cell-type-dependent dropout violates C2
  and is correctly handed off to the mdrelax companion.

### thm:cell-total-st (cell-total consistency): SOUND; the corrected version is the right one
- Part (a) (aggregate identity `P^T R = 0` and `R U = 0`): these are exactly the
  two blocks of the normal equations from the interior score equations for the
  unregularized Poisson-mean (or Frobenius) factorization. Correct.
- Part (b) (per-entry identity in the saturated regime `rank(Xbar) <= K`):
  correct, and the proof sketch correctly REFUTES the tempting wrong argument
  (that joint full column rank of `P` and `U` forces `R = 0`). The operator
  `Lambda: R -> (P^T R, R U)` has kernel dimension `(S-K)(J-K) > 0` whenever
  `K < min(S,J)`, so the score equations alone do not pin `R = 0`. This is a
  genuinely good catch by the author and the corrected statement is the stronger,
  honest one.
- VERIFIED NUMERICALLY: `Rscript scripts/cell_total_kernel.R` reproduces
  kernel dimension `(S-K)(J-K)` for all seven tested shapes (e.g. (2,1,2)->1,
  (4,2,3)->2, (6,2,5)->12, and 0 at K=min(S,J)); saturated case gives
  `|P^T R| = 1.5e-13`, per-entry `max|R| = 0`; non-saturated gives
  `|P^T R| = 2.0e-9`, `|R U| = 6.8e-15`, per-entry `max|R| = 0.097`. Every one of
  these matches the manuscript (validation.tex lines 62-82 and the theorem text)
  to the quoted precision.
- The scope paragraph correctly excludes Cell2location (hierarchical prior) and
  CARD (spatial-smoothness penalty) as breaking the unconstrained-optimum
  hypothesis. The connection to ivich2025missing (their residual-recovery
  diagnostic is the empirical counterpart of part (b)) is a legitimate and
  well-placed claim: that paper does find a missing reference cell type leaves a
  well-fitting aggregate while biasing per-type estimates.

### thm:bias-marker (first-order bias under marker-gene perturbation): SOUND
- The three assumptions (i full column rank of `M^*`, ii twice differentiability,
  iii nonsingular Hessian `H_pp`) are exactly the implicit-function-theorem
  hypotheses needed.
- The sensitivity matrix `J_{p,M} = -H_pp^{-1} J_{pM}` is the standard IFT
  derivative of the score-defined map `M -> p_hat(M)`. Correct.
- The `O_p(n^{-1/2})` finite-sample term and `O(||Delta M||^2)` remainder are the
  right orders.
- The conditioning algebra in the recovery subsection is exact: at the
  unconstrained least-squares optimum `H_pp = M^T M`, so
  `||H_pp^{-1}|| = sigma_min(M)^{-2}` in spectral norm. Correct.
- The proof is labeled `[Sketch]` and defers the full heteroskedastic-Poisson
  derivation to the scrna-coarsening companion (cited with a live Zenodo DOI).
  This is the declared framework-series convention and is acceptable for an
  application paper, but see the minor note below on the asymmetry of rigor.

## Internal-consistency / cross-claim checks

- The RCTD worked example (translation.tex sec:rctd-worked) is logically tight.
  The C1/C2/C3 mapping is concrete, the Poisson likelihood is the
  ignorable-coarsening likelihood under the stated parametric choice, and the
  crucial rank distinction is correct and consistently maintained throughout the
  paper: per-spot `p_s` recovery (mu fixed) is governed by `sigma_min(mu)`
  (thm:bias-marker territory), while joint `mu` recovery is governed by
  `sigma_min(P)` (thm:rank territory). This distinction is stated identically in
  translation.tex (lines 110-115), validation.tex (lines 209-213), and is the
  organizing logic of the joint-mu experiment. No drift.
- The abstract's claim "off the saturated regime (where the observed-mean matrix
  has rank exceeding the number of cell types)" is consistent with thm:cell-total
  part (b). VERIFIED against main.tex lines 92-93.
- Numerical reproduction extends to the RCTD head-to-head: `rctd_compare.R`
  gives oracle/RCTD median TV 0.0261/0.0462 (random) and 0.0114/0.0444
  (structured), Spearman 0.116/0.249, all matching validation.tex.

## Minor logic notes (not blocking)

- L-min-1 (rigor asymmetry, shared with prose lens): thm:rank now carries a full
  self-contained proof while thm:cell-total and thm:bias-marker carry `[Sketch]`
  proofs that defer to the companion. The cell-total sketch is actually a
  complete argument (the kernel-dimension reasoning is all there); only the
  bias-bound genuinely defers. Consider relabeling the cell-total proof as a full
  `\begin{proof}` (drop `[Sketch]`), since nothing material is deferred for it.
  This is cosmetic but would remove an apparent inconsistency a careful referee
  will notice.
- L-min-2 (saturated-regime intuition): part (b) holds "exactly when the residual
  is squeezed out by a rank constraint." The text could note in one half-sentence
  that on real noisy data `rank(Xbar) = min(S,J) > K` generically, so part (b)
  essentially never holds exactly off simulated/oracle inputs, and only part (a)
  is testable. The validation section already says this operationally; making it
  explicit in the theorem's scope paragraph would tighten the logical bridge from
  theorem to the real-data section.

## Cross-verification handoff

No critical or low-confidence logic findings to route. The one item worth a
second opinion is whether the `[Sketch]` deferral on thm:bias-marker is a logic
gap or an acceptable framing decision; routed to methodology-auditor (can the
bias bound be reproduced numerically even without the closed-form derivation?).
Methodology confirms the conditioning prediction is numerically exact, so the
deferral is a presentation choice, not a soundness gap.
