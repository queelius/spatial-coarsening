# Literature context packet: spatial-coarsening (2026-06-08)

Merged field-survey and targeted-comparison context. Live web search was not
available this pass; positioning is assessed from the manuscript's own reference
set, the prior-review literature notes (2026-05-23, 2026-06-04), DOI resolution,
and background knowledge of the deconvolution / identifiability literatures.
Currency-sensitive items are tagged CONFIRM-LIVE.

## Field map: where this paper sits

The paper bridges two literatures that rarely cite each other:
1. Spatial-transcriptomics cell-type deconvolution (genomics/methods).
2. Coarsening-at-random / masked-data identifiability (reliability + missing-data
   statistics).

### 1. ST deconvolution methods (well covered by the manuscript)

The named roster is comprehensive and current: Cell2location, RCTD, Tangram,
CARD, SPOTlight, Stereoscope, SpatialDecon, DestVI, STdeconvolve, GraphST, plus
the Li et al. 2023 Nature Communications benchmark. This is the right set; no
major ST deconvolution method is missing as of the 2024-2025 literature. The
RCTD worked example treats the most-cited reference-based method in full.
CONFIRM-LIVE: whether any 2025-2026 deconvolution method has become a required
cite; none is obviously missing as of knowledge cutoff.

### 2. Coarsening / masked-data apparatus (correctly attributed)

Heitjan-Rubin 1991 (coarsening conditions), the Towell masked-data series
(towell2026masked foundational, towell2026mdrelax C2-sensitivity,
towell2026scrnacoarsening precursor, towell2026synthesis cross-domain), and the
sibling-series papers are cited via Zenodo DOIs. This is the framework-series
convention and is internally consistent.

## Adjacent literatures the results SPECIALIZE (the positioning gaps)

These are the literatures a methods-savvy referee will expect, because the
paper's results are recognizable specializations of them:

### A. Linear-mixing / signature-matrix identifiability
The rank condition (full column rank of the composition/signature matrix) is the
textbook design-matrix identifiability condition for linear mixtures. The paper
NOW situates this (identifiability.tex lines 71-92) via cai2024inference (JASA
2024) and the NMF/contamination literatures. This is the prior round's NV-1 and
it has been ADDRESSED. Good.

### B. NMF identifiability (separability / anchor words)
The cell-total non-uniqueness result is, at its core, the classical NMF
rotational/scaling non-identifiability, with the explicit kernel dimension
(S-K)(J-K). The manuscript cites donoho2003nmf and fu2019nmf, which covers the
separability framing adequately. The modern provable-NMF / anchor-word / topic-
model identifiability line (Arora et al. 2012/2013) is invoked by name
("anchor conditions", identifiability.tex line 84) but not cited to its source.
A single Arora citation would close this. CONFIRM-LIVE for the exact canonical
Arora reference.

### C. Bulk RNA-seq deconvolution (the visible gap)
CIBERSORTx, MuSiC, BisqueRNA, dtangle, BayesPrism solve the identical
signature-times-proportions algebra and predate spatial deconvolution. The rank
condition applies to them verbatim. NONE is cited. This is the single most
visible bibliographic gap to a genomics referee (novelty NV-2 / citation CV-2).
cai2024inference is itself a bulk-deconvolution inference paper, so the door is
already open; 2-3 method cites (MuSiC, BayesPrism, CIBERSORTx) would close it and
sharpen the spatial-specific novelty by contrast.

### D. Single-cell-resolution imaging platforms (the singleton device)
MERFISH (chen2015spatially) and STARmap (wang2018three) are cited; seqFISH+
(Eng et al. 2019, Nature) is named six times but uncited (CV-1). These platforms
ARE the singleton-candidate-set device, so the seqFISH+ primary reference is
load-bearing for the central mechanism and should be added.

## Timeliness wins

- ivich2025missing (Genome Biology 2025): the manuscript correctly identifies its
  cell-total theorem as the exact algebraic explanation for this recent empirical
  finding (missing reference cell type -> well-fitting aggregate + biased per-type
  estimates, detectable in residual). This is a strong, current connection that
  positions the theory as explanatory of a just-published observation.
- The framework-series cross-citations (synthesis, dp, weaksup, phenotype) place
  the paper in an active multi-domain program.

## Net literature assessment

ST-method coverage: complete and current. Coarsening apparatus: correctly
attributed. The gaps are exclusively in the ADJACENT specialized literatures
(bulk deconvolution, anchor-word NMF, seqFISH+ primary), and they are positioning
gaps the paper can close with a short paragraph plus three or four citations
rather than new technical work. The largest one (NMF/linear-mixing positioning,
prior NV-1) is already fixed; what remains is bulk-deconvolution (NV-2/CV-2) and
the seqFISH+ primary cite (CV-1).
