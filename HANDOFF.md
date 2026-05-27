# Hand-off: spatial-coarsening paper

**Last touched**: 2026-05-13. Initial scaffold v0.1 at `main.pdf`.
Conference-format draft, builds clean, em-dash free.

This is the conference-format sequel to `~/github/papers/scrna-coarsening/`.

---

## 1. What this paper is

**Working title**: *Coarsening at random for spatial transcriptomics:
identifiability conditions for cell-type deconvolution.*

**Central claim**: spatial-transcriptomics (ST) deconvolution is
mathematically isomorphic to the masked-data series-system
identifiability problem. Cell types play the role of components,
spots play the role of candidate sets (probability distributions
over cell types), single-cell-resolution platforms (MERFISH,
seqFISH+) play the role of singleton candidate sets, and marker
genes play the role of identifying functions.

**Why this exists**: ST is in a methodological boom (Li et al. 2023
benchmarked many published deconvolution methods). The masked-data
framework unifies them, gives identifiability conditions, and
predicts when each method is appropriate. The scrna-coarsening paper
proved the framework worked for one application; this paper extends
to a richer one (multiple cell types per spot rather than binary
zero/nonzero per gene).

**Conference target**: 12-page format (ISBI / RECOMB / ISMB / AISTATS).
The current draft is shorter than the target with substantive
content in all sections; expanding with figures and proofs is
natural.

---

## 2. Current state

### Paper scaffold (`papers/spatial-coarsening/`)
- `main.tex`: top-level (designed for compact format)
- `sections/` (all substantive):
  - `introduction.tex` (motivation + framework + contributions list)
  - `background.tex` (brief masked-data primer)
  - `translation.tex` (bridge + translation table)
  - `identifiability.tex` (rank condition + cell-total-consistency theorems)
  - `methodology.tex` (bias bound under marker undercoverage)
  - `validation.tex` (sim + Visium real data, currently DESCRIBED not RUN)
  - `discussion.tex` (method positioning, limitations)
  - `conclusion.tex`
- `refs.bib`: ST deconvolution methods (Cell2location, RCTD,
  Tangram, GraphST, benchmarking), foundational masked-data
  references (Heitjan-Rubin), and Towell 2026 manuscripts in
  preparation
- `Makefile`, `README.md`, `CLAUDE.md`
- **Status**: builds clean, em-dash free.

### Theorems stated
1. **Rank condition** (\cref{thm:rank}): identifiability of
   $\bm{\mu}_j$ iff spot-by-cell-type composition matrix $P$ has
   full column rank.
2. **Cell-total consistency** (\cref{thm:cell-total-st}): naive MLE
   reproduces observed spot-level means exactly, regardless of
   per-cell-type bias.
3. **Bias bound under marker-gene perturbation** (\cref{thm:bias-marker}):
   first-order Taylor bound on deconvolution bias under
   marker-gene undercoverage. Recovers Tangram's "a few hundred
   markers suffice" as corollary.

### Vista catalog entries added this session
The following research directions were persisted to the local Vista
catalog so they show up in future searches:
- **GraphST**: vertical integration of serial slides for 3D
  reconstruction; cross-modality identifiability framework
- **Benchmarking deconvolution paper**: scenario-aware methods;
  identifiability-condition benchmarking (not just performance)
- **SpaCET**: dictionary-based malignant cell ID, ST to scRNA-seq
- **SPACEL**: joint composition + spatial-domain inference;
  adversarial GCN as batch-effect tool
- **Tangram**: marker-panel size theorem; joint segmentation +
  mapping for dense tissues; cross-modality alignment for spatial
  proteomics / chromatin
- **Angelopoulos & Bates conformal prediction**: adaptive conditional
  coverage; **conformal prediction for masked/coarsened data** (a
  novel cross-domain bridge, tagged as publishing opportunity)

---

## 3. What's left

### Tier 1: needed for submission
- [ ] **Sibling Zenodo deposit (user-action)**. Deposit each of the
  five sibling papers (`masked-causes-in-series-systems`,
  `scrna-coarsening`, `spatial-coarsening`, `dp-coarsening`,
  `weaksup-coarsening`, `phenotype-coarsening`) to Zenodo with
  versioned DOIs. Once DOIs are issued, update each sibling's bib
  entry across all five papers (replace `journal = {Manuscript in
  preparation}` with the Zenodo `doi` and `url` fields). This is a
  user-action: requires Zenodo authentication and metadata choice.
- [ ] **Actual simulation run** (currently `validation.tex` describes
  sim results but no code exists). Adapt
  `paper-mining/scrna-bridge-sim/sim.R` for ST DGP (per-spot
  Dirichlet composition + per-cell-type expression + spot-level
  aggregation). Estimated: 1-2 days.
- [ ] **Real-data Visium application** on 10x mouse coronal brain.
  Public dataset; cell-type reference from Allen Brain Atlas. 1 day.
- [ ] **Tighter theorem proofs**. Current proofs are sketches that
  point to `scrna-coarsening` for shared apparatus. The rank theorem
  proof needs to be self-contained in the appendix.
- [ ] **Figures**: at least two essential (rank-condition diagnostic,
  cell-total consistency on real data).

### Tier 2: would strengthen
- [ ] Side-by-side comparison with RCTD, Cell2location, Tangram on
  same Visium data. RCTD is straightforward; Cell2location needs
  Python; Tangram needs PyTorch.
- [ ] Sensitivity analysis on marker-gene panel size (recovers
  Tangram's "few hundred markers" empirically).

### Tier 3: polish
- [ ] Conceptual TikZ figure showing the bridge to masked-data.
- [ ] Compare framework prediction with empirical bench from Li et
  al. 2023 (do their best-performers correspond to the best-
  identifiable assumptions?).

---

## 4. Companion repo

`~/github/papers/scrna-coarsening/` is the precursor paper. **The
framework is identical**; this paper is a strict generalization. Many
theorems cite the scrna-coarsening paper rather than re-deriving:
- Cell-total consistency proof: cite `[Towell 2026, §3]`
- Bias-bound first-order Taylor: cite `[Towell 2026, §7]`
- Background section is intentionally compressed and points to the
  precursor for the full apparatus

This is intentional. Keep the citation pattern when expanding.

---

## 5. Conventions (same as scrna-coarsening)

- **No em-dashes** anywhere (soul plugin hook).
- **No vanity counts** in the writeup (state the work, not the
  number of pages or references; this is also enforced by the soul
  hook).
- LaTeX, not Quarto/RMarkdown.
- Author: Alexander Towell, lex@metafunctor.com, SIUE Department of
  Computer Science.
- Citations: Towell 2026 manuscripts in preparation for
  masked-causes, mdrelax, scrna-coarsening.

---

## 6. Quick-start commands

```bash
# Build the paper
cd ~/github/papers/spatial-coarsening
make paper

# To run a simulation (once implemented)
cd ~/github/paper-mining/scrna-bridge-sim
Rscript run_st_sim.R       # to be created

# To run real-data application (once implemented)
Rscript run_v8_visium.R    # to be created
```

---

## 7. The novel cross-domain direction Vista surfaced

While querying for conformal prediction this session, Vista's
Angelopoulos & Bates 2021 paper combined with the existing
masked-data work suggested a genuinely novel cross-domain direction:

> **Conformal prediction for masked/coarsened data**: extend
> distribution-free coverage guarantees to settings where the
> response is observed only as a candidate set rather than a single
> value.

This bridges conformal prediction (a hot ML methodology) with
masked-data inference (the reliability work). It is now stored in
the local Vista catalog with "publishing-opportunity" tag. Worth
considering as a third framework-extension paper after
spatial-coarsening lands.

---

## 8. Status checklist

- [x] Scaffold: substantive sections in all parts, builds clean
- [x] Theorem statements (rank condition, cell-total consistency,
  marker-bias bound)
- [x] References for primary citations
- [x] Vista catalog updated with new direction entries
- [ ] Theorem proofs (currently sketches)
- [ ] Simulation code
- [ ] Real-data application
- [ ] Figures
- [ ] Comparison with RCTD/Cell2location/Tangram
