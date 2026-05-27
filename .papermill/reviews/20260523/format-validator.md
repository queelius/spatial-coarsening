# Format Validator Report

## Scope

Build verification, label resolution, venue formatting fit, typesetting hygiene.

## Build status

`make paper` succeeds. `main.pdf` is produced with 14 pages at letterpaper 11pt.

- BibTeX: clean (main.blg shows no warnings).
- pdflatex: clean except for two Overfull \\hbox warnings and three hyperref unicode warnings.
- All `\cref` and `\Cref` references resolve.
- All `\cite` references resolve.

## Critical findings

None affecting build.

## Major findings

### FV-M1. Page count overruns the conference target by 2 pages

**Location**: Whole document.

**Problem**: State.md targets ~12 pages including references. Build is 14 pages. For RECOMB (12-page firm limit including references), the paper would be rejected at format-check. For AISTATS (similar limit), same. Genome Biology and Nature Communications have no page limit but reviewer convention is concise; 14 pages is acceptable for a methods paper at those venues, but borderline.

**Suggestion**: This is the same finding as prose-auditor P-C1; the format-validator role is to confirm: (a) the build is honest at 14 pages (not 12 pages stretched), and (b) the target venues' page-count rules. RECOMB 2024 LIPIcs-format limit is 16 pages, but most venues with "12 pages" target mean a tighter LaTeX class than `article` 11pt with 1in margins. If RECOMB is the genuine fallback, switch documentclass to the venue's official template before counting. The current `article` 11pt with 1in margins is fairly verbose; switching to AISTATS or RECOMB official style alone may bring the page count under target. For Genome Biology and Bioinformatics, no template restriction at submission; current format is acceptable.

### FV-M2. Two overfull horizontal boxes in introduction and translation

**Location**: 
- introduction.tex lines 22 to 33 (overfull by 0.15 pt, cosmetic only).
- translation.tex lines 34 to 52 (overfull by 25.2 pt, visible margin overrun).

**Problem**: The 0.15 pt overrun is invisible (pdflatex flags anything > 0). The 25.2 pt overrun in translation.tex is the long-cell row in Table 1 (the translation table). At 25 pt the text protrudes noticeably into the right margin in the PDF.

**Suggestion**: For the table, either (a) reduce the table's left column width and let the right column expand, (b) switch to `\small` and rebalance, or (c) use `\begin{table*}` if a two-column class is adopted. Concretely: the row "Reference atlas covers all cell types present in tissue (no out-of-atlas types)" is the longest. Truncate to "Reference atlas covers all tissue cell types" and move the parenthetical to a footnote.

### FV-M3. Three hyperref "Token not allowed in PDF string" warnings

**Location**: main.log (sections of validation.tex).

**Problem**: hyperref warnings of "Token not allowed in a PDF string (Unicode)" arise when caption text contains math or special characters that hyperref tries to use as bookmark text. Typical cause: a figure or equation caption uses inline math without `\texorpdfstring{}{}` wrapping. These are warnings, not errors, but they generate non-functioning PDF bookmarks.

**Suggestion**: Inspect captions in validation.tex for inline math; wrap with `\texorpdfstring{math version}{plain text version}` where used. For example, "$\sigma_{\min}$" in a caption should be `\texorpdfstring{$\sigma_{\min}$}{sigma min}`. This is a 5-minute fix that cleans the warnings.

## Minor findings

### FV-min1. PDF metadata fields are empty

**Location**: pdfinfo output, "Title:", "Author:", "Subject:", "Keywords:" all blank.

**Problem**: Submission portals at journal venues sometimes auto-populate from PDF metadata. Empty metadata means re-entry. The hyperref package supports filling metadata via `\hypersetup{}`.

**Suggestion**: Add to main.tex preamble after hyperref:
```
\hypersetup{
    pdftitle  = {Coarsening at random for spatial transcriptomics: identifiability conditions for cell-type deconvolution},
    pdfauthor = {Alexander Towell},
}
```

### FV-min2. The title in the LaTeX source uses an explicit linebreak `\\` for visual two-line title

**Location**: main.tex line 50.

**Comment**: `\title{Coarsening at random for spatial transcriptomics:\\ identifiability conditions for cell-type deconvolution}` uses `\\` to force a linebreak. For submission templates this may interact badly; the journal class often handles long-title wrapping. For the article class as currently configured, this is fine; for any submission template switch, remove the `\\` and let the class handle wrapping.

### FV-min3. Figure captions are dense

**Location**: validation.tex figures, especially Figure 1 (rank-diag) and Figure 3 (visium spectrum).

**Comment**: Caption text reads as a mini-paragraph (three-plus sentences each). For a polished paper, captions often distill to two sentences (statement + key takeaway). Not a defect, but a polish opportunity.

### FV-min4. `\bm` package used; LaTeX-veteran-quality flag

**Comment**: `\usepackage{bm}` is used for bold math symbols (e.g., `\bm{\mu}_j`, `\bm{p}_s`). This is standard for stats papers. No issue. Some journals (Nature class) prefer `\mathbf{}` or `\boldsymbol{}`; check venue style before submission.

## Reproducibility check

`make paper` and `make sim` are documented. The state.md lists exact seeds: simulation seed 20260517. R script run.R exists and is self-contained (no external R package dependencies beyond base). NMF implementation is hand-rolled (Lee-Seung updates). Reproducibility for the simulation section is high.

For the Real Visium section: scripts/visium.R is present. Data path is `data/` (not inspected here). State.md confirms 10x V1 adult mouse coronal brain dataset; this is publicly available. The Visium reproduction would require the data download, which is documented (presumably) in the README; not verified.

## Cross-verification with prior pass

The prior 2026-05-22 pass does not flag formatting issues. The current findings (FV-M1 page count, FV-M2 overfull boxes, FV-M3 hyperref warnings) are mostly cosmetic but FV-M1 is venue-relevant. The Visium real-data section is new in this revision and is the largest contributor to the +2 page overrun.

## Severity calibration

No critical findings affecting submission. FV-M1 (page count) is the most consequential for the conference fallbacks (RECOMB, AISTATS) and is largely a venue-template question. FV-M2 (overfull boxes) is one cosmetic flaw. FV-M3 (hyperref warnings) is a five-minute clean-up.
