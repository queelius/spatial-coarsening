# Methodology Auditor Report (2026-05-27)

## Scope

Verify the new joint-$\mu$ recovery experiment
(`sections/validation.tex` lines 153 to 170), the RCTD-style
head-to-head (`sections/validation.tex` lines 172 to 205), and the NMF
residual decomposition (`sections/validation.tex` lines 262 to 284).
Findings from the 2026-05-23 round (M-C1, M-C2, M-M1, M-M2, M-M3,
M-M4, M-min1, M-min2, M-min3) are not re-litigated where the current
text addresses them.

## Critical findings

None.

## Major findings

### M-M1 (new). The joint-$\mu$ recovery experiment uses variance-fraction-in-column-span and median per-cell-type cosine similarity, but does not check that the recovered $\hat\mu$ matches the true permutation

**Location**: `sections/validation.tex` lines 159 to 170.

**Quoted text**: "The variance-fraction of $\mu_{\text{true}}$ lying
in the column span of $\hat\mu$ is $0.573$ for the structured rank-$6$
case, $0.936$ after singleton augmentation, and $0.992$ for the
random-Dirichlet control. The corresponding median per-cell-type
cosine similarities (greedy column alignment) are $0.59$, $0.95$, and
$0.94$. About half of the $30$ true cell-type expression vectors are
unrecoverable from spot data alone in the rank-$6$ scenario; singleton
augmentation makes them recoverable."

**Problem**: The metric "variance-fraction of $\mu_{\text{true}}$ in
column span of $\hat\mu$" is correct for testing identifiability up
to subspace, but the median per-cell-type cosine similarity with
"greedy column alignment" smuggles in a permutation step that NMF
does not natively provide. The reader would benefit from one sentence
on the alignment procedure: "we permute the columns of $\hat\mu$ to
maximize the trace of the alignment matrix $|\hat\mu^\top
\mu_{\text{true}}|$" or whatever the script does. Without this, the
"$0.94$ cosine" number is reproducible only by reading
`scripts/joint_mu.R`. For a conference paper this is acceptable; for
Genome Biology a reviewer will ask.

**Suggestion**: One sentence describing the alignment procedure (e.g.,
"columns of $\hat\mu$ are aligned to $\mu_{\text{true}}$ by greedy
Hungarian assignment on cosine similarity") would close the
reproducibility gap.

### M-M2 (new). The RCTD-style comparison reports Spearman rank correlation of per-spot TV at 0.12 and 0.25 but the implication is undersold

**Location**: `sections/validation.tex` lines 197 to 205.

**Quoted text**: "The Spearman rank correlation of per-spot TV between
methods is low ($0.12$ on the random case, $0.25$ on the structured)
despite similar median magnitudes: the methods make different errors
on different spots, consistent with their different noise models, but
both succeed or fail under the same identifiability conditions."

**Problem**: A Spearman correlation of $0.12$ between two methods'
per-spot errors on the same data is striking: it means the methods
disagree on *which spots* are hardest, even though they agree on
*how hard* on average. This is potentially a real-world consequential
finding for the practitioner: choosing RCTD or oracle would give
similar global accuracy but different per-spot reliability.
The paper currently treats this as a side observation in service of
the framework's "conditions, not methods" thesis. A reader at Genome
Biology will want this explored or at least flagged as future work.

**Suggestion**: Add one sentence at the end of the paragraph: "The
practical implication is that two methods with comparable global
accuracy may disagree substantially on which specific spots they
recover well; framework-level conditions do not determine per-spot
reliability, which is a feature of the specific estimator and would
benefit from a separate per-spot diagnostic." This converts a side
observation into a research-direction signal, which is what reviewers
respond to.

### M-M3 (new). The NMF residual decomposition algebra at validation.tex lines 263 to 268 is computed but the noise-floor formula has a units inconsistency

**Location**: `sections/validation.tex` lines 262 to 268.

**Quoted text**: "The expected Poisson noise floor on $\bar X_{sj} =
X_{sj}/N_s$ has per-entry variance $\lambda_{sj}/N_s$, which
aggregated over the matrix gives Frobenius-relative floor
$\bigl(\sum_{s,j} \bar X_{sj}/N_s\bigr)^{1/2} / \|\bar X\|_F = 0.053$"

**Problem**: The aggregated Frobenius-relative floor formula given is
$\bigl(\sum_{s,j} \bar X_{sj}/N_s\bigr)^{1/2} / \|\bar X\|_F$, but
this should be $\bigl(\sum_{s,j} \mathrm{Var}(\bar X_{sj})\bigr)^{1/2}
/ \|\bar X\|_F = \bigl(\sum_{s,j} \lambda_{sj}/N_s^2\bigr)^{1/2} /
\|\bar X\|_F$ if $N_s$ varies, or
$\bigl(\sum_{s,j} \bar X_{sj}\bigr)^{1/2}/(N \|\bar X\|_F)$ if $N_s
\equiv N$. The factor of $N_s$ vs $N_s^2$ depends on whether you
divided through. A reader can recover the intent (the $0.053$ number
is presumably computed correctly in the script) but the as-written
formula in the prose has a missing power-of-$N_s$.

**Suggestion**: Replace with the correct expression: under
$\mathrm{Var}(X_{sj}) = \lambda_{sj}$ and $\bar X_{sj} = X_{sj}/N_s$,
$\mathrm{Var}(\bar X_{sj}) = \lambda_{sj}/N_s^2$. Aggregating gives
Frobenius-relative floor $\bigl(\sum_{s,j} \bar X_{sj}/N_s\bigr)^{1/2}
/ \|\bar X\|_F$ when $\lambda_{sj} \approx N_s \bar X_{sj}$ and the
$1/N_s$ inside the sum absorbs one factor. Adding the substitution
step in one sentence would close the gap; otherwise a careful reader
loses one factor of $N_s$. This is M-C2 from the 2026-05-23 round
revisited in different form.

## Minor findings

### M-min1 (new). The validation.tex Visium "in-dataset reference" caveat is now well-positioned but the C1-trivially-satisfied note from 2026-05-23 M-M4 is folded into a single phrase

**Location**: `sections/validation.tex` lines 222 to 230.

**Quoted text**: "We use the in-dataset reference deliberately: the
framework makes predictions about *conditions on inputs* that hold
regardless of which reference is chosen, and the in-dataset reference
eliminates ID-mapping and batch-effect confounds that an external
scRNA-seq atlas, such as the Allen Brain Atlas mouse cortex
compendium \citep{tasic2018shared}, would introduce."

**Comment**: This is honest framing of a real limitation (the
in-dataset reference trivially satisfies C1). For a Genome Biology
reviewer the question will still be "but the deconvolution use case is
external-atlas-driven; why not show the framework on that use case?"
The 2026-05-23 M-M4 suggested the journal-format companion handles
this. The current text says "is in preparation for the longer
manuscript" in the discussion. This is acceptable for the
conference-format pass; for the journal pass it would need an
external-reference run.

### M-min2 (new). The RCTD-style implementation note at validation.tex line 183 mentions skipping `spacexr` but does not address whether the result generalizes

**Location**: `sections/validation.tex` lines 179 to 184.

**Comment**: The text explains that the spacexr package adds
platform-effect terms and confidence intervals that don't test the
identifiability claims. The reader is left wondering whether running
the published spacexr (instead of the from-scratch reimplementation)
would produce comparable numbers. The framework's prediction is
method-agnostic, so it should, but the empirical check is absent. For
the conference pass this is acceptable; one sentence noting "the
implementation follows the published spacexr algorithm; expected
behavior on the published package is the same up to the
platform-effect bias" would tighten the framing.

## Cross-verification status

- 2026-05-23 M-C1 (NMF noiseless residual disagrees with theorem): the
  current text addresses this with a convergence trace from $4.53$
  at $100$ iter to $0.015$ at $50{,}000$ iter, framing it explicitly
  as a property of the multiplicative-update algorithm. Fixed.
- 2026-05-23 M-C2 (Poisson noise floor units): partially addressed by
  the new computed noise-floor formula at validation.tex 263 to 268,
  but as M-M3 above notes, the formula has a residual units
  inconsistency.
- 2026-05-23 M-M1 (head-to-head with deconvolution methods): the
  RCTD-style head-to-head subsection is the substantive response; the
  framework prediction (per-spot $\bm p_s$ governed by
  $\sigma_{\min}(\mu)$, not $\sigma_{\min}(P)$) is empirically borne
  out. Fixed.
- 2026-05-23 M-M2 (hard-cluster pseudobulk category error): the
  current Visium section explicitly flags hard-cluster pseudobulk as
  "a constrained estimator and not a test of \cref{thm:cell-total-st}"
  (line 250). Fixed.
- 2026-05-23 M-M3 (HVG-framework connection): a one-sentence framing
  has been added (validation.tex lines 216 to 220). Fixed.
- 2026-05-23 M-M4 (in-dataset reference): the discussion now flags
  this as a limitation; the journal-format companion will run the
  external reference. Acceptable for conference pass.
- 2026-05-23 M-min1 (seed variability on Visium): the current text
  reports $0.0762 \pm 0.0023$ across 5 seeds. Fixed.
- 2026-05-23 M-min2 (marker-bias at K=30): rerun at Visium scale, log-
  log slope $-0.60$ at $K=30$ reported. Fixed.

## Severity calibration note

All three major findings are precision fixes on otherwise sound
analyses. The biggest issue (M-M3, the noise-floor units) is a
prose-level error in the formula presentation; the underlying number
is presumably correct in the script. No critical-blocker for
submission.
