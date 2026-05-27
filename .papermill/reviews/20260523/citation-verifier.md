# Citation Verifier Report

## Scope

Citation accuracy, missing references, bibliography integrity.

## Coverage

All 17 unique citation keys used in sections/ resolve to entries in refs.bib. Build log shows no "undefined citation" warnings. Bibliography compiles cleanly via bibtex.

Bib file lists 27 entries; 17 are cited (about two-thirds usage). Uncited entries:

| Key | Cited? | Status |
|-----|--------|--------|
| `angelopoulos2023conformal` | No | Conformal prediction; flagged in state.md as "parked" cross-domain direction. Not part of this paper's scope; should be removed from refs.bib for this paper. |
| `tasic2018shared` | No | Mouse cortex cell types reference. Plausibly intended but never cited. Either cite (e.g., in introduction next to Tangram's mouse-cortex application, or in the Real Visium section as the cell-type-reference standard) or drop. |
| `towell2026milcoarsening` | No | Multiple-instance learning extension. Mentioned in state.md as a planned follow-up but not part of this paper's scope. Drop from refs.bib for this paper. |
| `tsiatis2006semiparametric` | No | Heavyweight reference for the general semiparametric / missing-data framework. The state.md thesis paragraph says "prior work (Heitjan-Rubin, Tsiatis, masked-cause reliability) supplies the apparatus", which means Tsiatis is intended as background; it should be cited in the background section. The currently-cited heitjan1991ignorability covers the coarsening direction; tsiatis2006semiparametric would cover the missing-data direction. |

## Critical findings

None. Citations resolve and the bibliography compiles.

## Major findings

### CV-M1. Three sibling-series papers cited as "Manuscript in preparation" with no arXiv or repository pointer

**Location**: refs.bib entries towell2026dpcoarsening, towell2026weaksupcoarsening, towell2026phenotypecoarsening, towell2026scrnacoarsening, towell2026spatialcoarsening, towell2026mdrelax, towell2026masked, towell2026milcoarsening.

**Problem**: Eight in-house references all listed as "Manuscript in preparation". For peer review, this is a substantive issue: a reviewer cannot consult the cited material to verify a claim. For example, the cell-total consistency proof in Theorem 3 cites towell2026scrnacoarsening for the score-equation argument; the marker-bias proof cites towell2026spatialcoarsening (the same paper's "full version") for the heteroskedastic Poisson derivation.

The accepted handling is to (a) post the cited drafts to arXiv with stable DOIs and update the bib entries, or (b) include the needed proofs as appendices in this paper. For Genome Biology and Nature Communications, reviewers will refuse to accept "trust me, the full proof is in another paper that doesn't exist yet". For RECOMB and conference venues this is sometimes tolerated.

**Suggestion**: At minimum, post the masked-causes-in-series-systems paper (the foundational one cited for Theorem 8 of the framework) and the scrna-coarsening paper (which carries the shared apparatus) to arXiv before submission. Update refs.bib with arXiv IDs. The MIL extension can stay as "in preparation" or be dropped from this paper's references entirely.

### CV-M2. Bib entry for towell2026spatialcoarsening reads as a self-reference loop

**Location**: refs.bib lines 137 to 142.

**Quoted text**:
```
@article{towell2026spatialcoarsening,
  title = {Coarsening at random for spatial transcriptomics: identifiability conditions for cell-type deconvolution (this paper, full version)},
  ...
  journal = {This paper, manuscript in preparation},
```

**Problem**: The current paper IS "Coarsening at random for spatial transcriptomics: identifiability conditions for cell-type deconvolution". The cited "full version" is a future longer manuscript by the same author. Self-citation to a future version of the same work is unusual; the typical handling is either (a) the conference version is its own paper and the journal version is a separate later paper, or (b) the appendix contains the full proofs.

For this paper's submission, the cleanest options are:
- Rename the cited "full version" entry to something like `towell2026spatialcoarsening-full` with title "Identifiability for spatial transcriptomics deconvolution: full derivations" to disambiguate.
- Or, defer all "full version" references to an appendix in this paper rather than to a future manuscript.
- Or, drop the citations entirely and provide proof sketches in this paper that are self-contained enough for the conference venue.

**Suggestion**: For RECOMB submission, the citation-to-self-future-version is sometimes tolerated as long as the conference version stands alone. For Genome Biology, this practice would generate referee skepticism. Best practice is to make the conference version stand fully alone (option three above) and only reference the future longer version after it exists.

### CV-M3. Citation count of secondary deconvolution methods is comprehensive but two prominent omissions

**Location**: Introduction and Discussion methods list.

**Comment**: The paper cites Cell2location, RCTD, Tangram, CARD, SPOTlight, Stereoscope, SpatialDecon, DestVI, STdeconvolve, GraphST. Missing:

- **CellTypist** (Conde et al., 2022, Science): widely used single-cell reference annotation tool, though not strictly an ST deconvolution method. Borderline; safe to omit.
- **NMFreg / SpotClean / Seurat anchoring** for completeness in the methods list. SPOTlight is conceptually similar to NMFreg.
- **CARD's BulkCARD extension** (also Ma & Zhou) for spot vs. bulk consistency. Skip if length-constrained.

Not critical. Worth noting only if length permits.

## Minor findings

### CV-min1. SpatialDecon citation has author "Beechem" misspelled in some references in the wild; verified in refs.bib as correct

Verified: refs.bib line 207 lists "Beechem, Joseph M.", which matches the Nature Communications 2022 paper. Good.

### CV-min2. The `chen2015spatially` reference is MERFISH (Chen, Boettiger, Moffitt, Wang, Zhuang, Science 2015)

The intro line 9 cites this as part of "imaging-based platforms (MERFISH, seqFISH+)". MERFISH is correctly attributed. seqFISH+ (Eng et al., 2019, Nature) is not cited; the intro text mentions seqFISH+ but cites only chen2015spatially and wang2018three (the latter is STARmap, not seqFISH+). Either cite Eng 2019 for seqFISH+ specifically, or rephrase the intro to attribute only the methods actually cited.

**Suggestion**: Add `@article{eng2019seqfish,...}` to refs.bib (Eng, Lawson, Zhu, Beliveau et al., Nature 568, 235 to 239, 2019) and cite it next to seqFISH+ in the introduction.

### CV-min3. heitjan1991ignorability is cited once (in background); the framework C1, C2, C3 conditions originate there

The single citation is reasonable. State.md mentions Heitjan-Rubin's conditions are ported directly. For an audience unfamiliar with the framework, the introduction could benefit from one explicit pointer: "The C1, C2, C3 conditions [\citep{heitjan1991ignorability}] govern when masking can be ignored in the likelihood."

## Bibliography integrity check

- BibTeX builds cleanly (main.blg shows no warnings).
- All DOIs that are listed conform to the expected format.
- Year fields all present.
- Author lists for the multi-author Nature/Science papers truncate with "and others", which is standard.
- No duplicate keys.
- No malformed entries.

## Cross-verification with prior pass

The 2026-05-22 prior pass added SPOTlight, Stereoscope, SpatialDecon, CARD, DestVI, STdeconvolve to refs.bib and cited each in discussion. Verified: all six are present and cited (discussion lines 17 to 27). C4 (sibling-series cross-references) added towell2026{dp,weaksup,phenotype}coarsening; verified present in refs.bib and cited in discussion and conclusion.

The current findings (CV-M1 sibling-papers-not-posted, CV-M2 self-future-citation, CV-min2 seqFISH+ attribution) are fresh issues not addressed by the prior pass.

## Severity calibration

No critical citation issues. CV-M1 and CV-M2 are major for any journal venue (and for any non-bypass conference); both have clean fixes. CV-min2 (seqFISH+) is a one-line bib add.
