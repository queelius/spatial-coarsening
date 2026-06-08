# Citation and bibliography audit: spatial-coarsening (2026-06-08)

Scope: citation accuracy, missing references, bibliography integrity, orphan
entries, key/field consistency.

## Verdict: clean bibliography. One orphan entry, two known content gaps.

`refs.bib` holds 30 entries; 27 distinct keys are cited in the body (verified by
extracting all `\cite*`/`\citep`/`\citet` keys and diffing against the bib).
The build emits 0 undefined citations and 0 undefined references. The
framework-series self-cites now carry live Zenodo DOIs.

## Cited-vs-defined reconciliation

- Entries defined but NOT cited (orphans): `tsiatis2006semiparametric` only.
  This is a genuine orphan: `tsiatis` appears nowhere in the body. Either cite it
  (the natural home is background.tex, where the missing-data / semiparametric
  lineage of the coarsening conditions is the obvious place for the Tsiatis 2006
  reference) or remove it. Flagged on 2026-06-04; still uncited. Low severity but
  trivial to fix.
- `chen2015spatially` and `wang2018three`: these LOOK like orphans to a naive
  single-line grep but are NOT. They are cited in a multi-key `\citep` spanning
  introduction.tex lines 5-6 (`\citep{stahl2016visualization, chen2015spatially,
  wang2018three}`). Both appear in main.bbl. No action. (Recording this so a
  future automated pass does not misflag them.)

## Self-cite DOI status (verified against refs.bib)

- `towell2026masked` -> 10.5281/zenodo.18725577 (note: Zenodo concept/version
  DOI; the coarsening-family README convention is to cite CONCEPT DOIs so cites
  resolve to the latest version. Confirm this is the concept DOI, not a
  version-pinned one, before submission.)
- `towell2026synthesis` -> 10.5281/zenodo.20533912
- `towell2026mdrelax` -> 10.5281/zenodo.20414727
- `towell2026scrnacoarsening` -> 10.5281/zenodo.20414734
- `towell2026dpcoarsening` -> 10.5281/zenodo.20422885
- `towell2026weaksupcoarsening` -> 10.5281/zenodo.20422888
- `towell2026phenotypecoarsening` -> 10.5281/zenodo.20422890
All seven now carry `doi` and `url` fields with `note = {Preprint, Zenodo}`; the
prior "DOI pending" placeholders are gone. Good. NOTE: the state.md log records
slightly different DOI digits for three of these (e.g. masked 18725577 in refs.bib
vs 20414723 in an older state entry); refs.bib is the source of truth for the
build and resolves cleanly, but the author should confirm each DOI resolves to
the intended record before submission, since prior sessions are documented to have
created duplicate Zenodo records (per the coarsening-root CLAUDE.md warning).

## Content gaps (missing references a referee will expect)

- CV-1 (seqFISH+ primary reference): seqFISH+ is named six times across five
  sections (as the canonical single-cell-resolution / singleton platform) but its
  primary publication (Eng et al., Nature 2019, "Transcriptome-scale super-
  resolved imaging in tissues by RNA seqFISH+") is uncited. MERFISH has its
  primary cite (`chen2015spatially`) and STARmap has `wang2018three`; seqFISH+ is
  the conspicuous omission in that trio. Add Eng et al. 2019. Flagged 2026-06-04.
- CV-2 (bulk-deconvolution lineage): no entry for CIBERSORTx, MuSiC, BisqueRNA,
  dtangle, or BayesPrism. This is the bibliographic side of novelty NV-2; the
  rank condition applies to these verbatim and `cai2024inference` already cites
  into that world. Adding two or three (MuSiC and BayesPrism are the highest-
  value, plus CIBERSORTx as the most-cited) supports the positioning paragraph
  novelty recommends. Flagged 2026-06-04.
- CV-3 (NMF-identifiability depth): the reference-free positioning cites
  `donoho2003nmf` and `fu2019nmf`, which is adequate, but the provable-NMF /
  anchor-word / topic-model identifiability line (Arora et al. 2012/2013) is the
  modern locus of "separability and anchor conditions" the text invokes by name
  (identifiability.tex line 84). One Arora citation would make the "anchor
  conditions" phrase land on its actual source. Optional but cheap.

## Field-level accuracy spot checks (PASS)

- `stahl2016visualization` (Science 2016, 353:78-82): correct. NOTE a content
  mismatch unrelated to the bib entry itself: validation.tex line 229 cites
  `stahl2016visualization` for the "10x Genomics V1 adult mouse coronal brain
  Visium dataset," but Stahl 2016 is the original Spatial Transcriptomics method
  paper, not the 10x Visium mouse-brain dataset. The dataset should be cited to
  its 10x Genomics data release / the Visium platform, not to Stahl 2016. This is
  a citation-CONTENT error (right key for "ST" generically, wrong key for "this
  specific dataset"). Fix: cite the 10x dataset source for the dataset sentence.
  Severity: minor but it is a factual miscitation a genomics referee will catch.
- `cable2021robust` (RCTD): journal Nature Biotechnology 2022, key says 2021.
  The key-year (2021, likely the bioRxiv/acceptance year) differs from the
  published field-year (2022). Renders fine under plainnat (uses field year);
  cosmetic. Same pattern for `biancalani2021deep` (Tangram, key 2021 / Nature
  Methods 2021 - this one is consistent). Confirm-live not required; cosmetic.
- `zhang2023spatially` (GraphST): the entry key is `zhang2023...` but the first
  author is Long ("Long, Yahui and Ang ..."). Renders correctly (plainnat uses
  the author field, so it prints "Long et al."), so this is a cosmetic key/author
  mismatch only. No action needed unless key-author consistency is desired.
- `ivich2025missing` (Genome Biology 2025, 26:86): correct, and the in-text claim
  (a missing reference cell type leaves a well-fitting aggregate while biasing
  per-type estimates, detectable in the residual) accurately represents that
  paper. Good use of a current reference.
- `cai2024inference` (JASA 2024, 119:2521-2532): correct; accurately invoked as
  signature-matrix identifiability for cell-type proportions.
- Heitjan-Rubin 1991, Donoho-Stodden 2003, Fu et al. 2019, Blanchard-Scott 2014:
  all correct and accurately invoked.

## Summary of actionable citation items

1. (minor) Fix the dataset miscitation in validation.tex line 229 (cite the 10x
   Visium dataset, not Stahl 2016, for "this specific dataset").
2. (minor) Add seqFISH+ primary reference (Eng et al. 2019).
3. (minor) Resolve the `tsiatis2006semiparametric` orphan (cite in background or
   remove).
4. (minor, novelty-linked) Add 2-3 bulk-deconvolution references for NV-2.
5. (optional) Add one Arora et al. anchor-word/topic-model NMF identifiability
   reference to support the "anchor conditions" phrase.
6. (housekeeping) Confirm the seven Zenodo DOIs resolve to the intended records.
