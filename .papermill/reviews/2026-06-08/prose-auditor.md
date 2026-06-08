# Prose and presentation audit: spatial-coarsening (2026-06-08)

Scope: writing quality, narrative arc, notation consistency, readability.

## Verdict: clean and professional. Minor polish only.

The writing is tight conference-style throughout, consistent with the stated
house preference. Notation is carefully managed (the prior round added the
mu-scalar / mu-vector / M-matrix reminder and renamed the full-transcriptome
matrix to U-hat to avoid the clash with the methodology M). The narrative arc is
coherent: bridge -> rank condition -> cell-total -> bias bound -> validation ->
positioning. No em-dashes (U+2014 absent, verified). No vanity counts in the body.

## Notation (PASS)

- methodology.tex Setup explicitly disambiguates `mu_{j,k}` (scalar),
  `mu_j in R^K` (column vector across cell types), and
  `M in R^{|M| x K}` (marker-restricted signature matrix). Good.
- identifiability.tex uses `U-hat = [mu_{j,k}] in R^{J x K}` for the full matrix,
  avoiding collision with methodology's marker-restricted `M`. Consistent.
- `P` (composition), `R` (residual), `Lambda` (the kernel operator) are used
  consistently across the identifiability and validation sections.
- `N_s` (cells/counts per spot), `bar X_{sj} = X_{sj}/N_s`, `sigma_min(.)` are
  uniform throughout.

## Minor prose findings

- P-min-1 (the synthesis cross-reference sentence): identifiability.tex lines
  192-197 end the cell-total subsection with a dense sentence tying the result to
  `towell2026synthesis` ("a special case of the general coarsened-data
  consistency theorem ..., in which the singleton-candidate-set device used here,
  single-cell-resolution probes (MERFISH/seqFISH+), appears as one instance of a
  domain-independent rank condition and singleton-restoration mechanism"). It is
  correct but lands abruptly after the ivich2025 discussion and packs three ideas
  into one clause. Split into two sentences or move to a short framework-context
  remark. Flagged 2026-06-04; still present.
- P-min-2 (the NMF-residual-decomposition paragraph): validation.tex lines
  280-305 is a wall of computation (variance algebra, floor 0.053, excess 0.0031,
  noiseless-control extrapolation). The content is correct and reproducible but it
  is the single paragraph most likely to lose a reader. Consider tightening to the
  conclusion (floor 0.053, observed 0.077, excess attributable to substructure
  beyond K=20) and pushing the step-by-step variance derivation to a footnote or
  the companion. Flagged 2026-06-04; still present.
- P-min-3 (`[Sketch]` label consistency): the cell-total proof is labeled
  `[Sketch]` but is effectively complete (the kernel-dimension argument is fully
  there); the bias-bound proof is labeled `[Sketch]` and genuinely defers. Using
  the same label for a complete and an incomplete proof is mildly misleading to a
  referee. Relabel the cell-total proof as a full `\begin{proof}`. (Shared with
  logic L-min-1.) Flagged 2026-06-04; still present.
- P-min-4 (abstract length and density): the abstract is dense and runs long for
  a conference abstract; the final sentence ("Tangram's empirical observation
  ... is recovered as a corollary of the rank condition") slightly overstates
  (the recovery is via the bias bound / conditioning of M, thm:bias-marker, not
  directly the rank condition thm:rank). Tighten the attribution: it is the
  marker-gene bias bound, not the rank condition, that recovers the "few hundred
  markers" rule. Small accuracy fix in the abstract.

## Narrative / framing observations (handed to novelty)

- The honest-framing sentences ("not a new identifiability criterion", "reframing
  the three theorems as organization rather than discovery") are well written and
  do important load-bearing work for the novelty claim. They read as confident
  rather than apologetic, which is the right tone. No change needed; noted because
  a careless edit could tip them into either overclaiming or self-deprecation.
- The cross-domain closing subsection (discussion "A framework across domains")
  is clear and well-paced; the sibling-series citations are integrated smoothly.

## Title / structure

- Title is accurate and informative. Section structure is standard and matches
  the \input order in main.tex. cleveref cross-references all resolve (confirmed
  by the format lens: 0 undefined).
