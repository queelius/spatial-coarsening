# Multi-Agent Review Report

**Date**: 2026-06-08
**Paper**: Coarsening at random for spatial transcriptomics: identifiability conditions for cell-type deconvolution
**Recommendation**: minor-revision

## Summary

**Overall Assessment**: This is a mature, well-executed application paper that
ports the masked-data coarsening-at-random framework to spatial-transcriptomics
cell-type deconvolution. The three theorems are sound, the empirical program is
unusually reproducible (every numerical claim spot-checked this pass reproduced
to the digit by running the scripts), and the novelty claim is honestly scoped as
unification rather than new-criterion discovery. The largest risk flagged by the
prior (2026-06-04) review, under-engagement with the NMF-identifiability /
linear-mixing literature, has since been ADDRESSED. The remaining items are
positioning gaps (bulk-deconvolution literature, full "subsumes four methods"
demonstration) plus small accuracy/format fixes, none of which threaten
soundness.

**Strengths**:
1. All three theorems are correct, and the corrected cell-total theorem is the
   honest stronger version (it refutes the tempting wrong claim and gives the
   exact kernel-dimension condition). (logic-checker)
2. Exceptional reproducibility: `cell_total_kernel.R` and `rctd_compare.R` both
   reproduce their quoted numbers exactly (kernel dimension (S-K)(J-K); saturated
   |P^T R|=1.5e-13 / per-entry 0; non-saturated 2e-9 / 0.097; RCTD head-to-head
   0.026/0.046 and 0.011/0.044). (methodology-auditor)
3. Honest empirical scoping: the real-data Visium application is confined to
   conditions-on-inputs diagnostics, flags the hard-cluster category issue
   upfront, and defers head-to-head benchmarking with a stated reason. No
   real-data overclaim. (methodology-auditor)
4. The novelty claim is correctly modest and now well-defended against the
   linear-mixing / NMF-uniqueness literature; the connection to the recent
   ivich2025 Genome Biology finding is a strong timeliness win. (novelty-assessor)
5. Clean build and presentation: 0 undefined refs, 0 over/underfull boxes, no
   em-dashes, notation carefully disambiguated, figures match the text.
   (format-validator, prose-auditor)

**Weaknesses**:
1. Bulk RNA-seq deconvolution literature (CIBERSORTx, MuSiC, BayesPrism, ...) is
   absent though the rank condition applies to it verbatim; a visible genomics
   gap. (novelty-assessor NV-2, citation-verifier CV-2)
2. The "subsumes Cell2location, RCTD, Tangram, CARD as special cases" claim is
   demonstrated in full only for RCTD; the other three are a "construct it
   yourself" paragraph. (novelty-assessor NV-3, methodology-auditor M-1)
3. Venue-format mismatch: source declares a 12-page conference target but the
   artifact is 19 pages and the stated primary venue is Genome Biology (no
   12-page limit). The two framings are inconsistent. (format-validator F-1)
4. A handful of small accuracy fixes: the real-data dataset is miscited to Stahl
   2016, seqFISH+ primary reference is uncited, one orphan bib entry, and the
   abstract attributes Tangram's rule to the wrong theorem.
   (citation-verifier, prose-auditor)

**Finding Counts**: Critical: 0 | Major: 3 | Minor: 8 | Suggestions: 4

## Critical Issues

None. The proofs are sound, the empirical claims are correctly scoped and
reproduce exactly, the build is clean, and the novelty framing is honest.

## Major Issues

### NV-2 / CV-2: Bulk RNA-seq deconvolution literature absent (source: novelty-assessor, citation-verifier)
- **Location**: identifiability.tex positioning block (lines 71-92);
  discussion.tex relation-to-methods.
- **Quoted text**: "Our contribution is not a new identifiability criterion for
  deconvolution but a re-derivation of the existing full-column-rank condition as
  the coarsening-rank condition" (introduction.tex lines 29-32).
- **Problem**: CIBERSORTx, MuSiC, BisqueRNA, dtangle, and BayesPrism solve the
  identical signature-times-proportions algebra and predate spatial
  deconvolution; the rank condition applies to them verbatim. None is cited. A
  genomics referee sees an uncited adjacent field that the results directly
  specialize. cai2024inference (already cited) is itself a bulk-deconvolution
  inference paper, so the door is open.
- **Suggestion**: Add one short paragraph acknowledging the bulk-deconvolution
  lineage plus 2-3 citations (MuSiC, BayesPrism, CIBERSORTx). This both closes the
  gap and SHARPENS the spatial-specific novelty by contrast (the spot-as-
  candidate-set structure and singleton restoration via single-cell-resolution
  platforms are what is genuinely new and spatial-specific).
- **Cross-verified**: yes, by prose-auditor (concurs it is a framing/positioning
  fix, not a weakening) and by literature-context (confirms it is the single most
  visible bibliographic gap). No disagreement.

### NV-3 / M-1: "Subsumes four methods" demonstrated only for RCTD (source: novelty-assessor, methodology-auditor)
- **Location**: abstract (main.tex lines 93-95), conclusion.tex lines 16-18,
  translation.tex lines 124-141.
- **Quoted text**: "The framework subsumes RCTD, Cell2location, and Tangram as
  special cases, with an RCTD worked derivation provided in the text" (abstract,
  main.tex lines 93-95).
- **Problem**: The RCTD worked derivation is genuinely complete and correct
  (explicit C1/C2/C3 mapping, Poisson likelihood, bias-bound application, correct
  rank distinction). The other three named methods get one paragraph that asks
  the reader to construct the derivations ("We do not derive each in detail here;
  the RCTD derivation above is the template"). The headline claim outruns the
  demonstration.
- **Suggestion**: Either (a) downgrade the headline to "we work RCTD in full and
  indicate how the others specialize," or (b) add a brief explicit derivation for
  one more method. Cell2location is the highest-value second case because its
  hierarchical prior is precisely the regime where thm:cell-total-st's
  unconstrained-optimum hypothesis fails, so deriving it also demonstrates the
  boundary of the cell-total theorem. Option (b) dovetails with extending the
  existing RCTD-style head-to-head to one real published method on the synthetic
  Visium-scale data, which is the methods-venue strengthener M-1.
- **Cross-verified**: yes, novelty and methodology independently raised the same
  item from different angles (demonstration completeness vs benchmark coverage)
  and agree on Cell2location as the target. No disagreement.

### F-1: Page budget vs venue framing mismatch (source: format-validator)
- **Location**: main.tex line 3.
- **Quoted text**: "%% Conference-format draft (target: 12 pages incl.
  references)."
- **Problem**: The artifact is 19 pages (`Output written on main.pdf (19
  pages)`), 7 pages over the declared 12-page conference target, while state.md
  lists Genome Biology (no hard page limit) as the primary venue. The source's
  declared target and the artifact's actual size point at different venues.
- **Suggestion**: Commit to one path. If Genome Biology / Bioinformatics /
  Nature Communications (journal): remove or loosen the 12-page header comment;
  19 pages is fine and F-1 is moot. If RECOMB (12-page conference): trim
  substantially (the NMF-residual-decomposition paragraph, the duplicated method
  roster across translation and discussion, and the full marker-bias derivation
  are the natural compressions) or move detail to a supplement.
- **Cross-verified**: not contested; this is a decision item, not a defect.
  Build itself is clean.

## Minor Issues

### CIT-dataset: Real-data dataset miscited to Stahl 2016 (source: citation-verifier)
- **Location**: validation.tex line 229.
- **Quoted text**: "the public 10x Genomics V1 adult mouse coronal brain Visium
  dataset \citep{stahl2016visualization}".
- **Problem**: Stahl 2016 is the original Spatial Transcriptomics METHOD paper,
  not the 10x Visium mouse-brain dataset. Right key for "ST" generically, wrong
  key for this specific dataset.
- **Suggestion**: Cite the 10x Genomics data release (or the Visium platform
  reference) for the dataset sentence; keep Stahl 2016 where ST-as-a-method is
  introduced.

### CV-1: seqFISH+ primary reference uncited (source: citation-verifier, literature-context)
- **Location**: introduction.tex line 9, translation.tex line 44, and three
  other sections (seqFISH+ named six times total).
- **Problem**: seqFISH+ IS the singleton-candidate-set device (load-bearing for
  the central mechanism), yet its primary publication (Eng et al., Nature 2019)
  is uncited, while MERFISH (chen2015spatially) and STARmap (wang2018three) have
  their primary cites.
- **Suggestion**: Add Eng et al. 2019.

### CV-orphan: tsiatis2006semiparametric is an orphan entry (source: citation-verifier)
- **Location**: refs.bib lines 255-261.
- **Problem**: defined but cited nowhere in the body.
- **Suggestion**: cite it in background.tex (natural home for the semiparametric
  missing-data lineage) or remove it.

### P-min-4 / abstract attribution: Tangram rule credited to the wrong theorem (source: prose-auditor)
- **Location**: main.tex lines 96-98.
- **Quoted text**: "Tangram's empirical observation that ``a few hundred marker
  genes suffice'' is recovered as a corollary of the rank condition."
- **Problem**: It is the marker-gene bias bound (thm:bias-marker, via the
  conditioning of M) that recovers the "few hundred markers" rule, not the rank
  condition (thm:rank). The body (methodology.tex) attributes it correctly; the
  abstract does not.
- **Suggestion**: change "the rank condition" to "the marker-gene bias bound" in
  the abstract sentence.

### L-min-1 / P-min-3: Inconsistent [Sketch] proof labels (source: logic-checker, prose-auditor)
- **Location**: identifiability.tex thm:cell-total-st proof; methodology.tex
  thm:bias-marker proof.
- **Problem**: Both proofs are labeled `[Sketch]`, but the cell-total proof is
  effectively complete (the kernel-dimension argument is fully present) while the
  bias-bound proof genuinely defers the full derivation to the companion. Same
  label for complete and incomplete proofs misleads a referee.
- **Suggestion**: relabel the cell-total proof as a full `\begin{proof}`.

### P-min-1: Dense synthesis cross-reference sentence (source: prose-auditor)
- **Location**: identifiability.tex lines 192-197.
- **Problem**: a single clause packs three ideas (synthesis-paper subsumption,
  the singleton device, the domain-independent rank/restoration mechanism) and
  lands abruptly after the ivich2025 discussion.
- **Suggestion**: split into two sentences or move to a short framework-context
  remark.

### P-min-2: NMF-residual-decomposition paragraph is a wall of computation (source: prose-auditor)
- **Location**: validation.tex lines 280-305.
- **Problem**: correct and reproducible but the paragraph most likely to lose a
  reader.
- **Suggestion**: tighten to the conclusion (floor 0.053, observed 0.077, excess
  attributable to substructure beyond K=20); push the variance derivation to a
  footnote or the companion.

### M-min-2: N_s as count-proxy for cell number on Visium (source: methodology-auditor)
- **Location**: validation.tex real-data section; translation.tex eq:trans-spot.
- **Problem**: the mean model X_sj ~ N_s sum_k p_sk mu_jk treats N_s as cells per
  spot, but Visium reports per-spot total counts, not cell counts. The theorems
  are unaffected (they hold for any known nonnegative N_s), but the conflation is
  unstated.
- **Suggestion**: one half-sentence noting N_s is a count-based proxy for cell
  number on sequencing platforms.

## Suggestions

1. Add one Arora et al. (anchor-word / topic-model NMF identifiability) citation
   to support the "separability and anchor conditions" phrase in
   identifiability.tex line 84 (currently invoked by name, cited only via Donoho-
   Stodden and Fu et al.). (citation-verifier CV-3, literature-context)
2. Confirm the seven framework-series Zenodo DOIs resolve to the intended records
   before submission (the coarsening-root CLAUDE.md documents prior duplicate-
   deposit incidents; state.md and refs.bib list slightly different digits for
   three of them, with refs.bib resolving cleanly in the build).
   (citation-verifier)
3. Add a one-line caption note on `marker_bias.pdf` that the slope comparison
   (not the absolute offset) is the claim, since the iid baseline offset depends
   on the unspecified pool size J^*. (methodology-auditor M-min-1)
4. Consider whether to push this standalone (needs NV-2/NV-3 + a venue-format
   decision) or fold it into the synthesis paper as the spatial worked example
   (which would moot NV-2/NV-3, since the synthesis paper carries the cross-domain
   positioning). (novelty-assessor, prior-review continuity)

## Detailed Notes by Domain

### Logic and Proofs
All three theorems sound. thm:rank: full self-contained proof, both directions,
with the correct positivity caveat in the necessary direction; identifiability of
mu_j reduces correctly to identifiability of the Poisson mean vector. thm:cell-
total-st: the corrected intersection-of-kernels version is right; the score
equations give P^T R = 0 and R U = 0 (part a, unconditional), and per-entry R = 0
holds only in the saturated regime rank(Xbar) <= K (part b), because the operator
Lambda has kernel dimension (S-K)(J-K) > 0 when K < min(S,J). thm:bias-marker:
the IFT hypotheses are exactly right and the H_pp = M^T M conditioning algebra is
exact. Numerical reproduction of the cell-total and RCTD claims is exact. Only
minor item: the cell-total proof is mislabeled `[Sketch]`.

### Novelty and Contribution
Honestly scoped as unification, not new-criterion discovery, and now well-
defended. NV-1 (NMF/linear-mixing positioning), the prior round's top risk, is
RESOLVED in identifiability.tex lines 71-92. NV-4 (differentiation from the
scRNA-seq precursor) is RESOLVED (binary candidate set there vs spot-composition
candidate set here). Remaining: NV-2 (bulk deconvolution absent) and NV-3
(four-methods claim demonstrated only for RCTD). The genuine spatial-specific
contributions (singleton restoration via single-cell-resolution platforms, the
marker-gene bias bound recovering Tangram's rule, the algebraic explanation of
the ivich2025 finding) are real and worth publishing.

### Methodology
Strong. Simulation DGP is the standard ST model; the structured G=6 rank-
deficient scenario is the cleanest possible test of singleton restoration; the
joint-(mu, P) experiment correctly tests thm:rank directly (closing the gap the
mu-known rctd_compare left open); the noise-floor decomposition is dimensionally
consistent. Honesty/scoping passes: real-data claims confined to conditions-on-
inputs, hard-cluster framed as a constrained estimator, head-to-head deferred with
a reason. The one strengthener (M-1) is a real method-vs-method benchmark for the
methods-venue target; the existing RCTD-style re-implementation is the partial
foundation.

### Writing and Presentation
Clean, tight, conference-style; notation carefully disambiguated (mu scalar vs
mu_j vector vs M marker matrix vs U-hat full matrix); no em-dashes; figures match
text. Minor polish: dense synthesis cross-reference sentence, computation-heavy
NMF-residual paragraph, inconsistent [Sketch] labels, and one abstract
attribution slip (Tangram rule to rank condition rather than bias bound).

### Citations and References
30 bib entries, 27 cited, build clean (0 undefined). One genuine orphan
(tsiatis2006semiparametric). chen2015/wang2018 are cited (multi-key citep, not
orphans). Content gaps: seqFISH+ primary (Eng 2019) uncited despite six mentions;
bulk-deconvolution methods absent; one dataset miscitation (Stahl 2016 used for
the 10x Visium dataset). Self-cite Zenodo DOIs now live; confirm they resolve.

### Formatting and Production
Build PASS: 0 undefined, 0 over/underfull, all cleveref bindings resolve, theorem
counter shared correctly, conventions compliant (no em-dash, author identity
correct). Sole format finding is the 12-page-target vs 19-page-artifact vs
Genome-Biology-primary inconsistency (F-1), a venue decision rather than a defect.

## Literature Context Summary
ST-method coverage is comprehensive and current (Cell2location, RCTD, Tangram,
CARD, SPOTlight, Stereoscope, SpatialDecon, DestVI, STdeconvolve, GraphST, Li
2023 benchmark). The coarsening apparatus is correctly attributed (Heitjan-Rubin
1991, the Towell masked-data series). The positioning gaps are exclusively in the
adjacent specialized literatures the results specialize: NMF/linear-mixing
(NV-1, now fixed), bulk deconvolution (NV-2/CV-2, open), anchor-word NMF (Arora,
suggestion), and the seqFISH+ primary reference (CV-1). All are closable with a
short paragraph plus a few citations rather than new technical work. The
ivich2025 connection is a strong, current explanatory anchor.

## Review Metadata
- Agents used (lenses): logic-checker, methodology-auditor, novelty-assessor,
  prose-auditor, citation-verifier, format-validator, literature-context. Run as
  direct specialist lenses by the area chair (sub-agent Task spawning not used
  this pass); each lens grounded in direct reading plus script execution.
- Verification performed this pass: full `make paper` build; undefined-reference
  scan (0); over/underfull scan (0); em-dash scan (0); citation-key vs bib diff;
  execution of `cell_total_kernel.R` and `rctd_compare.R` (both reproduced quoted
  numbers exactly); visual inspection of all three figures against text;
  hallucination check of every major and minor finding against the manuscript
  source.
- Cross-verifications performed: 2 (NV-2 routed novelty <-> prose <-> literature;
  NV-3/M-1 routed novelty <-> methodology; both converged, no disagreement).
- Disagreements noted: 0.
- Continuity: builds on 2026-06-04 review; confirms NV-1 and NV-4 from that round
  are now resolved in the source; carries forward NV-2, NV-3, the seqFISH+/orphan
  citation items, and the page-budget item.
