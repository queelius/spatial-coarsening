# Literature context (carry-forward)

The 2026-05-23 literature scout output remains current for this paper's
positioning. Key points relevant to this fast-follow round:

- The ST deconvolution methods space has not received a formal
  identifiability treatment in published work. Li et al. 2023's
  comprehensive benchmark is the standing reference for empirical
  comparison and explicitly flags the absence of theory predicting
  *which* tissues are problematic before running methods.

- Within the bibliography, the strongest direct comparator is
  `li2023comprehensive`. The paper does not engage with it deeply in
  validation; this is a known and reasonable scope decision for the
  conference-format version.

- For the RCTD worked-example subsection added on 2026-05-27, the most
  relevant external check is `cable2021robust` itself: the derivation
  in `sections/translation.tex` lines 70 to 109 correctly transcribes
  RCTD's per-spot Poisson MLE with the simplex constraint. The
  platform-effect term in the original spacexr implementation is
  explicitly bracketed in the paper text ("possibly inflated by a
  multiplicative platform-effect term, which we omit here without loss
  of generality"). This is a defensible simplification; the platform
  effect is orthogonal to the C1, C2, C3 mapping being demonstrated.

- The Allman, Matias, Rhodes 2009 (Kruskal-rank latent-class)
  connection flagged in the 2026-05-23 lit context remains uncited; it
  is a worthwhile one-sentence add for theoretical grounding of Theorem
  1, but not gating for submission. Eng et al. 2019 (seqFISH+) is
  similarly unaddressed.

- The companion-series Zenodo DOIs (towell2026masked,
  towell2026mdrelax, towell2026scrnacoarsening) are now live, closing
  the CV-M1 critical finding from the prior round. The remaining three
  sibling-series cites (dp, weaksup, phenotype) still carry "Preprint,
  DOI pending" and read as forward references; for Genome Biology this
  is venue-acceptable provided they are described as planned companions
  rather than load-bearing for any current claim.
