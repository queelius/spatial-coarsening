---
schema_version: 1
last_updated: 2026-05-27
stage: revised-post-review-v0.2
paper_type: theory-with-simulation
format: latex
build_command: make paper
main_file: main.tex
output_file: main.pdf
---

# Paper state: spatial-coarsening

## Metadata

- **Working title**: Coarsening at random for spatial transcriptomics: identifiability conditions for cell-type deconvolution
- **Short name**: spatial-coarsening
- **Type**: Methodology / theory + simulation
- **Target length**: ~12 pages including references (conference format), expandable to journal length
- **Format**: LaTeX, `\documentclass[11pt,letterpaper]{article}`, 1in margins, `natbib` + `cleveref`
- **Build**: `make paper` (produces `main.pdf`)
- **Status**: Scaffold v0.1 (May 2026). Builds clean. Substantive content in all sections. Sim with figures in place. Proof tightening, validation expansion, and method-comparison gaps remain.

## Author

- **Name**: Alexander Towell
- **Email**: lex@metafunctor.com
- **Affiliation**: Department of Computer Science, Southern Illinois University Edwardsville
- **ORCID**: 0000-0001-6443-9897

## Thesis

Spatial-transcriptomics (ST) deconvolution is mathematically isomorphic to the masked-cause series-system identifiability problem from reliability statistics. Under this bridge: cell types are components, spots are candidate sets (probability distributions over cell types), single-cell-resolution platforms (MERFISH, seqFISH+) are singleton candidate sets, and marker-gene panels are identifying functions. The C1, C2, C3 ignorable-coarsening conditions of Heitjan and Rubin (1991) port directly, giving an identifiability theorem (rank condition on the spot-by-cell-type composition matrix), a cell-total consistency result, and a closed-form bias bound under marker-gene undercoverage. The framework subsumes Cell2location, RCTD, Tangram, and CARD as special cases.

**Central message**: ST deconvolution methods are not arbitrary heuristics; they are special cases of a single identifiability framework that predicts when each method is appropriate. The rank condition gives practitioners a diagnostic to run *before* choosing a method. The cell-total consistency theorem explains why aggregate predictions look plausible even when per-cell-type estimates are biased, a known pitfall in current benchmarks.

**Novelty**: prior work (Heitjan-Rubin, Tsiatis, masked-cause reliability) supplies the apparatus; the contribution is identifying the isomorphism, porting the conditions, and showing that established ST methods land as special cases. This is the first such mapping for spatial transcriptomics; the precursor scrna-coarsening paper does the same for scRNA-seq zero inflation.

## Contributions

1. **Bridge** from ST deconvolution to masked-data inference (`sections/translation.tex`). Formalizes RCTD, Cell2location, Tangram, CARD as special cases.
2. **Identifiability theorem (rank condition)**: cell-type-specific expression is identifiable from spot-level data iff the spot-by-cell-type composition matrix $P$ has full column rank (`thm:rank` in `sections/identifiability.tex`).
3. **Cell-total consistency theorem**: naive MLE reproduces observed spot-level means exactly, regardless of per-cell-type bias (`thm:cell-total-st`). Analogue of the scRNA-seq result in `towell2026scrnacoarsening`.
4. **Bias bound under marker-gene undercoverage**: closed-form first-order Taylor bound on deconvolution bias as a function of the gap between chosen and "true" identifying marker-gene sets (`thm:bias-marker`). Recovers Tangram's "a few hundred marker genes suffice" empirical observation as a corollary.
5. **Simulation + real-data validation** (Visium mouse coronal brain, Allen Brain Atlas reference): cell-total consistency holds to numerical precision; rank condition correctly predicts identifiability.

## Companion / framework-series papers

This is the second paper in a framework series. The shared mathematical apparatus is intentionally not re-derived; it is cited.

- `towell2026masked` (foundational): masked-causes-in-series-systems, distribution-agnostic likelihood. Repo: github.com/queelius/masked-causes-in-series-systems (has CITATION.cff).
- `towell2026mdrelax` (companion): sensitivity to the non-informative masking assumption. Repo: github.com/queelius/mdrelax (tag v0.8).
- `towell2026scrnacoarsening` (precursor; same framework, scRNA-seq application): proofs of cell-total consistency and bias-bound Taylor expansion are cited rather than re-derived. Local-only, not yet a git repo.
- `towell2026{dp,weaksup,phenotype}coarsening` (sibling-series): not yet started.
- `towell2026spatialcoarsening` (this paper, full version): longer journal-format companion will hold the full proofs.

### Citation strategy: Zenodo preprints

To avoid the "manuscript in preparation" overhang at submission, the plan is to mint Zenodo DOIs from GitHub release tags on each sibling repo before this paper is submitted. `refs.bib` self-cite entries are formatted as `@misc` with `publisher = Zenodo` and a `note = {Preprint, DOI pending}` field; at DOI mint time, replace the `note` with a `doi` field. The cross-repo operationalization (add `.zenodo.json` per repo, push, tag, release, mint) is outside the spatial-coarsening session scope.

Sibling repos still needing Zenodo setup: masked-causes (CITATION.cff exists, no `.zenodo.json` or release), mdrelax (tag exists, no Zenodo plumbing visible), scrna-coarsening (no git repo yet). Template: `~/github/papers/cognitive-mri-ai-conversations/.zenodo.json`.

## Venue

**Stage**: candidates evaluated; primary target Genome Biology, fallback Bioinformatics, conference fallback RECOMB.

### Ranked shortlist

1. **Genome Biology** (primary). Strong fit for methodological papers tied to genomic data; receptive to identifiability theory if practical implications are clear. IF: ~12, typical decision ~3 months. Submit with theory + simulation + the deferred-comparison framing.
2. **Bioinformatics** (Oxford; fallback). Methodology-friendly; the rank-condition diagnostic is presentable as a tool/methodology contribution. IF: ~5, typical decision ~2 months.
3. **Nature Communications** (stretch). Broader-scope; identifiability + benchmark-prediction together would be the angle. Higher novelty bar than Genome Biology.
4. **Nature Methods** (stretch). Methods-only; will demand head-to-head bench against RCTD/Cell2location/Tangram. Currently a known gap; defer until that work lands.
5. **RECOMB** (conference fallback). 12-page format. Good audience overlap; faster turnaround if a venue commitment is needed quickly.
6. **ISMB / ISBI / AISTATS** (alternate conferences). ISBI for biomedical-imaging slant; AISTATS for theoretical-stats slant. Both viable if the venue strategy shifts.

### Submission strategy

- Genome Biology submission requires the missing method comparison gap to be explicitly acknowledged with a justification (companion full-version paper with full comparison). The current scaffold should make this acknowledgement clear in the validation and discussion sections.
- For RECOMB the 12-page constraint suits the existing scope without expansion. For Genome Biology, expand validation with at least one head-to-head against RCTD on the existing simulated Visium-scale data, even if Cell2location/Tangram are deferred.

## Structure

`main.tex` (preamble + theorems environment + `\input` of section files) + 8 sections under `sections/`:

| Section | File | Target pages | Status |
|---|---|---|---|
| Introduction | `introduction.tex` | ~1 | substantive |
| Background (masked-data primer) | `background.tex` | ~1 | substantive |
| Translation table (bridge) | `translation.tex` | ~1 | substantive |
| Identifiability theorems | `identifiability.tex` | ~2 | theorems stated, proofs are sketches |
| Methodology (bias bound) | `methodology.tex` | ~2 | substantive, proofs sketches |
| Validation (sim + Visium) | `validation.tex` | ~2 | described, not executed |
| Discussion | `discussion.tex` | ~1 | substantive |
| Conclusion | `conclusion.tex` | ~0.5 | substantive |

`refs.bib`: 14 entries covering ST primary platforms (Stahl 2016, MERFISH, STARmap), deconvolution methods (Cell2location, RCTD, Tangram, GraphST), benchmarking (Li 2023), foundational masked-data (Heitjan-Rubin 1991), framework citations (Towell 2026 x4).

`figures/`, `scripts/`: empty.

## Experiments

### Tier 1 (needed for submission)

- [x] **Simulation study**. `scripts/sim.R` + `scripts/run.R`. ST DGP (Dirichlet composition, log-normal per-cell-type expression, Poisson spot counts), oracle and NMF estimators, four experiments saved to `results.rds`. Run with `make sim` (or `Rscript scripts/run.R`).
- [x] **Visium-scale synthetic case**. $K=30$, $S=2{,}700$, two scenarios: random Dirichlet (full rank, cell-total residual $\sim 4 \times 10^{-2}$ at $N_s=500$) and structured $G=6$ tissue patches (rank $=6$, restored to $30$ by singleton augmentation).
- [x] **Real-data Visium application** (added 2026-05-23). 10x V1 adult mouse coronal brain dataset (`data/`, $2{,}702$ spots $\times$ $32{,}285$ genes, HVG subset $2{,}000$). Cell-total Frobenius-relative residual $0.077$ at NMF $K=20$; per-entry median absolute residual $5 \times 10^{-5}$ within Poisson noise floor. Restricted-region scenario (spots from 5 of 10 K-means clusters) reproduces rank $5/10$ from spots alone, restored to $10/10$ by singleton augmentation. Reference is in-dataset (10x CellRanger graph clusters + K-means K=10) rather than external Allen Atlas, to keep the pipeline self-contained. `scripts/visium.R` + `make visium`.
- [x] **Figures**. `figures/rank_diagnostic.pdf` (full-rank probability + conditioning vs $\alpha$), `figures/marker_bias.pdf` (TV bias vs $|\mathcal{M}|$), and `figures/visium_spectrum.pdf` (real-data SV spectrum + cell-total residual). All included in `validation.tex` and built into `main.pdf`. Generate with `make figures`.
- [x] **Tighter theorem proofs** (closed 2026-05-27). Theorem 1 (rank) is now self-contained with both directions proved fully and a Remark covering per-spot $N_s$ heterogeneity + dropout extensions. Theorem 3 (cell-total) and Theorem 4 (bias bound) cite `towell2026scrnacoarsening` (now DOI 10.5281/zenodo.20414735) for their full derivations, which is the framework-series convention.

### Tier 2 (would strengthen)

- [x] **RCTD head-to-head** (closed 2026-05-26 with from-scratch Poisson MLE, 2026-05-27 with joint-mu recovery). Two related experiments:
  1. `scripts/rctd_compare.R` shows that per-spot $\bm{p}_s$ recovery is comparable across oracle OLS and RCTD-style Poisson MLE (Theorem 4's territory).
  2. `scripts/joint_mu.R` shows that joint inference of $\mu$ requires rank-K composition; rank-deficient P + NMF cannot recover $\mu$ (Theorem 1's territory).
- [x] **Sensitivity analysis on marker-gene panel size** (closed 2026-05-26). At Visium scale $K=30$, $|\mathcal{M}|=200$ gives median per-spot TV bias $1.9\%$, directly matching Tangram's empirical "few hundred markers" claim.

### Tier 3 (polish)

- [ ] Conceptual TikZ figure: the masked-data bridge.
- [ ] Cross-check framework predictions against Li et al. 2023 benchmark: do best-performers correspond to best-identifiable assumptions?

## Reviews

### 2026-05-22 multi-perspective editorial review

Critical findings addressed:
- C1 (thm:cell-total-st scope): tightened to "unconstrained-MLE" regime with explicit exclusion of Cell2location/CARD; added proof sketch with score equations.
- C2 (thm:bias-marker derivation): added explicit IFT assumptions (i)-(iii), labeled the Hessian/cross-Jacobian, added a proof sketch.
- C3 (method-comparison gap): reframed in validation as "framework predictions vs. method ranking" scope decision; deferral to the longer manuscript is now positioned as deliberate.
- C4 (sibling-series cross-references): added towell2026{dp,weaksup,phenotype}coarsening to refs.bib and cited each in discussion and conclusion.

Important findings addressed:
- I1: softened intro overclaim ("None, however, characterize" replaced with "no prior work characterizes [...] through the lens of masked-data coarsening conditions").
- I2: translation-table C1 row reworded to atlas-coverage assumption.
- I3: methodology section softened "predicts" to "is consistent with"; threshold value framed as empirical operating point, not derived.
- I4: bias-bound proof sketch added (via implicit function theorem).
- I5: conclusion adds the framework-across-domains paragraph.

Polish: SPOTlight, Stereoscope, SpatialDecon, CARD, DestVI, STdeconvolve added to refs.bib and cited.

### 2026-05-23 multi-agent review (logic, methodology, novelty, prose, citations, format, literature)

Saved to `.papermill/reviews/20260523/`. Critical and major findings addressed in the 2026-05-24 revision pass:

- L-C1 (Table 1 C2 row vacuous): fixed by editor between scaffold and revision, now describes spot-assignment symmetry concretely (lines 47-48 of translation.tex).
- L-C2 / M-C1 (NMF-vs-theorem ambiguity): added explicit convergence trace in scripts/run.R; multiplicative-update NMF on noiseless input shows sublinear decay from $4.53$ to $0.015$ Frobenius residual across $100$ to $50{,}000$ iterations. Theorem holds at exact MLE; algorithm is the bottleneck. validation.tex Noiseless-limit paragraph now reports the trace.
- L-C3 (rank theorem under Poisson sampling): theorem 1 statement now explicit about Poisson sampling, known $P$, identifiability-via-mean justification.
- L-min1 (atlas-tissue mismatch): one-sentence addition in RCTD worked example.
- L-M2 (marker-bias $-0.5$ baseline): one-paragraph derivation of the iid baseline added to marker-gene section.
- M-C2 (Poisson noise floor): replaced $1/\sqrt{N_s}$ heuristic with computed Frobenius-relative floor $0.053$ on the actual data.
- M-M2 (hard-cluster category error): hard-cluster pseudobulk is now framed as a constrained estimator, not a test of theorem 3; NMF is the actual theorem test.
- M-M3 (HVG-framework connection): one-sentence framing of HVG selection as a marker-gene choice consistent with theorem 4.
- N-C1 (RCTD worked example): added by editor between scaffold and revision (sections/translation.tex lines 65-127), with C1, C2, C3 mapping explicit and bias-bound application.

Addressed in the 2026-05-24 deferred-items revision:
- P-C1 (length): three duplications removed (discussion repeated translation table; translation's "Existing methods" subsection; intro 3-question list). Net page count held at 16; would have been ~18 without the compression. For Genome Biology no hard limit.
- P-C2 (notation): added a one-paragraph notation reminder in methodology.tex Setup ($\mu_{j,k}$ scalar vs $\bm{\mu}_j$ vector vs $M$ marker-restricted matrix); renamed the J\times K full-transcriptome matrix in identifiability.tex cell-total proof to $\hat U$ to avoid clash with methodology's $M$.
- L-min3: added one-sentence derivation $\|\bm{H}_{pp}^{-1}\| = \sigma_{\min}(M)^{-2}$ from the least-squares form of the bias bound.
- M-min1: ran NMF $K = 20$ across 5 random seeds. Frobenius-relative residual $0.0762 \pm 0.0023$; seed-to-seed variability is small relative to the noise-floor / substructure decomposition.
- M-min2: re-ran marker-bias at Visium scale ($K = 30$, $S = 2{,}700$, $J = 500$, $|\mathcal{M}| \in [30, 500]$). At $|\mathcal{M}| = 200$ median per-spot TV bias is $1.9\%$; log-log slope $-0.60$ at $K = 30$ vs $-0.78$ at $K = 5$, consistent with diminishing return of informed marker selection at larger $K$.
- M-M1 (RCTD head-to-head): implemented RCTD's core algorithm (Poisson MLE for $\bm p_s$ given $\mu$, simplex-constrained, EM-style updates) in `scripts/rctd_compare.R`. Avoided installing the full `spacexr` package (heavy R dependency stack including Rfast, fields, mgcv, CompQuadForm; high failure risk). Comparison on the synthetic Visium-scale data shows oracle and RCTD-style give comparable per-spot TV recovery in all scenarios ($0.026$ vs $0.046$ on random Dirichlet; $0.011$ vs $0.044$ on structured G=6). The framework prediction is upheld: per-spot $\bm p_s$ recovery is governed by $\sigma_{\min}(\mu)$ (\cref{thm:bias-marker}'s territory), not by $\sigma_{\min}(P)$ (\cref{thm:rank}'s territory which governs joint $\mu$ inference).

### Citation strategy updated (2026-05-24)

Refactored 6 self-cites in refs.bib from `@article{... journal = {Manuscript in preparation}}` to `@misc{... publisher = {Zenodo}, note = {Preprint, DOI pending}, url = {github}}`. At Zenodo DOI mint time, swap `note` for `doi` field per entry. Documented the strategy in the "Citation strategy: Zenodo preprints" subsection above.

### Zenodo DOIs minted (2026-05-27)

Three sibling-paper DOIs minted via `/home/spinoza/venv/bin/zenodo-upload`:
- `towell2026masked` -> 10.5281/zenodo.20414723 (24 pages)
- `towell2026mdrelax` -> 10.5281/zenodo.20414728 (37 pages)
- `towell2026scrnacoarsening` -> 10.5281/zenodo.20414735 (40 pages)

All three are v0.1 preprint deposits on Zenodo production. The corresponding `refs.bib` entries now use `doi = {10.5281/zenodo.XXXX}` and `url = {https://doi.org/...}` in place of the `Preprint, DOI pending` notes. The remaining three sibling-series cites (dpcoarsening, weaksupcoarsening, phenotypecoarsening) still say `Preprint, DOI pending` because those papers do not yet exist as PDFs; they will be minted when the source manuscripts are written.

For the spatial-coarsening paper itself, a Zenodo deposit is not yet warranted at the current draft stage. When the journal submission is finalized, minting a v0.1 deposit of this paper alongside the submission would be appropriate.

### Joint-(mu, P) recovery experiment (2026-05-27)

Added `scripts/joint_mu.R` and a paragraph to validation.tex closing the M-M1 gap properly. Yesterday's `rctd_compare.R` supplied $\mu$ as known and so only tested \cref{thm:bias-marker} (per-spot $\bm{p}_s$ recovery); the joint experiment tests \cref{thm:rank} directly by running NMF on synthetic data and measuring how well $\hat\mu$ recovers $\mu_{\text{true}}$.

Result: variance-fraction of $\mu_{\text{true}}$ in column-span of $\hat\mu$ is $0.573$ for structured rank-6 P, $0.936$ after singleton augmentation, $0.992$ for random Dirichlet control. Median per-cell-type cosine similarity: $0.59$, $0.95$, $0.94$ respectively. The framework's prediction is crisply confirmed: rank, not structure, is the operative input condition for joint identifiability.

### Self-contained rank theorem proof (2026-05-27)

Promoted Theorem 1's proof sketch to a full self-contained proof and added a `\begin{remark}` block ("Extensions") covering per-spot $N_s$ heterogeneity, cell-type-independent dropout, and cell-type-dependent dropout (the C2-violation regime treated by `towell2026mdrelax`). Removed the deferral to the journal-format companion. The last open Tier 1 item from this state file is now closed.

Theorem 3 (cell-total) and Theorem 4 (bias bound) still cite the scrna-coarsening companion for their full derivations; this is intentional and consistent with the framework-series convention.

### 2026-06-04 multi-agent review (orchestrator interrupted, synthesis written 2026-06-05)

Saved to `.papermill/reviews/2026-06-04/`. Verdict: minor-revision. No Critical.
Proofs verified sound (rank, cell-total, bias bound); empirical claims correctly
scoped; real-data Visium pass confirmed as diagnostics-only (not per-cell-type
recovery). Major items all novelty-positioning: NV-1 (situate rank condition /
cell-total against NMF-identifiability / linear-mixing literature), NV-2 (bulk
RNA-seq deconvolution absent), NV-3 ("subsumes four methods" shown only for RCTD),
NV-4 (thin differentiation from scRNA-seq precursor). Single most-important item:
the NV-1 positioning paragraph.

### 2026-06-08 multi-agent review (full pass, area-chair direct lenses)

Saved to `.papermill/reviews/2026-06-08/` (review.md + 6 per-specialist files +
literature-context.md). Verdict: minor-revision. No Critical. Build clean (0
undefined, 0 over/underfull, no em-dash, 19 pages). Ran `cell_total_kernel.R` and
`rctd_compare.R`: every quoted number reproduced exactly (kernel dim (S-K)(J-K);
saturated/non-saturated residuals; RCTD head-to-head 0.026/0.046, 0.011/0.044).
All three theorems re-verified sound.

Confirmed RESOLVED since 2026-06-04: NV-1 (identifiability.tex lines 71-92 now
situate the rank condition and cell-total result against cai2024inference,
donoho2003nmf, fu2019nmf, blanchard2014decontamination) and NV-4 (intro lines
56-60 state the binary-vs-spot-composition candidate-set boundary).

Carried-forward Major: NV-2/CV-2 (bulk deconvolution still absent), NV-3/M-1
("four methods" still RCTD-only; add a Cell2location derivation + real head-to-
head), F-1 (12-page-target vs 19-page-artifact vs Genome-Biology-primary
mismatch). Minor: Stahl-2016 miscited for the 10x Visium dataset; seqFISH+
primary (Eng 2019) uncited (6 mentions); tsiatis2006semiparametric orphan;
abstract attributes Tangram rule to rank condition rather than the bias bound;
inconsistent [Sketch] labels (cell-total proof is complete). Single most-important
item: situate the framework against the bulk RNA-seq deconvolution literature
(CIBERSORTx/MuSiC/BayesPrism), the one remaining visible genomics gap now that the
NMF/linear-mixing positioning is in place.

## Conventions

- **No em-dashes** (soul plugin hook enforces).
- **No vanity counts** in writeup (state work, not page/reference counts; also soul-hook enforced).
- LaTeX only, not Quarto/RMarkdown.
- Tight conference style: prefer one-paragraph subsections to multi-paragraph essays.
- Cite `towell2026scrnacoarsening` for shared theorem proofs rather than re-deriving; this is intentional and should be preserved when expanding.

## Related cross-domain direction (parked)

Vista catalog surfaced a novel cross-domain bridge during scaffold session: **conformal prediction for masked/coarsened data** (Angelopoulos & Bates 2021 + Towell masked-data series). Tagged `publishing-opportunity` in local Vista catalog. Considered as a possible third framework-extension paper after spatial-coarsening lands. Not part of this paper's scope.

## Numerical results baked into validation.tex (2026-05-17)

- Rank condition: full-rank probability is a step function in $S/K$ ($0$ for $S<K$, $1$ for $S\geq K$), independent of $\alpha$, across $200$ replicates over $\alpha \in \{0.1, \ldots, 2.0\}$ and $K \in \{5, 10, 20\}$.
- Conditioning: median $\sigma_{\min}(P)$ at $K=S=10$ peaks near $\alpha=0.5$ ($0.022$) and degrades at extremes.
- Cell-total noiseless oracle: max abs residual $7.1 \times 10^{-15}$, median $2.2 \times 10^{-16}$ (machine precision; theorem verified).
- Cell-total noisy oracle: median abs residual $0.075 \to 0.0075$ as $N_s$ goes $100 \to 10{,}000$, consistent with $1/\sqrt{N_s}$ Poisson scaling.
- Marker bias: median TV from $0.21$ at $|\mathcal{M}|=5$ to $0.0099$ at $|\mathcal{M}|=200$; empirical log-log slope $-0.78$ (informed marker selection beats the iid $-0.5$ rate; recovers Tangram's "few hundred markers" observation).
- Visium-scale structured case: spot-only rank $= 6 = G$; singleton augmentation restores to $30 = K$ with $\sigma_{\min} = 1.0$.

## Next action

Stage advanced from `scaffold-v0.1` to `revised-post-review-v0.2`. Open paths:
1. **Real-data Visium pass**: 10x mouse coronal brain via SeuratData, Allen Brain Atlas reference. Needed for any biology-leaning journal.
2. **RCTD head-to-head** on the existing simulated Visium-scale data. R-only, low cost, partially closes C3.
3. **Self-contained rank-theorem appendix**: extract the matrix-rank identifiability proof from the longer companion when that lands; allow this paper to stand independently.
4. **Venue commitment**: lock Genome Biology (primary) or RECOMB (conference fallback) before further drafting.
