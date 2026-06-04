# Methodology Auditor Report (2026-06-04)

## Scope

Experimental design, statistical rigor, reproducibility, and the
honesty/scoping of empirical claims. Area-chair priorities: verify the
noise-floor formula correction, and run the explicit honesty check that all
empirical claims are correctly scoped to simulation with no overclaim of
real-data validation.

I executed the paper's own `scripts/cell_total_kernel.R` and re-derived the
noise-floor and conditioning algebra independently.

## Critical findings

None.

## Verified-sound items

### Noise-floor formula correction -- VERIFIED CLEAN

**Location**: `sections/validation.tex` lines 280-287.

The prior round (2026-05-27, "M-M3") flagged a power-of-N_s units inconsistency
in the Frobenius-relative noise-floor formula. The CURRENT text derives it
explicitly and correctly:

  X_sj ~ Poisson(N_s lambda_sj) => Var(Xbar_sj) = N_s lambda_sj / N_s^2
  = lambda_sj / N_s; plug-in lambda_sj ~ Xbar_sj gives per-entry noise variance
  Xbar_sj / N_s; aggregated, Frobenius-relative floor =
  (sum_sj Xbar_sj/N_s)^{1/2} / ||Xbar||_F = 0.053.

I verified this is dimensionally consistent: Var(Xbar)=lambda/N with plug-in
lambda=Xbar gives per-entry variance Xbar/N, and the numerator
sqrt(sum Var(Xbar_sj)) = sqrt(sum Xbar_sj/N_s) matches the text exactly. The
intermediate N_s lambda_sj/N_s^2 step that was missing before is now present.
The toy limit (all Xbar=1, N=500) gives floor ~ 1/sqrt(N) = 0.0447, consistent
with the ~4.5e-2 Poisson floor the paper quotes elsewhere (line 155). The fix
integrated cleanly; the prior units issue is resolved.

### Cell-total validation reproduces -- VERIFIED by execution

Running `scripts/cell_total_kernel.R` reproduces the paper's quoted numbers:
- Kernel-dimension experiment: all shapes match (S-K)(J-K) exactly.
- Saturated case rank(Xbar)=3<=K: aggregate |P^T R|=1.5e-13, per-entry
  max|R|=0.0000 (validation.tex says <=2e-13 and <1e-12).
- Non-saturated rank(Xbar)=5>K: aggregate |P^T R|=2.0e-9, |R U|=6.8e-15,
  per-entry max|R|=0.097 (validation.tex line 78 says 2e-9, 7e-15, 0.097).
The script-to-prose correspondence is exact. This is strong reproducibility.

### Conditioning / bias-bound algebra -- VERIFIED

The H_pp = M^T M and ||H_pp^{-1}||_2 = sigma_min(M)^{-2} claim (methodology.tex
86) is numerically exact (see logic-checker). The marker-bias experiment design
(median per-spot TV vs |M|, greedy range-based selection, 25 reps) is a sound
way to probe the bias-bound scaling. The log-log slope claims (-0.78 at K=5,
-0.60 at K=30) are internally consistent with the "informed selection beats the
iid -0.5 baseline" narrative, and the iid -0.5 baseline derivation
(validation.tex 116-127) is a correct back-of-envelope (Delta M entrywise
variance sigma^2, l2 norm ~ sigma/sqrt(|M|), first-order Taylor => RMS bias
proportional to |M|^{-1/2}).

## Major findings

### MA-1. Honesty / scoping check: PASSES, with a brief-vs-paper note for the area chair

The area chair's brief describes this paper as "sim-only with synthetic
Visium." The paper as written actually contains a REAL public 10x Visium
application ("Real Visium data: 10x adult mouse coronal brain," validation.tex
225-330), not only synthetic Visium. This is a brief-vs-manuscript discrepancy,
not a manuscript defect. The important question is whether the real-data claims
are correctly scoped, and they ARE:

- The real-data section is explicitly scoped to DIAGNOSTICS (singular-value
  spectrum, NMF residual decomposition, rank-restoration on a subregion), not
  to validation of per-cell-type recovery.
- It flags the hard-cluster category issue upfront ("not a test of
  thm:cell-total-st," line 268).
- It frames the in-dataset reference as a deliberate limitation and names what
  an external atlas would add (validation.tex 241-248; discussion.tex 49-57).
- The "Scope of the empirical validation" paragraph (validation.tex 332-346)
  confines all claims to conditions-on-inputs that any method shares, and
  defers head-to-head benchmarking explicitly.
- The abstract is correctly hedged: "application to a public Visium dataset
  finds the aggregate spot-total identity holds while a small per-entry residual
  persists" -- a diagnostic statement, not a recovery-validation claim.

VERDICT on the honesty check: the empirical claims are correctly scoped. There
is no overclaim of real-data validation of cell-type recovery. The strongest
real-data assertion (intro contribution 5: "NMF at K=20 explains 92% of the
variance") is a descriptive fact about the data matrix, not a recovery claim,
and is fine.

One sentence to tighten (minor): intro contribution 5 reads slightly more
confidently than the body. The body says the K=20 NMF residual is 0.077
dominated by Poisson noise + substructure; the intro's "explains 92% of the
variance" is the complementary framing and is accurate, but a reader skimming
only the intro might read it as a recovery result. Consider "NMF at K=20 leaves
a 7.7% Frobenius residual (dominated by Poisson noise), and a restricted-region
scenario reproduces the singleton-augmentation mechanism" to match the body's
carefulness.

### MA-2. The real-data residual decomposition is honest but partly unfalsifiable

**Location**: validation.tex 280-305 ("Decomposing the NMF residual").

The decomposition is: observed K=20 residual 0.077, noise floor 0.053, excess
sqrt(0.077^2 - 0.053^2) = 0.056 attributed to "unmodeled cell-type substructure
beyond the first 20 NMF components." The arithmetic is correct (0.077^2-0.053^2
= 0.0031, sqrt = 0.056). The honest part: the paper states the theorem's
exact-zero prediction is "not directly testable on a fixed-iteration algorithmic
run on noisy data." The soft part: the 0.056 excess is attributed to
substructure largely by ELIMINATION (the noiseless control shows the algorithm
can in principle reach 1e-4), without a positive measurement isolating
substructure from algorithmic shortfall at the actual 150-iteration budget used
on the real data. The paper acknowledges it does "not attempt to separate" the
two contributions. This is acceptable honesty for a conference paper but a
Genome Biology reviewer will note the attribution is inferential. Suggestion:
either run the real-data NMF to convergence (not 150 iterations) to bound the
algorithmic contribution directly, or soften "the bulk of the real-data 0.056
excess is unmodeled cell-type substructure" to "is consistent with unmodeled
substructure, with the algorithmic contribution not separately measured at the
150-iteration budget."

### MA-3. Deferred head-to-head benchmarking is the central methodological gap for high-tier venues

**Location**: validation.tex 332-346, discussion.tex 49-57.

The paper deliberately defers head-to-head benchmarking of RCTD/Cell2location/
Tangram against one another to a "journal-format companion." The justification
(the framework's claims are about conditions-on-inputs, not method ranking) is
coherent and the RCTD-style head-to-head that IS present (oracle vs from-scratch
Poisson MLE, validation.tex 190-223) partially substantiates the
"any unconstrained-likelihood method gives similar expected recovery" claim.
For RECOMB/AISTATS this scoping is defensible. For Genome Biology/Nature Methods
this deferral is the likely major-revision trigger: those venues expect the
benchmark on shared inputs. This is a venue-selection consequence, not a
correctness defect. (See novelty-assessor and the synthesis recommendation.)

## Minor findings

### MA-min1. joint-mu alignment procedure still under-specified in prose
**Location**: validation.tex 159-170. The "median per-cell-type cosine
similarity (greedy column alignment)" uses greedy cosine matching in
`scripts/joint_mu.R` (confirmed by reading the script: greedy column matching by
max cosine, QR-based column-span variance fraction). The prose still does not
name the procedure, so the 0.94/0.95/0.59 numbers are reproducible only by
reading the script. One sentence ("columns of mu-hat aligned to mu_true by
greedy maximum-cosine assignment; variance-fraction computed from the QR
orthonormal basis of mu-hat's column span") closes the gap. Carried from prior
round (M-M1).

### MA-min2. spacexr generalization still unaddressed
**Location**: validation.tex 198-201. The from-scratch RCTD reimplementation is
justified (avoids the spacexr dependency stack), but whether the published
spacexr would give comparable numbers is asserted-by-method-agnosticism, not
checked. One sentence noting expected equivalence up to the platform-effect term
would tighten it. Carried from prior round.

### MA-min3. Seed/replicate counts are adequate but uneven
Rank diagnostic uses 200 replicates; marker-bias and noisy-residual use 25;
NMF K=20 uses 5 seeds. The 5-seed NMF number (0.0762 +/- 0.0023) is fine for a
stability statement but is the thinnest. Not blocking.

## Reproducibility assessment

Strong. Every numerical claim I spot-checked traces to a script
(`cell_total_kernel.R`, `joint_mu.R`, `rctd_compare.R`, `sim.R`, `visium.R`),
seeds are fixed and stated, the Makefile wires each experiment to its target,
and the one script I executed end-to-end reproduced the paper's quoted numbers
exactly. This is above the norm for a draft at this stage.

## Cross-verification status (prior rounds)

- 2026-05-27 M-M3 (noise-floor units): FIXED and verified (MA above).
- 2026-05-27 M-M1 (joint-mu alignment naming): still open (MA-min1).
- 2026-05-27 M-M2 (Spearman 0.12 undersold): the practical-implication sentence
  the prior round asked for is present (validation.tex 219-223). Addressed.
- 2026-05-23 M-C1/M-C2/M-M2/M-M3/M-M4: addressed in current text per prior
  cross-verification; not re-litigated.

## Severity calibration

No critical issues. The honesty check passes. The two real substantive items
(MA-2 residual attribution, MA-3 deferred benchmark) are venue-dependent: minor
for RECOMB, major for Genome Biology/Nature Methods. Reproducibility is a clear
strength.
