# Format Validator Report (2026-06-04)

## Scope

Build verification, label/reference resolution, figure inclusion, venue
formatting, and convention compliance (no em-dash, no vanity counts).

## Build verification -- PASS

- `make paper` toolchain (pdflatex -> bibtex -> pdflatex x2) is wired correctly
  in the Makefile with proper prerequisites (sections/*.tex, refs.bib).
- A clean `pdflatex -interaction=nonstopmode -halt-on-error main.tex` completes:
  BUILD OK.
- `main.log` shows no undefined-reference, no multiply-defined-label, no
  undefined-citation warnings. The only warnings are three benign hyperref
  "Token not allowed in a PDF string (Unicode)" notices, caused by math/markup
  in the `\title` being pushed into PDF metadata. Cosmetic. If a clean PDF
  bookmark string is wanted, add `\texorpdfstring{}{}` or a `pdftitle` override
  in hyperref setup. Not blocking.
- `bibtex` (`main.blg`) runs clean: no warnings.

## Label / cross-reference resolution -- PASS

- All `\cref`/`\Cref` references resolve (no "??" in the PDF; no undefined-label
  warnings in the log). Theorem, condition, figure, equation, and section labels
  all bind. `cleveref` + `natbib` + `hyperref` load in the correct order
  (natbib before cleveref; hyperref before cleveref), so cref names render
  correctly.
- Theorem-environment numbering is shared correctly (theorem/proposition/lemma/
  corollary/definition/remark on one counter; condition on its own counter with
  a registered crefname). Verified in preamble (main.tex 26-39).

## Figures -- PASS

- All three figures present and non-empty: figures/rank_diagnostic.pdf,
  figures/marker_bias.pdf, figures/visium_spectrum.pdf.
- Each is `\includegraphics`-d and `\label`-ed in validation.tex
  (fig:rank-diag, fig:marker-bias, fig:visium) and `\cref`-referenced in text.
- `\graphicspath{{figures/}}` is set, so the bare filenames resolve.

## Convention compliance -- PASS

- **No em-dash (U+2014)**: a grep for the literal em-dash across sections/*.tex,
  main.tex, and refs.bib returns nothing. Compliant. (The source uses `--` for
  en-dashes in ranges and `,`/`:`/`(...)` for parenthetical breaks, which is
  correct.)
- **No vanity counts**: the prose does not foreground page/reference/figure
  counts as achievement. Numeric counts that appear (200 replicates, K values,
  spot counts, UMI counts) are experimental parameters and dataset descriptors,
  not vanity metrics. Compliant.

## Venue formatting assessment

- Current class: `article`, 11pt, letterpaper, 1in margins. This is a generic
  preprint format, not a venue template.
- **Page count: 18.** The paper's own header comment and the state file target
  "12 pages incl. references" (conference format). The paper is 6 pages over
  that target.
  - For RECOMB (12-page LNCS/LNBI limit): this is a hard problem. The paper
    would need the Springer llncs class AND roughly a third trimmed. The
    validation section is the main bulk; the deferred-benchmark and real-data
    diagnostic subsections are the compressible material.
  - For Genome Biology / Bioinformatics / Nature Methods: no fixed page limit at
    submission, so 18 pages is acceptable, but each requires its own submission
    template/format at acceptance.
  - For AISTATS: 8-page (+appendix) PMLR limit; the body would need to move
    proofs to an appendix. Substantial reformatting.
- Recommendation: the formatting is venue-neutral and clean as a preprint, but
  NO venue template has been applied, and the page count is incompatible with
  the two conference targets (RECOMB, AISTATS) without compression/reformat.
  This is a venue-decision-dependent task, not a defect.

## Reproducibility plumbing -- PASS

- Makefile targets (paper, sim, visium, rctd, joint_mu, cell_total, figures,
  download, validation, clean, wordcount) are coherent and have correct file
  prerequisites.
- Seeds are fixed in scripts. Data download is scripted
  (scripts/download_data.sh). The `.gitignore` and result `.rds` files are
  present. One script (`cell_total_kernel.R`) was executed this session and ran
  to completion, reproducing the paper's quoted numbers.

## Minor findings

### FV-min1. hyperref PDF-string warnings on the title
**Location**: main.log (3 instances). Cosmetic; fixable with pdftitle/
texorpdfstring. Non-blocking.

### FV-min2. No venue template applied
The draft is in generic `article` format. Whichever venue is chosen, the
template swap is pending. Not a defect at draft stage; flagged so it is not
forgotten at submission.

### FV-min3. Page count over the stated conference target
18 vs 12. Blocking for RECOMB/AISTATS, fine for journal targets. See venue
assessment. This intersects the synthesis/standalone decision: if folded into
the synthesis paper, the page-budget question is reframed entirely.

## Severity calibration

No critical or major formatting issues. The build is clean, references resolve,
figures bind, and the no-em-dash / no-vanity-count conventions are satisfied.
The only substantive item is venue-dependent (page count vs conference limits +
template application), which is a submission-logistics decision rather than a
manuscript fault.
