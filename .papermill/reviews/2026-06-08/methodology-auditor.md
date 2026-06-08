# Methodology audit: spatial-coarsening (2026-06-08)

Scope: experimental design, statistical rigor, reproducibility, honesty of
empirical claims. Reproduced the load-bearing scripts directly.

## Verdict: STRONG. No critical or major methodology findings.

The empirical program is unusually well executed for an application-of-theory
paper: a simulation study that tests each of the three theorems, a Visium-scale
synthetic case with a structured (rank-deficient) scenario, a real public 10x
Visium dataset used for diagnostics, and a faithful RCTD-core re-implementation
for a method-vs-method check. Every numerical claim I spot-checked reproduces to
the digit. The scoping is honest and consistently confines empirical claims to
conditions-on-inputs rather than per-cell-type recovery.

## Reproducibility (verified by execution)

- `scripts/cell_total_kernel.R`: kernel dimension `(S-K)(J-K)` for all seven
  tested shapes; saturated `|P^T R|=1.5e-13`, per-entry `max|R|=0`;
  non-saturated `|P^T R|=2.0e-9`, `|R U|=6.8e-15`, per-entry `0.097`. Matches
  validation.tex and thm:cell-total-st exactly.
- `scripts/rctd_compare.R`: random Dirichlet oracle/RCTD median TV 0.0261/0.0462,
  structured 0.0114/0.0444, Spearman 0.116/0.249. Matches validation.tex
  (0.026/0.046, 0.011/0.044, 0.12/0.25) exactly.
- Figures (`rank_diagnostic.pdf`, `marker_bias.pdf`, `visium_spectrum.pdf`)
  visually confirm the quoted numbers: rank step function at S/K=1 independent of
  alpha; conditioning peak near alpha=0.5; marker-bias slope -0.78 beating the
  1/sqrt(|M|) reference; NMF K=20 real-data residual 0.08, hard-cluster 0.41/0.33.
- Build is clean (0 undefined, 0 over/underfull boxes); seed 20260517 stated for
  the main run, 20260603 for the kernel script.

This level of script-to-text fidelity is the paper's strongest asset and should
be preserved through any revision.

## Design assessment

- The simulation DGP (log-normal per-cell-type means, Dirichlet composition,
  Poisson spot counts) is the standard ST generative model and is the right
  testbed for the rank and cell-total claims.
- The structured G=6 scenario is the methodologically important one: it
  manufactures genuine rank deficiency (cell types co-occurring in fixed
  proportion) and then demonstrates singleton-augmentation restoration. This is
  the cleanest possible test of the framework's central mechanism.
- The joint-(mu, P) experiment (validation.tex lines 171-188) correctly closes
  the gap that the earlier rctd_compare left open: rctd_compare supplies mu as
  known and so only tests per-spot recovery (thm:bias-marker territory), whereas
  joint NMF tests thm:rank directly via variance-fraction and cosine recovery of
  mu_true. The contrast between singleton-augmented (0.94 cosine by addition) and
  random-Dirichlet (0.94 cosine by chance) is a sharp, well-designed control:
  it isolates rank from structure as the operative condition.
- The noise-floor decomposition (Frobenius-relative floor 0.053 vs observed
  0.077) is dimensionally consistent and correctly derived from the plug-in
  Poisson variance. The prior round's dimensional-consistency fix held.

## Honesty / scoping (PASS)

- The paper is NOT overclaimed as a real-data per-cell-type validation. The
  "Scope of the empirical validation" paragraph (validation.tex lines 332-346)
  explicitly confines every real-data claim to conditions-on-inputs that any
  method shares, flags the hard-cluster category issue upfront, and defers
  head-to-head benchmarking to the journal companion with a stated reason.
- The hard-cluster pseudobulk is correctly framed as a constrained estimator and
  NOT a test of thm:cell-total-st; NMF is the actual theorem test. This is the
  right call and is stated plainly.
- The in-dataset CellRanger reference (rather than external Allen Atlas) is
  justified by the conditions-on-inputs argument and the elimination of
  ID-mapping/batch confounds. Reasonable; the discussion concedes a fully
  external reference would strengthen specific-recovery claims.

## Major (methodology positioning, shared with novelty lens): M-1

The one substantive methodology limitation is the absence of a head-to-head
deconvolution benchmark (RCTD vs Cell2location vs Tangram on the same input).
The paper handles this honestly by deferring it, and the deferral is defensible
for a conditions-on-inputs paper. BUT for the named primary venue (Genome
Biology) and especially the Nature Methods stretch target, a methods-savvy
referee will ask for at least one real method-vs-method comparison, because the
abstract's "subsumes ... as special cases ... gives a precise vocabulary for when
each method is appropriate" invites exactly that test. The RCTD-style
re-implementation already in hand is a partial answer; extending it to one
real published method (Cell2location is the natural second case, since its
hierarchical prior is the most distinct from the unregularized form the cell-
total theorem assumes) on the existing synthetic Visium-scale data would convert
the largest methods-venue objection into a demonstrated result. This is a
strengthening item, not a soundness defect. Cross-routed from/to novelty (NV-3).

## Minor methodology notes

- M-min-1: the marker-bias experiment uses greedy selection by across-type
  expression range; the iid `-0.5` baseline is derived as a back-of-envelope
  argument. The derivation is correct but the baseline curve in
  `marker_bias.pdf` would benefit from a one-line caption note that the slope
  comparison is the claim, not the absolute offset (the offset depends on the
  unspecified pool size J^*). Minor.
- M-min-2: the real-data UMI normalization works in `Xbar = X/N_s`; for Visium,
  `N_s` is the per-spot total count, used as a library-size proxy for cell number.
  Cell number per spot is not actually observed on Visium. The paper's mean-model
  `X_sj ~ N_s sum_k p_sk mu_jk` conflates "cells per spot" with "total counts per
  spot" in the real-data section. The theorems are unaffected (they hold for any
  known nonnegative `N_s`), but a half-sentence acknowledging that `N_s` is a
  count-based proxy for cell number on sequencing platforms would preempt a
  reviewer who knows Visium does not report cell counts. Minor but worth a line.
- M-min-3: 25 replicates for the noisy marker-bias and cell-total runs is
  adequate for medians; no confidence bands are reported on the TV medians in the
  RCTD head-to-head (q90 is reported, which is fine). Not blocking.
