# Format and production validation: spatial-coarsening (2026-06-08)

Scope: build verification, label/cross-reference resolution, venue formatting,
convention compliance.

## Verdict: BUILD PASS. One venue-format mismatch (page budget).

## Build

- `make paper` exits 0.
- `LC_ALL=C grep -ai undefined main.log` (excluding harmless "Font shape ...
  undefined" lines per the brief): 0 undefined references, 0 undefined citations.
- Overfull/underfull boxes: 0.
- All `cleveref` cross-references bind: theorem/condition/figure/equation/section
  refs all resolve (thm:rank, thm:cell-total-st, thm:bias-marker, cond:c1..c3,
  fig:rank-diag, fig:marker-bias, fig:visium, eq:* all defined and referenced).
- Theorem numbering is shared correctly across the common counter (Theorem 1 =
  bg-id in background; thm:rank, thm:cell-total-st, thm:bias-marker numbered in
  sequence with propositions/lemmas off the same counter). No duplicate or
  dangling labels.
- BibTeX: `main.blg` clean; main.bbl emitted; all cited keys present.
- Figures: all three (`rank_diagnostic.pdf`, `marker_bias.pdf`,
  `visium_spectrum.pdf`) present in `figures/`, included via `\includegraphics`,
  and render in `main.pdf`. Visual content matches the in-text numbers and the
  captions.

## Output

- `Output written on main.pdf (19 pages, 390347 bytes)`.

## Venue-format finding (F-1, major for a conference target)

The header comment in main.tex line 3 declares "Conference-format draft (target:
12 pages incl. references)" and state.md lists RECOMB (12-page format) as the
conference fallback. The actual output is 19 pages. That is 7 pages over a
12-page conference budget.

- If the target is RECOMB (or any 12-page venue): the paper needs substantial
  trimming, or proofs/validation detail must move to an appendix/supplement.
  Candidate compressions: the NMF-residual-decomposition paragraph (prose P-min-2),
  the redundant method-roster enumeration that appears in both translation.tex and
  discussion.tex, and pushing the full marker-bias derivation to the companion.
- If the target is Genome Biology / Bioinformatics / Nature Communications
  (journal, no hard 12-page limit): 19 pages is fine and F-1 is moot. The state
  file's primary target IS Genome Biology, so this is conditional.

RECOMMENDATION: the "target: 12 pages" comment in main.tex and the conference
framing are now inconsistent with both the page count and the stated primary
venue (Genome Biology). Either (a) remove/loosen the 12-page comment and commit to
the journal framing, or (b) commit to RECOMB and trim. The current state where the
source declares one target and the artifact fits another is the only real format
defect. This is a decision item, not a build defect.

## Convention compliance (PASS)

- NO em-dash characters (U+2014): verified absent across `main.tex`, all
  `sections/*.tex`, and `refs.bib`.
- NO vanity counts in the body prose: the only "12 pages" / "X pages" strings are
  in the main.tex header comment and the self-cite `note` fields are page-free.
  The abstract and body describe work content, not scale. PASS. (The header
  comment "target: 12 pages" is a build directive, not body prose, but see F-1.)
- Author identity: Alexander Towell, Department of Computer Science, SIUE,
  lex@metafunctor.com, ORCID 0000-0001-6443-9897. Correct and complete in
  main.tex.
- Document class: `article` 11pt letterpaper, 1in margins, natbib + cleveref, as
  declared in state.md. Consistent.

## Reproducibility plumbing (PASS)

- `Makefile` targets present; `scripts/` contains the analysis code
  (`run.R`, `sim.R`, `cell_total_kernel.R`, `rctd_compare.R`, `joint_mu.R`,
  `visium.R`, `figures.R`, `download_data.sh`). Seeds stated in text (20260517
  main run, 20260603 kernel). Data is gitignored per the family convention.
- Two scripts were executed this pass (`cell_total_kernel.R`, `rctd_compare.R`)
  and reproduced their quoted numbers exactly (see logic and methodology lenses).
