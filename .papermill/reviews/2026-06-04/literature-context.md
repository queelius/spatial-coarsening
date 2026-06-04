# Literature Context Packet (2026-06-04)

**Tooling note.** WebSearch / live DOI resolution was NOT available in this
review session (neither the orchestrator nor sub-tools exposed a web tool, and
the Task tool for spawning dedicated scout agents was unavailable). All
prior-art assessment below is from model background knowledge with a January
2026 cutoff. Items that should be confirmed against a live search before
submission are tagged [CONFIRM-LIVE]. DOIs present in refs.bib were checked for
format and internal plausibility only, not pinged for resolution.

## A. Confirmed-current method/benchmark set (background knowledge)

The paper's cited method set is the standard, correct roster for ST cell-type
deconvolution as of early 2026:

- Cell2location (Kleshchevnikov et al. 2022, Nat Biotechnol) - hierarchical
  Bayesian. Cited, DOI 10.1038/s41587-021-01139-4.
- RCTD (Cable et al., Nat Biotechnol vol 40, 2022) - regularized Poisson MLE,
  `spacexr`. Cited as cable2021robust, DOI 10.1038/s41587-021-00830-w.
  [METADATA: bib key says 2021, fields say 2022; print issue is 2022, online
  2021. Internally consistent enough; see citation-verifier.]
- Tangram (Biancalani et al. 2021, Nat Methods) - deep alignment. Cited,
  DOI 10.1038/s41592-021-01264-7.
- CARD (Ma & Zhou 2022, Nat Biotechnol) - spatial-smoothness NMF. Cited.
- SPOTlight (Elosua-Bayes 2021, NAR) - seeded NMF regression. Cited.
- Stereoscope (Andersson 2020, Commun Biol) - probabilistic NB. Cited.
- SpatialDecon (Danaher 2022, Nat Commun) - log-normal regression. Cited.
- DestVI (Lopez 2022, Nat Biotechnol) - conditional deep generative. Cited.
- STdeconvolve (Miller 2022, Nat Commun) - reference-free LDA. Cited.
- GraphST (Long et al. 2023, Nat Commun) - graph self-supervised. Cited as
  zhang2023spatially (author-key mismatch; first author is Long).
- Li et al. 2023 (Nat Commun) - the comprehensive benchmark. Cited.

Verdict: the named-methods coverage is comprehensive and current. No major
established deconvolution method is missing from the roster.

## B. Potential freshness gaps 2023-2026 [CONFIRM-LIVE]

Because live search was unavailable, these are flagged as plausible gaps to
check rather than confirmed omissions:

1. **Newer deconvolution methods (2023-2026).** Candidates that may warrant a
   one-line mention if they post-date the current roster: SpaCET, Redeconve,
   SpatialDDLS, spotlight successors, and transformer/foundation-model
   approaches to spatial deconvolution. None changes the paper's thesis (it is
   method-agnostic), but a "the roster continues to grow; all fit the same
   ledger" sentence would future-proof the positioning. [CONFIRM-LIVE]

2. **Benchmarks beyond Li 2023.** There may be additional 2023-2025
   benchmarking efforts. The paper leans on Li 2023 as the single benchmark
   anchor; a second benchmark citation would harden the "methods perform
   differently on different tissues" claim. [CONFIRM-LIVE]

3. **Identifiability of spatial deconvolution specifically.** This is the
   freshness check that matters most, because identifiability IS the paper's
   contribution. From background knowledge I am not aware of a prior paper that
   states a formal rank condition for ST deconvolution identifiability under a
   coarsening/missing-data lens. If such a paper exists (2023-2026), it is the
   single most important thing to find before submission. [CONFIRM-LIVE -
   HIGH PRIORITY]

## C. Competing theoretical framings the paper should engage (prior art for
an identifiability claim about X = P mu)

This is the most substantive prior-art gap. The paper's core object is a linear
mixing model (spot-mean = composition x signature), and identifiability of
linear/bilinear mixing is a mature topic OUTSIDE genomics. The paper cites the
author's own reliability framework and Heitjan-Rubin but does not engage the
following established identifiability literatures, any of which a theory
reviewer (AISTATS/RECOMB) will expect:

1. **NMF uniqueness / non-uniqueness.** The cell-total consistency result
   (aggregate fit reproduced while per-factor estimates are non-unique) is, at
   its core, the classical NMF rotational/scaling non-uniqueness phenomenon.
   The separability condition (Donoho & Stodden 2003, "When does non-negative
   matrix factorization give a correct decomposition into parts?") and the
   anchor-word / pure-pixel conditions (Arora et al. 2012-2013 on provable NMF
   and topic models) are the canonical references. The paper's rank condition
   on P and its kernel-dimension (S-K)(J-K) result are close cousins of these.
   ENGAGING THIS IS IMPORTANT: a reviewer will recognize the cell-total result
   as NMF non-identifiability dressed in coarsening language unless the paper
   explicitly situates it.

2. **Mixed-membership / admixture model identifiability.** The composition
   vector p_s on the simplex is a mixed-membership object. Identifiability of
   mixed-membership and topic models (Anandkumar et al. tensor methods;
   Arora-Ge-Moitra) gives separability/anchor conditions directly comparable to
   the rank condition. [Background knowledge.]

3. **Mixture-proportion / simplex identifiability.** Estimating mixing
   proportions from a known signature library is a classical statistical
   identifiability problem (the design-matrix full-column-rank condition is
   textbook for the proportions-known-signature case). The paper's rank theorem
   is the genomics instance of this; the link should be acknowledged so the
   theorem reads as "the right specialization of a known principle" rather than
   "novel."

4. **Bulk RNA-seq deconvolution.** Bulk deconvolution (CIBERSORT/CIBERSORTx,
   MuSiC, BisqueRNA, dtangle, BayesPrism) predates spatial and solves the same
   X = signature x proportions algebra. If any bulk-deconvolution paper has
   already characterized identifiability of that system, the ST paper inherits
   that prior art and must cite it. [CONFIRM-LIVE - the paper currently engages
   zero bulk-deconvolution literature, which is a visible omission for a
   genomics venue.]

## D. Venue-fit notes

- **RECOMB** (12-page conference): best fit for the current scope. Theory +
  simulation + one real-data diagnostic is a recognizable RECOMB contribution.
  The identifiability framing plays well. Lowest revision burden.
- **AISTATS**: would value the identifiability theory but would demand explicit
  engagement with NMF/mixed-membership identifiability (section C above) and
  cleaner theorem statements (the proof "sketches" would need promotion).
- **Bioinformatics**: methodology-friendly; the rank-condition-as-diagnostic
  angle is presentable, but Bioinformatics reviewers will want a usable tool or
  at least a diagnostic recipe, and will ask about bulk-deconvolution prior art.
- **Genome Biology / Nature Methods**: highest bar. Both will demand head-to-head
  benchmarking against RCTD/Cell2location/Tangram on shared inputs (the paper
  explicitly defers this to a "journal-format companion"). For these venues the
  deferral is a likely desk-reject or major-revision trigger.

## E. Bottom-line prior-art verdict

- The "first formal identifiability treatment of ST DECONVOLUTION specifically"
  framing is plausibly defensible [CONFIRM-LIVE], but
- the contribution is NOT novel relative to the broader identifiability-of-
  linear-mixing literature (NMF separability, mixed-membership/topic-model
  identifiability, mixture-proportion identifiability). The paper must engage
  that literature to position the rank condition and the cell-total
  (non-)uniqueness result honestly. Omitting it is the largest prior-art risk.
- Bulk-deconvolution identifiability is the second gap to close.
