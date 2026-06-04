# Novelty Assessor Report (2026-05-27)

## Scope

Assess whether the new RCTD worked-example subsection
(`sections/translation.tex` lines 65 to 135) is convincing as evidence
that the framework subsumes RCTD; secondary check on whether the
contributions list now matches what is delivered.

## Position summary

The central novelty claim continues to be the bridge from ST
deconvolution to masked-data coarsening, with named methods (RCTD,
Cell2location, Tangram, CARD) as special cases. The 2026-05-23 round
flagged that "subsumes as special case" was asserted but not
demonstrated; the response was the RCTD worked-example subsection. This
review asks whether that subsection achieves what the prior round
asked for.

## Critical findings

None.

## Major findings

### N-M1 (new). The RCTD worked example does the central work asked for in 2026-05-23 N-C1 but stops one step short of "RCTD's bias under marker undercoverage is given by Theorem 4 with..."

**Location**: `sections/translation.tex` lines 111 to 116.

**Quoted text**: "The bias bound (\cref{thm:bias-marker}) bites for
RCTD when the reference $\hat\mu_{j,k}$ is restricted to a marker-gene
panel $\mathcal M$: $\hat{\bm p}_s$ inherits the first-order Taylor
bias $J_{p,M}\cdot\mathrm{vec}(\Delta M)$ with the sensitivity matrix
evaluated at the marker-restricted Hessian of
\eqref{eq:rctd-likelihood}."

**Problem**: The 2026-05-23 N-C1 finding suggested "letting the bias
bound bite in a specific way: 'RCTD's bias under marker-gene
undercoverage is given by Theorem 4 with $\bm H_{pp}$ equal to...'".
The current text says the bias bound bites and that the sensitivity
matrix is evaluated at the marker-restricted Hessian, but does not
write down the Hessian for the RCTD-specific Poisson log-likelihood
(which would be $\bm H_{pp} = M^\top \mathrm{diag}(N_s / \lambda_s)
M$, evaluated at the optimal Poisson mean $\lambda_s$). This is the
"one more step" that converts "the framework lets us write this" into
"the framework lets us *predict this specific Poisson-weighted form*
that the unweighted $M^\top M$ approximates in the high-count limit".

The strength of the worked example is the C1-C2-C3 mapping
(translation.tex lines 85 to 104), which is genuinely the work asked
for and is well done. The weakness is the one-paragraph bias bound
application at lines 111 to 116, which gestures rather than derives.
For the conference-format constraint this is defensible (the full
derivation costs half a page); for Genome Biology a reviewer will
likely ask why it was omitted.

**Suggestion**: Either (a) add the four-line derivation of the
RCTD-specific Hessian and write out the form of the sensitivity matrix
for that case, or (b) explicitly defer it to the methodology section,
which is where the general form lives, and add a forward reference.
Option (a) is the strongest pitch; option (b) preserves length.

### N-M2 (new). The "Cell2location, Tangram, CARD" paragraph (translation.tex lines 118 to 134) reads as advertisement rather than demonstration after the RCTD section sets the bar

**Location**: `sections/translation.tex` lines 118 to 134.

**Quoted text**: "Cell2location and Tangram fit the framework with
different parametric and procedural choices: Cell2location replaces
the flat simplex constraint with a hierarchical prior on $\bm p_s$ (a
specific form of identifiability assumption), and Tangram aligns
scRNA-seq cells to spatial positions, which the framework reads as
constructing singleton candidate sets at single-cell resolution. Each
method's identifiability and bias behavior follows from substituting
its specific parametric and procedural choices into the same
C1--C2--C3 ledger. We do not derive each in detail here; the RCTD
derivation above is the template."

**Problem**: The RCTD worked example sets a high bar (explicit C1, C2,
C3 mapping, likelihood form, bias-bound application). The text then
says Cell2location and Tangram "fit the framework with different
parametric and procedural choices" and asks the reader to construct
the analogous derivations themselves. For a reader who is convinced by
the RCTD derivation, this is fine. For a skeptical reviewer (Genome
Biology, Nature Methods), the question becomes: "if you can do RCTD,
why not show me Cell2location?" The "we do not derive each in detail
here" is honest but undercuts the abstract's "subsumes RCTD,
Cell2location, and Tangram as special cases" claim, which the reader
will hold the paper to.

**Suggestion**: Either (a) replace "subsumes RCTD, Cell2location, and
Tangram as special cases" in the abstract with "subsumes RCTD as a
fully worked example, and shows how Cell2location and Tangram fit the
same framework", or (b) add a sentence-or-two-per-method capsule
derivation: "Cell2location's hierarchical prior corresponds to a
C3-respecting partial-pooling assumption on $\bm p_s$; the rank
condition then operates on the augmented (prior + data) information
matrix rather than $P$ alone." This converts the gesture into a
visible derivation step. Option (a) is the lower-risk move for
submission.

### N-M3 (new). The abstract's "exactly" softening is good; the abstract's "RCTD worked derivation provided in the text" is the right level

**Location**: Abstract (main.tex lines 91 to 96).

**Quoted text**: "The framework subsumes RCTD, Cell2location, and
Tangram as special cases, with an RCTD worked derivation provided in
the text, and gives a precise vocabulary for when each method is
appropriate."

**Comment**: This is the right calibration: it names the subsumed
methods, signals that the RCTD case is fully worked, and avoids
overclaiming about Cell2location/Tangram. The prior round's "exactly"
overclaim about Visium is addressed (abstract no longer says
"confirms... exactly"). Good.

## Minor findings

### N-min1 (new). The Tangram-as-singleton-candidate-sets framing is borderline metaphor

**Location**: `sections/translation.tex` lines 121 to 123.

**Quoted text**: "Tangram aligns scRNA-seq cells to spatial positions,
which the framework reads as constructing singleton candidate sets at
single-cell resolution."

**Problem**: Tangram does not literally evaluate a likelihood with
singleton candidate sets; it learns a soft assignment matrix and
constructs spatial gene expression by projecting scRNA-seq cells. The
"singleton candidate sets" framing is metaphorical: the limiting case
of perfectly confident soft assignment is a singleton, but Tangram's
loss function is a Frobenius-style alignment objective, not a coarsened
likelihood. The 2026-05-23 logic-checker L-M3 raised this; the
current text inherits the framing.

**Suggestion**: Soften "the framework reads as constructing singleton
candidate sets at single-cell resolution" to "approximates singleton
candidate sets in the limit of high-confidence alignment". A
five-word change; reads more honestly.

## Cross-verification status

- 2026-05-23 N-C1 (subsumes claim asserted not demonstrated): the RCTD
  worked example does the bulk of the work asked for. The remaining
  seam (the Cell2location/Tangram paragraph) is N-M2 above.
- 2026-05-23 N-M1 (differentiation from scrna-coarsening): the current
  introduction's "ST is a strict generalization" sentence (line 51)
  remains buried; the paragraph asked for has not landed. Not blocking
  for submission.
- 2026-05-23 N-M2 (Tangram corollary framing): unchanged; the
  methodology section's "Recovery of Tangram's empirical observation"
  is the venue-dependent framing the prior round flagged.
- 2026-05-23 N-M3 (sibling-series advertising): partially addressed by
  the live Zenodo DOIs but the four discussion-section sibling
  references remain.

## Severity calibration note

N-M1 and N-M2 are the same shape as the prior round's N-C1: the
framework's central novelty claim is now demonstrated for one method
(RCTD) but the other three are still asserted-not-demonstrated. The
2026-05-23 round asked for "at least one worked example to be
credible"; the current revision delivers that. The remaining ask is
whether to repeat the operation for Cell2location or to soften the
abstract claim. Both paths are submission-acceptable.
