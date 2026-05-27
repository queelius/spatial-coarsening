# Literature Context

Merged literature scout output. Sources: paper bibliography, sibling-paper bibliographies, public ST deconvolution literature.

## State of the field in ST deconvolution (broad)

Spatial transcriptomics deconvolution is a rapidly maturing methods space, with at least nine major published methods (Cell2location, RCTD, Tangram, CARD, SPOTlight, Stereoscope, SpatialDecon, DestVI, STdeconvolve, GraphST) plus several follow-ups. The Li et al. 2023 Nature Communications comprehensive benchmarking paper is the standard reference for empirical comparison; it finds method performance varies substantially by tissue and dataset, but no method dominates.

The field's open theoretical questions, as identified by Li 2023 and the methods literature:

1. **When can deconvolution be expected to fail?** Empirical observation is that methods disagree on some tissues. No prior framework predicts which tissues are problematic *before* running methods.
2. **What is the role of marker-gene panels?** Methods that require marker selection (Tangram with smFISH input) versus those that use full transcriptome (RCTD, Cell2location) differ; no theory explains when reduction to markers is acceptable.
3. **What does single-cell-resolution data buy?** MERFISH/seqFISH+ are increasingly available; integration with sequencing-based ST is an open methodology question.

The paper under review provides answers to (1) via the rank condition, to (2) via the bias bound, and to (3) via the singleton-augmentation result. This is a real contribution to a field that has been empirical-method-heavy and theory-light.

## Direct comparators (targeted)

The strongest direct comparator is **Li et al. 2023** (li2023comprehensive), the benchmarking paper. It is cited but not engaged with at length. The paper under review claims its framework "explains" what Li 2023 finds; the explicit claim is that methods' relative performance reflects how well their implicit assumptions match the tissue's identifiability structure. This is a strong claim and would be much strengthened by a direct cross-check: for the tissues in Li 2023 where method X dominates, does the rank/bias diagnostic predict X? This is what state.md flags as Tier 3 work.

Other direct comparators:

- **Jiang et al. 2022 Genome Biology** ("Statistics or biology: the zero-inflation controversy"): the precursor sibling paper's anchor reference. Cited correctly in this paper's introduction as the cross-domain link to scrna-coarsening.
- **Cable et al. 2021 (RCTD), Kleshchevnikov et al. 2022 (Cell2location), Biancalani et al. 2021 (Tangram)**: methods cited as special cases. Each treats identifiability informally; none does what this paper does.
- **Heitjan and Rubin 1991 (Annals of Statistics)**: the foundational coarsening framework. Cited; the C1, C2, C3 conditions of this paper port directly.
- **Tsiatis 2006 (Semiparametric Theory and Missing Data)**: the broader missing-data reference. In refs.bib but not cited in the paper text. Worth one citation in the background.

## Related identifiability literature in scRNA-seq and adjacent

- **Kharchenko et al. 2014 (SCDE/PAGODA)**: early zero-inflation methods.
- **Lopez et al. 2018 (scVI)**: variational deconvolution for scRNA-seq; related framework but different problem.
- **Towell 2026 (scrna-coarsening, precursor)**: same framework, scRNA-seq application. Cited.

## Identifiability and inverse problems (theoretical context)

The rank-condition approach to identifiability in mixture models traces to:

- **Allman, Matias, Rhodes 2009**: "Identifiability of parameters in latent structure models with many observed variables", Annals of Statistics. The Kruskal-rank conditions for finite mixtures.
- **Donoho and Stodden 2003**: "When does non-negative matrix factorization give a correct decomposition into parts?", NeurIPS. NMF identifiability conditions.

Neither is cited in the paper. The rank condition in Theorem 1 is closer to a standard linear-inverse-problem identifiability result than to Allman-Matias-Rhodes or Donoho-Stodden, but the paper could strengthen its theoretical context by noting the connection.

**Suggestion**: At the end of the rank-condition proof sketch (or in a "Related identifiability literature" subsection), add one sentence: "This rank condition is the linear-inverse-problem specialization of the more general Kruskal-rank identifiability for latent-class models [Allman, Matias, Rhodes 2009]; the simpler form arises here because the spot-level mean depends linearly on $\bm \mu_j$ given $P$."

## Field positioning of the paper

The paper sits across three communities:

1. **Reliability statistics** (Heitjan-Rubin, Tsiatis, Towell-masked): the source of the framework. Receptive to methodology-bridging papers but limited overlap with ST literature.
2. **Spatial-genomics methods development** (Cell2location, RCTD, Tangram, and others): the destination community. Hungry for theory; theory-paper-skeptical, prefers empirical validation.
3. **Statistical genomics** (Genome Biology, Bioinformatics): the most natural venue. Receptive to methodology with both theoretical results and at least one real-data confirmation.

The paper's pitch (framework, theorems, simulation, real-data Visium) is well-matched to community (3). The deferred head-to-head method comparison is the main material weakness for community (2); for community (1) it would not be a weakness.

## Recommended citation additions

Highest-value:
- **Eng et al. 2019 Nature** (seqFISH+). The introduction mentions seqFISH+ but cites only chen2015spatially (MERFISH) and wang2018three (STARmap). One-line fix.
- **Allman, Matias, Rhodes 2009**. Strengthens theoretical context for Theorem 1.

Lower-value:
- Tasic 2018 (already in refs.bib but uncited). Cite in Visium real-data section as the brain-cell-type standard reference, or drop.
- BulkCARD or CARDfree. Only if discussing CARD's variants in depth, which the paper does not.
