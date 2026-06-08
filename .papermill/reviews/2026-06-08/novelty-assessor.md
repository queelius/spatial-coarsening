# Novelty and contribution assessment: spatial-coarsening (2026-06-08)

Scope: contribution clarity, differentiation from prior art, significance,
honesty of the novelty claim.

## Verdict: HONEST and well-positioned, with two remaining positioning gaps.

The paper's novelty claim is correctly modest and now well-defended. It does NOT
claim a new identifiability criterion; it claims (a) the isomorphism between ST
deconvolution and the masked-data coarsening framework, (b) a unified vocabulary
that reads each ST method as a parametric specialization, (c) the singleton-
restoration mechanism mapped onto single-cell-resolution platforms, and (d) a
marker-gene bias bound. This framing is defensible and the manuscript executes it
honestly. The single largest prior-review risk (NV-1, under-engagement with the
NMF-identifiability / linear-mixing literature) has been ADDRESSED since the
2026-06-04 review.

## NV-1 (prior round's top item): NOW RESOLVED

identifiability.tex lines 71-92 now contains the positioning paragraph the prior
review demanded. It explicitly:
- frames the rank condition as "the coarsening-framework view of a condition
  already known in the deconvolution and matrix-factorization literatures rather
  than a new result";
- ties it to `cai2024inference` (signature-matrix identifiability for cell-type
  proportions from bulk);
- situates the reference-free case against NMF uniqueness via separability/anchor
  conditions (`donoho2003nmf`, `fu2019nmf`);
- reads the problem as mixture-demixing of mutually contaminated distributions
  (`blanchard2014decontamination`), phrasing the solvability condition in
  coarsening vocabulary.
The introduction (lines 22-32) carries the matching honest claim
("Our contribution is not a new identifiability criterion ... but a
re-derivation ... as the coarsening-rank condition"). This converts the prior
top rejection-risk into a demonstrated-awareness strength. Good.

## Major (positioning, 2 remaining)

### NV-2: bulk RNA-seq deconvolution literature still absent
CIBERSORTx, MuSiC, BisqueRNA, dtangle, and BayesPrism solve the identical
signature-times-proportions algebra and predate spatial deconvolution. The rank
condition (full column rank of the signature/composition matrix) applies to them
verbatim; cai2024inference is in fact a bulk-deconvolution inference paper, so
the door is already open. A short paragraph (in discussion or the identifiability
positioning block) acknowledging the bulk-deconvolution lineage would (a) close a
visible genomics-referee gap and (b) SHARPEN the spatial-specific novelty by
contrast: the spot-as-candidate-set structure and the singleton-restoration via
single-cell-resolution platforms are what is genuinely new here, and they are
spatial-specific. Right now a bulk-deconvolution expert sees an uncited adjacent
field. This was flagged on 2026-06-04 and remains open.

### NV-3: "subsumes Cell2location, RCTD, Tangram, CARD as special cases" is
demonstrated in full only for RCTD
The abstract, intro, and conclusion all assert the framework subsumes four named
methods as special cases. The RCTD worked derivation (translation.tex
sec:rctd-worked) is genuinely complete: explicit C1/C2/C3 mapping, the Poisson
likelihood, the bias-bound application, and the correct rank distinction. The
other three are one paragraph (translation.tex lines 124-141) that ASKS the
reader to construct the derivations ("We do not derive each in detail here; the
RCTD derivation above is the template"). Two acceptable fixes:
1. Downgrade the headline claim to match what is shown: "we work RCTD in full and
   indicate how the others specialize," OR
2. Add a brief explicit derivation for one more method. Cell2location is the
   highest-value second case (its hierarchical prior is the regime where
   thm:cell-total-st's unconstrained-optimum hypothesis fails, so deriving it
   would also demonstrate the boundary of the cell-total theorem).
Option 2 is stronger and dovetails with methodology M-1 (a Cell2location
head-to-head). Option 1 is the cheap honest fix if scope must stay fixed. Flagged
2026-06-04, still open.

## Resolved since prior round

- NV-4 (differentiation from the precursor scRNA-seq paper): NOW ADDRESSED.
  introduction.tex lines 56-60 states the boundary explicitly: ST is "a strict
  generalization in that the candidate set has non-trivial structure (multiple
  cell types per spot) rather than being a single bit (zero vs. nonzero count)."
  The same contrast is repeated in translation.tex lines 57-63. Clear.

## Significance

The contribution is real but incremental-by-design: it is the second instance of
a framework-portability program (after scrna-coarsening), and the paper is candid
that "the portability across these applications is what motivates the framework-
level investment" (discussion sec). The genuine spatial-specific deliverables are
the singleton-restoration reading of single-cell-resolution platforms and the
marker-gene bias bound recovering Tangram's empirical rule. These are worth
publishing. The honest framing means a referee cannot fault it for overclaiming;
the only risk is a referee judging the within-ST novelty too thin, which NV-2 and
NV-3 directly mitigate. The connection to ivich2025missing (a 2025 Genome Biology
paper) is a nice piece of timeliness: the cell-total theorem gives the exact
algebraic conditions behind a recently-published empirical diagnostic.

## Venue-fit note

For Genome Biology (primary) the positioning fixes NV-2/NV-3 plus one real method
comparison (M-1) are the gating items. For RECOMB (conference fallback) the
contribution-as-stated is publishable but the 12-page constraint conflicts with
the current 19 pages (see format lens). Folding into the synthesis paper as the
spatial worked example remains a viable third path and would moot NV-2/NV-3
(the synthesis paper carries the cross-domain positioning).
