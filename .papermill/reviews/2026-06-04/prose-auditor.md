# Prose Auditor Report (2026-06-04)

## Scope

Writing quality, narrative arc, notation consistency. Special attention to
whether the prior fixes (cell-total proof rewrite, RCTD clarification,
noise-floor correction, synthesis cross-ref) read cleanly in context.

## Critical findings

None.

## Major findings

### PR-1. The synthesis cross-reference sentence is dense and lands abruptly

**Location**: `sections/identifiability.tex` lines 164-168.

**Quoted text**: "Cell-total consistency (\cref{thm:cell-total-st}) is a special
case of the general coarsened-data consistency theorem of
\citet{towell2026synthesis}, in which the singleton-candidate-set device used
here, single-cell-resolution probes (MERFISH/seqFISH+), appears as one instance
of a domain-independent rank condition and singleton-restoration mechanism."

**Problem**: The sentence is grammatical but overloaded: it asserts the
specialization relationship, names the device, names the platforms, and names
two mechanisms in one breath, with a comma-spliced appositive ("the
singleton-candidate-set device used here, single-cell-resolution probes
(MERFISH/seqFISH+), appears") that is hard to parse on first read. It reads as a
cross-reference bolted onto the end of the section rather than integrated into
the argument. The content is correct and the cross-ref is appropriate; the
prose is the issue.

**Suggestion**: Split into two sentences: "Cell-total consistency
(\cref{thm:cell-total-st}) is a special case of the general coarsened-data
consistency theorem of \citet{towell2026synthesis}. There, the
single-cell-resolution probes (MERFISH/seqFISH+) that supply singleton
candidate sets here appear as one instance of a domain-independent rank
condition and singleton-restoration mechanism." Reads cleaner; same content.

### PR-2. The "Decomposing the NMF residual" paragraph is a wall of computation

**Location**: `sections/validation.tex` lines 280-305.

**Problem**: This single paragraph carries the Poisson-variance derivation, the
floor number, the excess arithmetic, the noiseless-control comparison, and the
caveat about testability, with no paragraph break. It is the densest passage in
the paper and the one most likely to lose a reader. The content is correct (the
noise-floor fix is verified by methodology) but the presentation buries the
takeaway (residual ~ noise floor + substructure; the theorem's exact-zero is a
stationary-point property not directly testable on a fixed-iteration run).

**Suggestion**: Break into two short paragraphs: (1) the noise-floor derivation
and excess computation; (2) the attribution-and-testability discussion. Lead the
second with its conclusion. No content change.

## Minor findings

### PR-min1. "[Sketch]" labels are inconsistent with content maturity
**Location**: identifiability.tex 129 (cell-total), methodology.tex 61
(bias-bound). The cell-total "[Sketch]" now contains a complete kernel-dimension
argument; the bias-bound "[Sketch]" genuinely defers the heteroskedastic
derivation. Using the same label for a near-complete proof and a genuine sketch
is mildly misleading. Consider relabeling the cell-total one (see logic-checker
LG-min2).

### PR-min2. Notation is consistent and the prior reminder helps
The mu_{j,k} scalar / bm-mu_j vector / M marker-matrix / hat-U full-matrix
distinctions are used consistently across sections, and the one-paragraph
notation reminder in methodology.tex Setup (lines 16-23) does its job. The
renaming of the J x K matrix to hat-U in the cell-total proof (to avoid clash
with methodology's M) is clean. This is a strength; recorded so the synthesis
pass preserves it.

### PR-min3. Abstract sentence length
**Location**: main.tex 88-94. The "A simulation study confirms ... predicts off
the saturated regime (where the observed-mean matrix has rank exceeding the
number of cell types)" sentence runs long with a nested parenthetical. Splitting
after "while a small per-entry residual persists" would improve readability. The
content is accurate (and correctly hedged).

### PR-min4. "bites" used twice as a verb for the bias bound
**Location**: translation.tex 117 ("The bias bound bites for RCTD") and the
informal register elsewhere. Acceptable in a conference paper; a journal copy
editor may flag it. Cosmetic.

### PR-min5. Tangram quote punctuation
**Location**: methodology.tex 76-79. The two quoted Tangram phrases are
correctly attributed and quoted; verify the exact wording against the source on
final pass (citation-verifier should confirm the quotations are verbatim).

## Narrative arc assessment

The arc is sound and well-ordered: motivation (deconvolution + its method zoo)
-> the masked-data bridge -> translation table + RCTD worked example -> three
theorems -> validation (sim then real-data diagnostics) -> honest scoping ->
cross-domain framing. Each theorem is motivated before it is stated, and the
validation maps one-to-one onto the theorems. The honesty paragraphs (hard-
cluster category issue, in-dataset-reference limitation, deferred benchmark,
scope of empirical validation) are a notable strength: the paper consistently
tells the reader what it is and is not claiming. This is well above average for
a draft.

The one structural tension: the paper oscillates between "conference-format,
12-page, terse" (its stated style) and "journal-format companion handles the
rest" (its deferral strategy). At 18 pages it is past the 12-page conference
target. For RECOMB the length would need compression; for Genome Biology the
length is fine but the deferrals become liabilities. The prose itself is not the
cause of the overrun (it is appropriately terse); the validation section's
breadth is. This is a scope/venue point, recorded here because it surfaces as a
length issue.

## Severity calibration

No critical issues. PR-1 and PR-2 are localized readability fixes on the two
densest passages (both happen to be the prior-fix sites, which is why they read
slightly bolted-on). The notation discipline and the honesty framing are
strengths. The writing is in good shape.
