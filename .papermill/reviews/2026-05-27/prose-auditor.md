# Prose Auditor Report (2026-05-27)

## Scope

Writing quality, narrative arc, notation consistency, and the
page-budget gap (17 pages vs ~12 conference target). Findings from
the 2026-05-23 round (P-C1, P-C2, P-M1, P-M2, P-M3, P-M4, P-min1
through P-min5) are not re-litigated where the current text addresses
them.

## Critical findings

### P-C1 (carry-forward, escalated). Page count is now 17, up from 14, with a 5-page gap to the ~12 page conference target

**Location**: Whole document. `pdfinfo main.pdf` reports 17 pages.

**Problem**: The 2026-05-23 round flagged 14 pages as 2 over target;
the current build is 17 pages, 5 over the ~12 page conference target
named in `state.md`. The new RCTD worked-example subsection (about
0.7 page), the joint-$\mu$ recovery paragraph (about 0.5 page), the
RCTD-style comparison subsection (about 0.8 page), the NMF residual
decomposition (about 0.4 page), and the tightened rank-theorem proof
plus Remark (about 0.3 page) together account for the additional 3
pages over the 2026-05-23 build.

For the named primary targets:

- **Nature Methods**: no hard page limit at submission, but the
  expected format is 4 to 6 pages for the main text with extensive
  supplementary. 17 pages reads as a full methods paper, not a
  Letter/Article in the Nature Methods style. Submission would
  require either restructuring into a short main text with extensive
  supplementary, or repositioning as a long-format methods paper.

- **Genome Biology**: no hard page limit. 17 pages is acceptable for
  a methodology paper; their average article runs 15 to 25 pages.
  Acceptable as-is for venue length.

- **RECOMB**: 12-page firm limit including references in the LIPIcs
  template. 17 pages in the current `article` 11pt format would not
  translate directly to LIPIcs (which is denser); estimate the LIPIcs
  version at about 13 to 14 pages. Substantive trim needed for
  RECOMB.

- **AISTATS**: 8-page main + unlimited appendix. The paper would
  need to be restructured for AISTATS: main result theorems and the
  RCTD worked example in 8 pages, validation in appendix.

**Suggestion**: Choose the primary venue and tune the manuscript
length to that. The candidate venues span four very different format
expectations. If Genome Biology is the genuine primary (per state.md
ranking), the current length is fine and the page count is not a
problem. If RECOMB or AISTATS is the genuine primary, a substantive
restructure is needed. The state.md commits to Genome Biology, so this
finding may be marked as "venue choice locked, length acceptable" with
no further action; but the prompt named Nature Methods, Genome
Biology, RECOMB, AISTATS as primary targets, which conflicts with the
state.md commitment. Resolve the venue choice first.

## Major findings

### P-M1 (new). The validation section has grown to 6 subsections plus 6 paragraph-headed paragraphs and the navigation is starting to suffer

**Location**: `sections/validation.tex` whole file.

**Problem**: The validation section has the following structure:
- 5.1 Data-generating process
- 5.2 Rank condition
- 5.3 Cell-total consistency (two paragraph-headed paragraphs:
  Noiseless limit, Noisy regime, Practical implication)
- 5.4 Marker-gene bias
- 5.5 Visium-scale synthetic case (three paragraph-headed paragraphs:
  Random composition, Structured composition, Joint $(\mu, P)$ recovery)
- 5.6 RCTD-style head-to-head on the synthetic Visium data
- 5.7 Real Visium data (six paragraph-headed paragraphs: Spectrum,
  Cell-total consistency, Decomposing the NMF residual, Rank
  restoration, Scope)

The total reading load is high: 4 simulation subsections, 1
synthetic-Visium subsection with 3 sub-paragraphs, 1 RCTD
comparison subsection, 1 real-Visium subsection with 4 paragraphs and
a Scope wrap-up. A reader keeping track of which theorem each
subsection tests will lose track. The 2026-05-23 round flagged this
risk for the Real Visium section specifically; the current revision
added more content rather than compressing.

**Suggestion**: Add a one-paragraph roadmap at the start of Section 5
(Validation) that lists what each subsection validates, e.g., "Section
5.2 verifies \cref{thm:rank}; Section 5.3 verifies
\cref{thm:cell-total-st}; Section 5.4 verifies \cref{thm:bias-marker};
Sections 5.5 and 5.7 apply all three to Visium-scale synthetic and
real data; Section 5.6 demonstrates the framework's method-agnostic
prediction on a RCTD-style estimator." This is a 0.1-page addition
that materially helps navigation.

### P-M2 (new). The discussion's relation-to-existing-methods subsection (lines 4 to 24) repeats material from the new RCTD worked example

**Location**: `sections/discussion.tex` lines 4 to 24, and
`sections/translation.tex` lines 65 to 135.

**Problem**: The discussion's "Relation to existing methods" subsection
walks through the same list of methods (Cell2location, RCTD, Tangram,
CARD, SPOTlight, Stereoscope, SpatialDecon, DestVI, STdeconvolve) that
the translation section already enumerates, with the same
parametric/procedural characterization. After the RCTD worked example
adds an explicit derivation, the discussion's restated paragraph adds
no information. The 2026-05-23 round flagged similar duplication
between translation and discussion; the current revision preserved
both.

**Suggestion**: Replace `\subsection{Relation to existing methods}`
in `sections/discussion.tex` with a one-sentence forward reference:
"As demonstrated in \cref{sec:rctd-worked} for RCTD, each of the
major ST deconvolution methods (Cell2location, Tangram, CARD,
SPOTlight, Stereoscope, SpatialDecon, DestVI, STdeconvolve) is a
parametric or procedural specialization of the same coarsening
framework, and their differing empirical performance
\citep{li2023comprehensive} reflects how well each method's
assumptions match the tissue's identifiability structure." This
saves about 0.5 page and removes the repetition.

### P-M3 (new). The new self-contained proof of `thm:rank` (lines 28 to 51) is well-written but the "Extensions" Remark immediately following is denser than the proof and reads as a separate mini-theorem

**Location**: `sections/identifiability.tex` lines 53 to 69.

**Problem**: The Remark block is structurally three sub-extensions
(per-spot $N_s$ heterogeneity, cell-type-independent dropout, and
cell-type-dependent dropout) compressed into one paragraph. Each is a
non-trivial extension worth its own discussion. The current prose
treats them as parenthetical asides. For a Genome Biology reviewer,
the cell-type-dependent dropout extension (which violates C2 and is
the regime of `towell2026mdrelax`) is the most consequential, and is
the one a practitioner is most likely to face.

**Suggestion**: Either (a) expand the Remark into three short
paragraphs (one per extension), each with its own claim and citation,
or (b) move the per-spot $N_s$ heterogeneity and Bernoulli-dropout
extensions to a footnote or to the appendix, and keep the
cell-type-dependent dropout discussion as the standalone Remark. The
latter is more honest about which extension is the consequential one.

## Minor findings

### P-min1 (new). The abstract's "with an RCTD worked derivation provided in the text" reads slightly awkwardly

**Location**: Abstract (`main.tex` lines 91 to 96).

**Quoted text**: "The framework subsumes RCTD, Cell2location, and
Tangram as special cases, with an RCTD worked derivation provided in
the text, and gives a precise vocabulary for when each method is
appropriate."

**Comment**: The "with an RCTD worked derivation provided in the
text" parenthetical is the right calibration content-wise (it signals
the asymmetry between RCTD and the other two methods honestly) but
the prose flow is interrupted. A tighter form: "The framework
subsumes RCTD (worked here in detail), Cell2location, and Tangram as
special cases, and gives a precise vocabulary for when each method is
appropriate."

### P-min2 (new). "RCTD-style head-to-head" subsection title mixes two concepts

**Location**: `sections/validation.tex` line 172.

**Comment**: "Head-to-head" usually implies two named methods
competing; the subsection actually compares oracle OLS-with-simplex-
projection vs RCTD-style Poisson MLE, both implemented in-house. A
title like "Comparison of oracle and RCTD-style estimators on the
synthetic Visium data" would be more precise, though longer.

### P-min3 (new). The validation section now mentions K-means clusters $K = 7$ from CellRanger graph clustering and $K = 10$ K-means as the cell-type reference; the choice of $K$ for the rank-restoration subsection is $K = 10$ but the NMF residual is reported at $K = 20$, which is unmotivated in the text

**Location**: `sections/validation.tex` lines 222 to 245.

**Problem**: The text first introduces $K = 7$ (graph-based) and $K =
10$ (K-means) as the CellRanger clustering choices, then reports NMF
residuals at $K = 10$ and $K = 20$. The $K = 20$ choice is not
explained: why $K = 20$ when the CellRanger reference has only 10
clusters? A reader expects the NMF $K$ to match the reference $K$.
The reason is presumably that the framework predicts the "true"
number of cell types may exceed the cluster count (especially after
HVG selection enriches for cell-type-bearing variance), but this is
not said.

**Suggestion**: Add one sentence at line 241: "We use NMF $K = 20$
rather than $K = 10$ (the K-means reference) because the singular-
value spectrum (panel A) suggests cell-type-like signal extends past
the first 10 components; the NMF $K = 20$ residual is therefore a
stricter test of cell-total consistency than the cluster-matched
$K = 10$ test would be."

## Cross-verification status

- 2026-05-23 P-C1 (length over target): unchanged in shape, escalated
  in magnitude (now 17 pages, was 14). The substantive question is
  venue choice. If Genome Biology, length is fine; if conference,
  trim needed.
- 2026-05-23 P-C2 (notation $\bm \mu_j$ vs $M$): addressed in the
  methodology Setup paragraph (line 16). Fixed.
- 2026-05-23 P-M1 (abstract "exactly" overclaim): the current
  abstract softens the Visium claim to "consistent with the theorem
  to the Poisson noise floor at the sequencing depth of the
  dataset". Fixed.
- 2026-05-23 P-M2 ("mathematically isomorphic" in intro): the current
  intro line 36 still reads "we observe that ST deconvolution is
  mathematically isomorphic to the masked-data series-system
  identifiability problem". Not fixed. Either change to "is an
  instance of" or "is a special case of" for technical precision.
- 2026-05-23 P-M3 (discussion ordering): unchanged.
- 2026-05-23 P-M4 (CAR title): unchanged; not blocking.
- 2026-05-23 P-min1 (intro three-questions): the state.md says intro
  3-question list was removed; the current introduction line 28 to
  31 has "Practical questions go unanswered: how many marker genes
  are needed, and when can deconvolution fail silently?" which is
  two questions, not three. Partially fixed.
- 2026-05-23 P-min4 (\cref{} vs \cite{} in conclusion): the
  conclusion currently uses `\cite{}` (bare) at lines 25, 30, 31, 32,
  33. Not fixed; minor.

## Severity calibration note

The page-count finding (P-C1) is the most consequential prose-level
issue and is venue-dependent. Once a single venue is locked, this
either resolves automatically (Genome Biology) or requires a
substantive restructure (RECOMB, AISTATS, Nature Methods). The other
findings are precision fixes; the prose quality is high overall.
