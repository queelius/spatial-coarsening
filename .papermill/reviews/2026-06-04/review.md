# Unified editorial review: spatial-coarsening (2026-06-04)

Final pre-submission pass. Application paper: coarsening-at-random
identifiability for spatial-transcriptomics cell-type deconvolution. Candidate
venues: a genomics/methods venue (RECOMB, AISTATS, Bioinformatics) or fold into
the synthesis paper.

This synthesis integrates seven specialist lenses (logic-checker,
methodology-auditor, novelty-assessor, citation-verifier, prose-auditor,
format-validator, literature-context). The orchestrator that launched them was
interrupted by a rate-limit before writing this synthesis; the per-specialist
files are complete and were written 2026-06-04. WebSearch proper was
unavailable; prior-art freshness was checked via background knowledge plus DOI
resolution, and several currency items are tagged CONFIRM-LIVE for a live pass.

## Verdict: minor-revision

No Critical. The proofs are sound, the prior fixes integrated cleanly, and the
empirical claims are correctly scoped. The substantive items are all
novelty-POSITIONING: the paper under-engages the broader identifiability
literature its results specialize. These are framing fixes (situate, do not
weaken), but they are the difference between accept and major-revision at a
methods-savvy venue.

## Correction to the working assumption (important)

The paper is NOT sim-only. The methodology-auditor found it contains a real
public 10x Visium application (adult mouse coronal brain), correctly scoped to
DIAGNOSTICS (singular-value spectrum, NMF residual decomposition, rank
restoration on a subregion), explicitly NOT a per-cell-type recovery validation.
The honesty/scoping check PASSES: the abstract and the "Scope of the empirical
validation" paragraph confine every claim to conditions-on-inputs any method
shares, flag the hard-cluster issue, and defer head-to-head benchmarking. There
is no overclaim of real-data validation.

## Proof soundness (verified)

- **thm:rank (rank condition): SOUND.** P full column rank K is necessary and
  sufficient for identifiability of mu via (P^T P)^{-1} P^T m; proof correct.
- **thm:cell-total-st (cell-total consistency): SOUND, and the prior
  intersection-of-kernels fix is correct.** The corrected proof is the stronger
  version (P^T R = 0 and R U = 0 are exactly the normal equations); verified.
- **Marker-gene bias bound: VERIFIED.** The H_pp = M^T M conditioning algebra is
  numerically exact; the noise-floor formula correction (prior round M-M3) is
  now dimensionally consistent and reproduces (floor 0.053; toy limit ~1/sqrt(N)
  = 0.045). Running `scripts/cell_total_kernel.R` reproduces every quoted number
  exactly (kernel dimension (S-K)(J-K); saturated |P^T R|=1.5e-13; non-saturated
  2e-9 / 7e-15 / 0.097). Strong reproducibility.
- The synthesis cross-reference and prior fixes read cleanly in context.

## Major (novelty positioning, 4)

- **NV-1 (largest risk): under-distinguished from the identifiability-of-linear-
  mixing literature.** The rank condition is the textbook design-matrix
  identifiability condition specialized to genomics, and the cell-total
  non-uniqueness result is, at core, the classical NMF rotational/scaling
  non-identifiability (kernel dimension (S-K)(J-K)). The NMF separability /
  anchor-word literature (Donoho-Stodden 2003; Arora et al. provable NMF /
  topic-model identifiability) and mixed-membership/admixture identifiability are
  cited NONE. A methods reviewer will recognize cell-total as NMF
  non-identifiability in coarsening clothing. Fix: one paragraph situating (a)
  the rank condition as the genomics instance of the standard linear-mixing
  condition and (b) cell-total as the coarsening reading of NMF non-uniqueness,
  with the value-add being the unified vocabulary, the singleton-restoration
  mechanism, and the bias bound. Honest framing keeps the contribution; current
  framing overstates within-deconvolution novelty.
- **NV-2: bulk RNA-seq deconvolution absent.** CIBERSORTx, MuSiC, BisqueRNA,
  dtangle, BayesPrism solve the same signature-times-proportions algebra and
  predate spatial; the rank condition applies to them verbatim. Add a short
  paragraph; it closes a visible genomics gap and sharpens the spatial-specific
  novelty (spot-as-candidate-set + singleton restoration).
- **NV-3: "subsumes Cell2location, RCTD, Tangram, CARD as special cases" is
  demonstrated only for RCTD.** The RCTD worked example is genuinely good
  (explicit C1/C2/C3 mapping, likelihood, bias bound, correct rank distinction).
  The other three are one paragraph asking the reader to construct the
  derivations. Either downgrade the abstract/conclusion claim to "we work RCTD in
  full and sketch the others," or add brief explicit derivations for at least
  one more (Cell2location is the highest-value second case).
- **NV-4: differentiation from the precursor scRNA-seq paper is thin.** State the
  boundary in a sentence (binary zero/nonzero candidate set there vs the
  spot-composition candidate set here).

## Minor

- Citations: GraphST entry author-key mismatch (renders correctly, cosmetic);
  RCTD entry key-year vs field-year (CONFIRM-LIVE); `tsiatis2006semiparametric`
  uncited in the body; seqFISH+ mentioned six times but its primary reference
  (Eng et al. 2019) is uncited, add it.
- Prose: the synthesis cross-reference sentence is dense and lands abruptly
  (smooth the transition); the "Decomposing the NMF residual" paragraph is a
  wall of computation (the content is correct, but it is the paragraph most
  likely to lose a reader, consider tightening or boxing it); inconsistent
  "[Sketch]" labels relative to content maturity.
- Build: PASS (clean, all cross-references bind, theorem numbering shared
  correctly, conventions compliant). Venue note: 18 pages against a stated
  "12 pages incl. references" conference target, 6 pages over; needs trimming if
  a conference venue is chosen (not an issue if folded into the synthesis or sent
  to a journal).

## Prior-art freshness

The named ST-method roster (Cell2location, RCTD, Tangram, CARD, plus the Li
et al. 2023 benchmark) is comprehensive and current. The gaps are the adjacent
literatures (NMF-identifiability, bulk deconvolution) the results specialize,
not the ST methods themselves. Several currency items tagged CONFIRM-LIVE for a
live search pass.

## Single most important remaining item

Add the one positioning paragraph (NV-1) situating the rank condition and
cell-total result against the NMF-identifiability / linear-mixing literature.
That single paragraph converts the largest reviewer-rejection risk into a
demonstrated-awareness strength, and the genuine novelty (the coarsening
unification across the series + singleton restoration + bias bound) survives
intact. Decision still open whether to push standalone (needs NV-1/NV-2/NV-3
plus conference trim) or fold into the synthesis paper as the spatial worked
example.
