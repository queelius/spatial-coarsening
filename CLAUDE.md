# CLAUDE.md

This file provides guidance to Claude Code when working in this repository.

## Project Overview

Academic paper repository: **Coarsening at random for spatial
transcriptomics: identifiability conditions for cell-type deconvolution.**

Conference-format target (~12 pages). Sequel to `papers/scrna-coarsening/`,
applying the same masked-data identifiability framework to a different
biological measurement problem.

## Build Commands

```bash
make paper      # builds main.pdf
make clean      # removes artifacts
```

## Architecture

- `main.tex`: pure-LaTeX top-level with preamble + `\input{sections/...}`
- `sections/`: 8 section files (no `\end{document}` in section files)
- `refs.bib`: BibTeX
- `figures/`: PDF/TikZ figures (empty currently)
- `scripts/`: simulation/analysis scripts (empty currently)

## Companion repositories

- `papers/scrna-coarsening/` (precursor; same framework, scRNA-seq application)
- `papers/masked-causes-in-series-systems/` (foundational; cited as Towell 2026)
- `papers/mdrelax/` (companion; cited as Towell 2026)

## Conventions (Alex's preferences)

- **No em-dashes** (soul plugin hook enforces).
- LaTeX, not Quarto/RMarkdown.
- Tight conference-style writing: prefer one-paragraph subsections to
  multi-paragraph essays.
- Cite `towell2026scrnacoarsening` for shared theorem proofs
  rather than re-deriving (this is the SECOND paper in the
  framework series; some material is intentionally referenced not
  re-included).
- Author: Alexander Towell, lex@metafunctor.com, SIUE Department of
  Computer Science.

## Conference format constraints

Target: ~12 pages including references. Strategies:
- Use 11pt with 1in margins (close to single-column standard)
- Push proofs to a longer-version companion / appendix
- Use compact theorem statements; cite scrna-coarsening for the
  full proof apparatus
- Limit figures to 2-3 essentials
- Tables over lengthy text where possible

## Status

Initial scaffold (May 2026). Substantive content in all sections;
proofs, figures, and real-data application pending. Build status
unverified at scaffold time; run `make paper` to confirm.
