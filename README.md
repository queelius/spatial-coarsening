# spatial-coarsening

Paper: **Coarsening at random for spatial transcriptomics: identifiability
conditions for cell-type deconvolution.**

Author: Alexander Towell (lex@metafunctor.com), Department of Computer
Science, Southern Illinois University Edwardsville.

## Status

**Reviewed 2026-06-08 (papermill multi-agent): minor-revision.** No critical issues; all numbers reproduce. Top remaining item: add a paragraph and a few citations situating the rank condition against the bulk RNA-seq deconvolution literature (CIBERSORTx, MuSiC, BayesPrism), and either soften or fully demonstrate the "subsumes Cell2location, RCTD, Tangram, CARD, ..." claim below (currently shown in full only for RCTD).

## Thesis

Spatial-transcriptomics (ST) deconvolution is mathematically isomorphic to
the masked-data series-system identifiability problem from reliability
statistics. Under this bridge:

| Reliability                 | Spatial transcriptomics                     |
|-----------------------------|---------------------------------------------|
| component                   | cell type                                   |
| candidate set               | spot composition vector                     |
| singleton candidate set     | single-cell-resolution spot (MERFISH, etc.) |
| identifying function        | marker-gene panel                           |

The C1, C2, C3 ignorable-coarsening conditions of Heitjan and Rubin (1991)
port directly, giving:

1. A rank condition on the spot-by-cell-type composition matrix that
   determines when deconvolution is identifiable;
2. A cell-total consistency theorem explaining why naive deconvolution
   methods produce plausible aggregate predictions even when per-cell-type
   estimates disagree;
3. A first-order bias bound under marker-gene undercoverage that recovers
   Tangram's empirical "a few hundred markers" rule as a corollary.

The framework subsumes Cell2location, RCTD, Tangram, CARD, SPOTlight,
Stereoscope, DestVI, SpatialDecon, and STdeconvolve as special cases.

## Build

```bash
make paper       # produces main.pdf
make download    # fetches the 10x Visium dataset (~100 MB; idempotent)
make sim         # runs simulation, writes results.rds
make visium      # runs real-Visium analysis, writes results_visium.rds
make figures     # regenerates figures/*.pdf from results
make validation  # sim + visium + figures (all of the above)
make clean       # removes build artifacts
```

The simulation alone takes ~30 seconds; the real-Visium analysis takes ~2-3
minutes (NMF at K=10 and K=20 on 2702 x 2000 high-variance-gene matrix).

Requirements: R 4.0+ with the `Matrix` package (base R for everything else),
LaTeX with `natbib`, `cleveref`, `bm`. The download script uses `curl`.

## Repository layout

| Path                          | Contents                                       |
|-------------------------------|------------------------------------------------|
| `main.tex`                    | Top-level preamble + `\input{sections/...}`    |
| `sections/`                   | Eight section files (intro through conclusion) |
| `refs.bib`                    | Bibliography                                   |
| `figures/`                    | Generated PDF figures                          |
| `scripts/sim.R`               | ST data-generating process + estimators        |
| `scripts/run.R`               | Four simulation experiments                    |
| `scripts/visium.R`            | Real-data Visium analysis                      |
| `scripts/figures.R`           | Plot generation from results.rds files         |
| `scripts/download_data.sh`    | Fetch 10x Visium dataset                       |
| `data/`                       | Downloaded 10x files (gitignored)              |
| `.papermill/state.md`         | Paper lifecycle metadata                       |

## Data

The real-data validation uses the public 10x Genomics V1 Adult Mouse
Brain (Coronal) Visium dataset. Run `make download` to fetch:

- Filtered feature-barcode matrix (counts: 2,702 spots, 32,285 genes)
- Spatial coordinates
- CellRanger analysis output (graph-based and K-means clusters, PCA, UMAP)

All from `cf.10xgenomics.com/samples/spatial-exp/1.1.0/V1_Adult_Mouse_Brain`.
Approximately 100 MB total. The download script is idempotent.

## Companion papers

This is the second paper in a framework series. Shared mathematical
apparatus is cited rather than re-derived.

- Towell (2026), Masked causes in series systems: distribution-agnostic
  likelihood. *Foundational*.
- Towell (2026), Sensitivity of series system reliability estimation to
  the non-informative masking assumption. *Companion*.
- Towell (2026), Coarsening-at-random conditions for scRNA-seq zero
  inflation: a reliability-theoretic perspective. *Direct precursor*; the
  proof apparatus for cell-total consistency and the marker-bias Taylor
  expansion is shared.

## Conventions

- No em-dashes (enforced by the soul plugin hook).
- LaTeX only, not Quarto/RMarkdown.
- Tight conference style: one-paragraph subsections preferred.
- Proofs deferred to the longer-version companion are cited explicitly
  rather than re-derived.

## License

MIT. See `LICENSE`.
