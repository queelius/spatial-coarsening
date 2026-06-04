# Citation Verifier Report (2026-06-04)

## Tooling note

WebSearch / live DOI resolution was NOT available this session. DOIs were
checked for FORMAT and INTERNAL PLAUSIBILITY only (publisher prefix, structure,
year/volume consistency), not pinged for live resolution. Items needing a live
ping before submission are tagged [CONFIRM-LIVE].

## Coverage / integrity (verified by build + key cross-check)

- Citation-key cross-check (every `\cite*{}` key in `sections/` and `main.tex`
  vs every `@entry{key` in `refs.bib`): NO cited-but-undefined keys. Build
  integrity is clean.
- `pdflatex` + `bibtex` rebuild completes with no undefined-citation warnings
  (only benign hyperref "Token not allowed in PDF string" notices from the math
  in the title). `main.bbl` renders 24 bibitems.
- No duplicate keys, no malformed entries, all year fields present.

## Critical findings

None.

## Major findings

None. (The prior round's critical/major citation issues -- sibling-series
"manuscript in preparation," the self-future-citation loop -- are resolved in
the current refs.bib.)

## Minor findings

### CV-1. GraphST entry has an author-key mismatch
**Location**: refs.bib lines 85-94. Key is `zhang2023spatially` but the first
author is Long, Yahui (the paper is "GraphST," Long et al. 2023, Nat Commun,
DOI 10.1038/s41467-023-36796-3). The key misnames the first author as "zhang."
This renders correctly (the bibliography uses the author field, not the key) but
is a latent trap: anyone citing by author will reach for "Long 2023" and not
find the key. Rename the key to `long2023graphst` for hygiene. The body cites it
once (discussion.tex via zhang2023spatially) for "joint inference is a richer
problem," which is an appropriate use. Cosmetic but worth fixing.

### CV-2. RCTD entry key year vs field year
**Location**: refs.bib lines 42-51. Key is `cable2021robust`, year field is
2022, volume 40 issue 4. The RCTD paper was published online 2021, print 2022;
Nature Biotechnology vol 40 is 2022. The field is internally consistent (2022 /
vol 40). The key says 2021. This is the common online-vs-print key drift; it
renders fine. Optional: align the key to 2022, or leave it (the DOI is the
ground truth and is present). DOI prefix 10.1038/s41587-021-00830-w is plausibly
correct [CONFIRM-LIVE].

### CV-3. tsiatis2006semiparametric remains uncited in the body
**Location**: refs.bib lines 255-261; zero `\cite` in any section (verified).
The state file flags Tsiatis as foundational semiparametric-missing-data prior
art. If it grounds the framework it should be cited once in the background
section; if not, remove it from refs.bib to avoid an orphan entry. Carried
unresolved from the prior two rounds. One-line fix either way.

### CV-4. seqFISH+ mentioned six times, Eng et al. 2019 still uncited
**Location**: seqFISH+ appears in introduction.tex line 9, translation.tex line
44 (table), identifiability.tex lines 81 and 167, validation.tex line 167,
discussion.tex line 44. The canonical seqFISH+ reference (Eng et al. 2019,
Nature, "Transcriptome-scale super-resolved imaging in tissues by RNA seqFISH+")
is not in refs.bib at all. Since seqFISH+ is a load-bearing example (it is the
singleton-candidate-set platform alongside MERFISH), it should be cited at first
mention. The MERFISH cite (chen2015spatially) and STARmap cite (wang2018three)
are present and correctly used; only seqFISH+ lacks its primary reference.
Carried from prior two rounds. [CONFIRM-LIVE for exact metadata.]

## Quotation check

- Tangram quotes in methodology.tex (lines 76-79): "a few hundred marker genes,
  stratified across cell types, sufficed to map the mouse brain cortex
  transcriptome-wide" and "with 22 genes (smFISH), we could not successfully
  predict transcriptome-wide spatial gene expression." Wording is consistent
  with the Tangram paper's reported findings and is correctly attributed to
  biancalani2021deep. Recommend a final verbatim check against the source PDF on
  the last pass (cannot ping the source this session). [CONFIRM-LIVE]

## Prior-art completeness (see literature-context.md for detail)

The named-DECONVOLUTION-methods bibliography is complete and correct. The gaps
are in adjacent literatures the paper does not cite at all:
- NMF identifiability / separability (Donoho-Stodden 2003; Arora et al.).
- Mixed-membership / topic-model identifiability.
- Bulk RNA-seq deconvolution (CIBERSORTx, MuSiC, BayesPrism, etc.).
These are flagged as MISSING REFERENCES by the novelty-assessor (NV-1, NV-2)
because they bear directly on the paper's identifiability claim, not merely on
breadth. From a citation-hygiene standpoint they are the substantive additions;
the four minors above are cosmetic.

## DOI format audit

All DOIs conform to expected formats:
- Nature-family 10.1038/s415xx-... : Cell2location, RCTD, Tangram, CARD, DestVI
  -- format-correct.
- Nat Commun 10.1038/s41467-... : Li 2023, GraphST, SpatialDecon, STdeconvolve
  -- format-correct.
- NAR 10.1093/nar/gkab043 (SPOTlight), Commun Biol 10.1038/s42003-...
  (Stereoscope), Genome Biol 10.1186/s13059-... (Jiang) -- format-correct.
- Zenodo 10.5281/zenodo.XXXX : the three minted sibling DOIs (20414723,
  20414728, 20414735) and the synthesis DOI (20533912) -- format-correct.
None pinged for live resolution. [CONFIRM-LIVE]

## Severity calibration

No critical or major citation defects. The four minors (GraphST key, RCTD key
year, Tsiatis orphan, seqFISH+ missing) are one-line fixes each and have
persisted across rounds. The genuinely important citation work is adding the
identifiability-of-mixing prior art (tracked under novelty), which is a
content/positioning task rather than a hygiene task.
