# Novelty Assessor Report (2026-06-04)

## Scope

Contribution clarity, differentiation, significance, and (per area-chair
priority) whether the framework's contribution (identifiability conditions, not
another deconvolution method) is clearly distinguished from the existing
methods and fairly positioned relative to them. Prior-art freshness is assessed
jointly with the literature packet (WebSearch was unavailable; see that file).

## Position summary

The paper's contribution is correctly self-described as identifiability THEORY
for ST deconvolution, not a new deconvolution METHOD. This distinction is the
paper's strongest asset and is stated clearly and repeatedly (intro
contributions list, the "method-agnostic" framing in validation.tex 332-346,
the "shift from method-specific to assumption-specific reasoning" in
discussion.tex 60-68). On the narrow question the area chair asked, the answer
is: yes, the paper clearly distinguishes itself from being "another
deconvolution method," and that distinction is maintained consistently.

The harder question is whether the identifiability contribution is novel against
the BROADER identifiability literature, and there the positioning has a real
gap.

## Critical findings

None.

## Major findings

### NV-1. The contribution is well-distinguished from the DECONVOLUTION methods but under-distinguished from the IDENTIFIABILITY-OF-LINEAR-MIXING literature

**Location**: Whole paper; acute at identifiability.tex (rank condition,
cell-total) and the absence of any NMF-identifiability / mixed-membership
citations in refs.bib.

The paper positions the rank condition and the cell-total non-uniqueness result
as ports of the author's masked-data/coarsening framework. Mathematically,
however:

- The rank condition (P full column rank for mu = (P^T P)^{-1} P^T m) is the
  textbook design-matrix identifiability condition for a linear model. As stated
  it is correct and useful, but a theory reviewer will see it as a known
  principle specialized to genomics, not a new theorem.
- The cell-total consistency result -- aggregate fit reproduced while
  per-factor estimates are non-unique, with kernel dimension (S-K)(J-K) -- is,
  at its core, the classical NMF rotational/scaling NON-UNIQUENESS phenomenon.
  The natural prior art is the NMF separability / anchor-word literature (Donoho
  & Stodden 2003; Arora et al. provable-NMF and topic-model identifiability) and
  mixed-membership / admixture identifiability. The paper cites NONE of these.

This is the single largest novelty/positioning risk. A reviewer at AISTATS or a
methods-savvy Genome Biology reviewer will recognize the cell-total result as
NMF non-identifiability in coarsening clothing and ask why the established
identifiability literature is not engaged. The fix is not to weaken the
contribution but to SITUATE it: one paragraph acknowledging that (a) the rank
condition is the genomics instance of the standard linear-mixing identifiability
condition, and (b) the cell-total result is the coarsening-framework reading of
NMF non-uniqueness, with the value-add being the unified coarsening vocabulary
and the bias bound. Positioned that way, the contribution is honest and still
worthwhile (the unification across the author's framework series is the real
novelty). Positioned as now, it overstates the within-deconvolution novelty.

### NV-2. Bulk RNA-seq deconvolution is the obvious adjacent prior art and is absent

**Location**: refs.bib (no bulk-deconvolution entries); discussion.tex
(no engagement).

Bulk RNA-seq deconvolution (CIBERSORT/CIBERSORTx, MuSiC, BisqueRNA, dtangle,
BayesPrism) solves the same X = signature x proportions algebra and predates
spatial. The paper's rank condition applies verbatim to bulk deconvolution.
Omitting all bulk-deconvolution literature is a visible gap for any genomics
venue and weakens the "first identifiability treatment" framing, since
identifiability of the bulk problem may already be partly characterized
[CONFIRM-LIVE]. A short paragraph ("the rank condition specializes the
bulk-deconvolution mixing model; spatial adds the spot-as-candidate-set
structure and the singleton-restoration mechanism") would both close the gap and
strengthen the spatial-specific novelty.

### NV-3. The "subsumes Cell2location, RCTD, Tangram, CARD as special cases" claim is demonstrated only for RCTD

**Location**: Abstract (main.tex 91-94), conclusion.tex 16-18,
translation.tex 124-141.

The RCTD worked example (translation.tex 65-122) is genuinely good: explicit
C1/C2/C3 mapping, likelihood form, bias-bound application, and the now-correct
rank-condition distinction. But Cell2location, Tangram, and CARD are handled in
a single paragraph that asks the reader to construct the analogous derivations.
The abstract and conclusion say "subsumes ... as special cases" (plural, all
four); the paper delivers one worked case and three gestures. This is the same
shape flagged in the prior round (N-M2) and remains. Two acceptable fixes:
(a) soften the abstract/conclusion to "subsumes RCTD as a fully worked example,
and situates Cell2location, Tangram, and CARD within the same ledger"; or
(b) add a sentence-level capsule derivation per method. Option (a) is the
lower-risk submission move and makes the claim match the delivery.

### NV-4. Differentiation from the precursor scRNA-seq paper is asserted but thin

**Location**: introduction.tex lines 49-53.

The paper says ST is "a strict generalization" of the scRNA-seq zero-inflation
case because the candidate set is a composition vector rather than a single bit.
This is the right differentiator, but it is one buried sentence. Since the
author's own scrna-coarsening paper is the nearest prior art (and is cited for
the cell-total and bias-bound derivations), a reviewer will ask what is
genuinely NEW here versus a re-application. The strongest new content specific
to ST is: the spot-as-composition-vector candidate set, the singleton =
single-cell-resolution-platform mapping, and the (S-K)(J-K) kernel-dimension
result. Promoting these into an explicit "what is new relative to
scrna-coarsening" sentence or two would harden the contribution. Relevant to the
fold-vs-standalone decision: if the differentiator stays this thin, the
standalone case weakens and folding into the synthesis paper becomes more
attractive.

## Minor findings

### NV-min1. Tangram-as-singleton-candidate-sets is metaphorical
**Location**: translation.tex 121-123 and 124-129. Tangram learns a soft
alignment via a Frobenius objective; it does not evaluate a coarsened likelihood
with singleton candidate sets. "the framework reads as constructing singleton
candidate sets" should be softened to "approximates singleton candidate sets in
the limit of high-confidence alignment." Carried from prior round.

### NV-min2. Tangram corollary framing
**Location**: methodology.tex 74-101. Recovering Tangram's "a few hundred
markers" as a corollary is a nice result, but the paper correctly notes it does
not derive the absolute number 200, only the scaling. The framing
("is consistent with," "we do not derive this absolute number analytically") is
honest. No change needed; flagged for completeness.

## Significance assessment

The genuine, defensible novelty is the UNIFICATION: reading ST deconvolution
through the same coarsening-at-random ledger as the author's other application
papers, with a clean conditions-on-inputs vocabulary and a transferable bias
bound. That cross-domain portability (made explicit in discussion.tex 70-87 and
the synthesis cross-ref) is real and is the paper's reason to exist. The
within-deconvolution theorems are correct but largely specializations of known
identifiability principles; their value is in the framing, not the mathematics.
This is fine IF positioned honestly (NV-1, NV-2). As a standalone genomics-venue
paper the unification angle alone is a modest contribution; as one scaffold in
the framework series (folded into or cross-referencing the synthesis) it is
well-justified.

## Cross-verification status (prior rounds)

- 2026-05-27 N-M1 (RCTD bias-bound one-step-short): partially addressed; the
  Hessian for the RCTD-specific Poisson case is still not written out. Minor.
- 2026-05-27 N-M2 (Cell2location/Tangram asserted not derived): unchanged
  (NV-3).
- 2026-05-27 N-M3 (abstract calibration): the abstract is well-calibrated on the
  "RCTD worked, others situated" point and on dropping the "exactly" overclaim.
  Good.

## Severity calibration

No critical issues. NV-1 (engage linear-mixing/NMF identifiability) and NV-2
(engage bulk deconvolution) are the substantive positioning gaps and are the
most important novelty items before a standalone submission. NV-3 and NV-4 are
abstract-claim-vs-delivery calibrations. The core distinction the area chair
asked about (identifiability theory, not a method) is clearly and fairly made.
