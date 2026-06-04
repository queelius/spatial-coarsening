# Citation Verifier Report (2026-05-27)

## Scope

Verify citation accuracy, missing references, bibliography integrity.
Focus on changes since 2026-05-23: the Zenodo DOI mints (per state.md)
and new citations introduced by the RCTD worked example and the joint-
$\mu$ experiment.

## Coverage

All citations used in `sections/` resolve to entries in `refs.bib`.
Build log (`main.log`) shows no undefined citation warnings.
Bibliography compiles cleanly via bibtex.

## Critical findings

None.

## Major findings

### CV-M1 (new). State.md reports Zenodo DOIs minted for three sibling papers; refs.bib confirms the DOIs are in place

**Location**: `refs.bib` lines 116 to 143.

**Quoted entries**:
```
@misc{towell2026masked, ..., doi = {10.5281/zenodo.20414723}, ...}
@misc{towell2026mdrelax, ..., doi = {10.5281/zenodo.20414728}, ...}
@misc{towell2026scrnacoarsening, ..., doi = {10.5281/zenodo.20414735}, ...}
```

**Comment**: The 2026-05-23 CV-M1 critical finding (sibling-series
papers cited as "Manuscript in preparation" with no pointer) is
resolved for the three primary sibling references. The remaining three
sibling entries (`towell2026dpcoarsening`, `towell2026weaksupcoarsening`,
`towell2026phenotypecoarsening`) still carry `note = {Preprint, DOI
pending}` as state.md acknowledges; this is acceptable because they
are described in the paper as future companion work, not as load-
bearing citations for current claims.

### CV-M2 (new). The 2026-05-23 CV-M2 self-citation loop (towell2026spatialcoarsening cites this paper's "full version") is fully removed; the current bibliography no longer has an entry for the full-version companion

**Location**: `refs.bib` (whole file).

**Comment**: Searching `refs.bib` for any entry related to
"spatialcoarsening" returns no hit. The 2026-05-23 issue (self-future-
citation loop) is resolved by simply removing the entry. The
references to "the journal-format companion" in the body text
(`sections/methodology.tex` line 70, `sections/discussion.tex` line 56)
are now prose-only forward references, which is the cleaner
positioning.

### CV-M3 (new). The Allen Brain Atlas reference `tasic2018shared` is now cited (in the RCTD worked example and in the Visium real-data section)

**Location**: `sections/translation.tex` line 94,
`sections/validation.tex` line 228.

**Comment**: The 2026-05-23 round noted `tasic2018shared` was in
`refs.bib` but uncited. The current revision cites it correctly in two
places. Fixed.

## Minor findings

### CV-min1 (new). Eng et al. 2019 (seqFISH+) still not cited

**Location**: `sections/introduction.tex` line 9 mentions seqFISH+
but cites only chen2015spatially (MERFISH) and wang2018three
(STARmap, not seqFISH+).

**Comment**: The 2026-05-23 CV-min2 finding stands. One-line fix: add
the Eng et al. 2019 Nature reference and cite it next to seqFISH+ in
the intro and in the translation table (which mentions seqFISH+ as a
singleton-candidate-set platform).

### CV-min2 (new). The bibliography is comprehensive for ST deconvolution methods; no missing references in the named-methods space

**Comment**: Spot-checked the references list against the methods
named in the paper. All major methods (Cell2location, RCTD, Tangram,
CARD, SPOTlight, Stereoscope, SpatialDecon, DestVI, STdeconvolve,
GraphST) have correct entries with DOIs. No missing standard
references for the central narrative.

### CV-min3 (new). `tsiatis2006semiparametric` remains uncited in body text

**Location**: `refs.bib` lines 239 to 245.

**Comment**: The 2026-05-23 finding stands. State.md flags Tsiatis as
"prior work supplying the apparatus"; if so, it should be cited at
least once in the background section as the standard reference for
semiparametric missing-data theory. One-line addition.

## Bibliography integrity check

- BibTeX builds cleanly (`main.blg` shows no warnings).
- All DOIs conform to expected format.
- Three Zenodo-style DOIs added since 2026-05-23, all in
  `10.5281/zenodo.XXXX` format. Verified format-correct; not pinged
  for resolution.
- Year fields all present.
- No duplicate keys.
- No malformed entries.

## Cross-verification status

- 2026-05-23 CV-M1 (sibling-series Manuscript in preparation): three
  out of four primary cites now have Zenodo DOIs. Fixed for primary
  cites; remaining three (dp, weaksup, phenotype) are acceptable
  forward references.
- 2026-05-23 CV-M2 (self-future-citation loop): entry removed. Fixed.
- 2026-05-23 CV-min2 (Eng 2019 seqFISH+): not addressed.
- 2026-05-23 CV-min3 (Heitjan-Rubin one-citation): not addressed but
  acceptable.

## Severity calibration

No critical or major issues remain. The two minor findings (Eng 2019,
Tsiatis 2006) are one-line additions each.
