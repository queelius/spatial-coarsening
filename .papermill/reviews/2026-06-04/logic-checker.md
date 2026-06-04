# Logic Checker Report (2026-06-04)

## Scope

Proof-priority pass requested by the area chair, focused on:
1. The rank condition for identifiability of cell-type-specific expression
   (`thm:rank`, identifiability.tex lines 17-51).
2. The cell-total consistency theorem and its proof, especially the
   intersection-of-kernels step added in a prior fix (`thm:cell-total-st`,
   identifiability.tex lines 99-150).
3. The marker-gene bias bound (`thm:bias-marker`, methodology.tex lines 39-72).
4. Verification that the synthesis-paper cross-reference and the prior review
   fixes integrated cleanly.

Every load-bearing algebraic claim below was checked by independent
computation (Python/NumPy and the paper's own R script), not by reading alone.

## Critical findings

None.

## Verified-sound (the proof-priority items)

### thm:rank (rank condition) -- SOUND

Statement: under Poisson sampling with P known, mu_j is identifiable iff P has
full column rank K. The proof (identifiability.tex 28-51) is correct and now
self-contained:

- Reduction to mean: correct. Poisson is identified by its mean, so
  identifiability of mu_j is equivalent to injectivity of mu_j -> P mu_j. Clean.
- Necessary direction: if rank(P) < K there is v != 0 with Pv = 0, and
  mu_j' = mu_j + v gives the same mean. Correct.
- Sufficient direction: full column rank => P^T P invertible => left inverse
  (P^T P)^{-1} P^T recovers mu_j. Correct.

The background-section precursor (`thm:bg-id`) gives a separating-but-rank-
deficient counterexample: m=4 with candidate sets {1,2},{3,4},{1,3},{2,4}.
VERIFIED numerically: that indicator matrix has rank 3 < 4 with null vector
proportional to (1,-1,-1,1). The claim "separability is necessary but not
sufficient" is correct.

Residual nit (carried from prior round, still minor): the necessary direction
restricts to mu_j with all-positive entries so that mu_j' stays in the
nonnegative orthant. The honest statement is "non-identifiable on the open
subset where the perturbation stays nonnegative." One clause; non-load-bearing.

### thm:cell-total-st (cell-total consistency) -- SOUND, and the prior fix is correct

This is the item the area chair flagged for the intersection-of-kernels step.
The CURRENT proof (identifiability.tex 129-150) is the corrected, stronger
version, and it is right. Specifically:

- Part (a), aggregate identity: the interior score equations give
  P^T R = 0 and R U = 0. Correct (these are exactly the normal equations of the
  bilinear least-squares / Poisson stationarity).
- Part (b), per-entry identity: the proof EXPLICITLY REJECTS the tempting (and
  wrong) argument that joint full column rank of P-hat and U-hat forces R = 0.
  It states the operator Lambda: R -> (P^T R, R U) has kernel dimension
  (S-K)(J-K), positive whenever K < min(S,J), so the aggregate identity does
  NOT force R = 0 in general; R = 0 holds exactly in the saturated regime
  rank(Xbar) <= K.

VERIFIED numerically (two independent routes):
- Kernel dimension (S-K)(J-K): checked across shapes (2,1,2)->1, (4,2,3)->2,
  (6,2,5)->12, (8,3,10)->35, (5,5,7)->0, (7,3,3)->0. All match exactly.
- The paper's own `scripts/cell_total_kernel.R` reproduces the quoted
  validation numbers: saturated rank(Xbar)=3<=K gives aggregate |P^T R|~1.5e-13
  and per-entry max|R|=0.0000; non-saturated rank(Xbar)=5>K gives aggregate
  still ~0 (|P^T R|~2e-9, |R U|~7e-15) but per-entry max|R|=0.097, matching
  validation.tex line 78.

This is an important note for the area chair: an EARLIER review round
(2026-05-27 logic-checker, finding "L-M1") flagged that the proof claimed
"R = 0 follows from full column rank of both factors" and asked for a one-line
fix. The current text does NOT make that error; it makes the OPPOSITE, correct
claim with the exact kernel-dimension count. The fix was applied and is
mathematically sound. The intersection-of-kernels step the area chair asked
about is correct as written. No further action needed on this proof.

Minor presentational point: part (b) is labeled a "[Sketch]" but it is now
essentially a complete argument (it even gives the kernel dimension and the
saturation criterion). It could drop the "Sketch" qualifier for parts (a) and
the kernel-dimension claim, reserving any hedging for the "Otherwise the
unexplained component ... survives" sentence, which is the one genuinely
informal step.

### thm:bias-marker (marker-gene bias bound) -- SOUND as a first-order/IFT result

Statement: hat-p_s(Delta M) - p_s* = J_{p,M} vec(Delta M) + O_p(n^{-1/2}) +
O(||Delta M||^2), with J_{p,M} = -H_pp^{-1} J_pM.

- The implicit-function-theorem construction is correctly set up: assumptions
  (i) M* full column rank, (ii) C^2 loss, (iii) H_pp nonsingular at p_s* are
  exactly what the IFT needs to differentiate the score-defined map M -> p(M).
  The form J_{p,M} = -H_pp^{-1} J_pM is the standard IFT sensitivity. Correct.
- The downstream claim (methodology.tex 84-88) that for the least-squares form
  H_pp = M^T M and therefore ||H_pp^{-1}||_2 = sigma_min(M)^{-2} is VERIFIED
  numerically across (m,K) = (8,3),(20,5),(50,10): the spectral norm of
  (M^T M)^{-1} equals 1/sigma_min(M)^2 to machine precision in every case.
  The "bias inflates by sigma_min(M)^{-2}" conditioning claim is correct.

Caveat the paper already states honestly: the simplex constraint p >= 0,
1^T p = 1 means the relevant Hessian at an ACTIVE-constraint optimum is the
reduced/projected Hessian on the active face, not the raw M^T M. The paper
sidesteps this by writing "at the unconstrained optimum, H_pp = M^T M"
(methodology.tex 86), which is the correct hedge. For an interior optimum (all
proportions strictly positive) the unconstrained Hessian is the right object;
for boundary optima the bound is on the reduced problem. This is acceptable for
a first-order result and is consistent with how the paper scopes it. A theory
venue (AISTATS) would want one sentence acknowledging the active-set caveat.

The proof is correctly labeled a sketch and correctly defers the full
heteroskedastic-Poisson derivation to the companion; this is the framework-
series convention and is defensible for a conference-format paper.

## Major findings

### LG-1. The RCTD rank-condition clarification is now sound (prior seam closed)

**Location**: `sections/translation.tex` lines 105-115.

The prior round (2026-05-27, "L-M2") flagged that the RCTD worked example cited
the sigma_min(P) rank condition where it should distinguish RCTD's fixed-mu
operating mode (governed by sigma_min(mu)). The CURRENT text resolves this
correctly: "When hat-mu is taken fixed (RCTD's operating mode), the relevant
rank condition is on mu rather than on P: per-spot identifiability of p_s is
governed by sigma_min(mu) ... (the sigma_min(P) condition of thm:rank governs
joint mu recovery, which RCTD does not perform)." This is logically correct and
now cross-consistent with the validation section (lines 207-213) and the
joint-mu experiment. Not a defect; recorded as a verified-clean prior fix. I
keep it at "major" only to signal it was a previously-flagged item now closed.

## Minor findings

### LG-min1. thm:rank necessary-direction positivity caveat (carried, still open)
**Location**: identifiability.tex line 42. As above: "is not identifiable"
should read "is not identifiable on the open subset where the perturbation
remains nonnegative." One clause.

### LG-min2. Part (b) over-hedged as "[Sketch]"
**Location**: identifiability.tex line 129. The kernel-dimension argument is
complete, not a sketch. Consider relabeling or splitting the qualifier.

### LG-min3. mdrelax citation in the dropout remark is a gesture, not a pointer
**Location**: identifiability.tex remark item (iii), lines 64-68. "the regime
treated by [towell2026mdrelax]; identifiability degrades quantitatively in the
gap between max and min pi_k" would be tightened by a specific
proposition/lemma number in that companion. Carried from prior round.

## Cross-domain consistency of the synthesis cross-reference

**Location**: identifiability.tex lines 164-168. The added sentence positions
cell-total consistency as "a special case of the general coarsened-data
consistency theorem of [towell2026synthesis]" with the singleton-restoration
mechanism as a domain instance. This is logically consistent with the paper's
own framing and with the synthesis-paper concept DOI (10.5281/zenodo.20533912)
present in refs.bib (verified present, format-correct). The claim is internally
coherent: the spot/singleton structure here is indeed an instance of the
general rank-condition + singleton-restoration pattern the paper describes. No
logical conflict. The cross-ref integrated cleanly.

## Severity calibration

No critical issues. The three proof-priority items (rank condition, cell-total
consistency including the intersection-of-kernels step, marker-gene bias bound)
are all SOUND and numerically verified. The major finding is a previously-
flagged seam that is now correctly closed. Minors are polish. From a pure
logic/proof standpoint this paper is in good shape.
