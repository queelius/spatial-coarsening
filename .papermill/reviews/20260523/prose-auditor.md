# Prose Auditor Report

## Scope

Writing quality, narrative arc, notation consistency, conference-format fit at current length.

## Critical findings

### P-C1. Length: 14 pages vs. 12-page conference target; substantive trim is needed

**Location**: Overall; pdfinfo reports 14 pages.

**Problem**: State.md targets ~12 pages including references. The current build is 14 pages. The added Visium real-data subsection (validation.tex lines 137 to 202) is the most likely culprit. For RECOMB (12-page firm limit) the paper is over by 2 pages; for AISTATS the limit is similar; Genome Biology has no hard limit but reviewers prefer concise. Two pages is significant: 1 of pure compression (denser typesetting, table-figure trim) plus 1 of content surgery.

**Suggestion**: Three places to compress without losing substance:
1. The Real Visium subsection has four paragraphs each with a `\paragraph` heading. The "Spectrum" and "Inferred composition is well-conditioned globally" paragraphs could merge (both are about $\sigma$ structure of the data). Estimated saving: 0.3 to 0.5 page.
2. The translation section's "Existing methods in this language" paragraphs (sections/translation.tex lines 66 to 89) could be a single dense paragraph instead of four `\paragraph`-headed micro-sections. Estimated saving: 0.2 page.
3. The discussion's "Relation to existing methods" itemize list (sections/discussion.tex lines 6 to 28) repeats material already in the translation section. Make it a one-paragraph forward-reference: "as described in Section 3.3, these methods are special cases of the framework with the following identifications: [one-sentence summary table or compressed list]". Estimated saving: 0.4 to 0.6 page.

Combined: realistic 1 to 1.5 page reduction, putting the paper at 12.5 to 13 pages. For RECOMB strictness, an additional 0.5 page would come from tightening the introduction's "Practical questions go unanswered" paragraph (3 questions are listed, none individually answered in the abstract: pick the strongest two).

### P-C2. Notation inconsistency between $\bm{\mu}_j$ (column vector in $\R^K$) and the signature matrix $M \in \R^{|\mathcal M|\times K}$

**Location**: Throughout identifiability.tex (uses $\bm \mu_j \in \R^K$, per-gene) and methodology.tex (uses $M \in \R^{|\mathcal M|\times K}$, per-marker-panel).

**Problem**: The reader sees $\bm \mu_j$ in Theorem 1 (per-gene vector across cell types), then $\bm{\mu}_{\mathcal M, k} \in \R^{|\mathcal M|}$ in Theorem 4 (per-cell-type vector across markers), then $M = [\bm \mu_{\mathcal M, 1} | \cdots]$. The two perspectives ("for each gene, a vector across cell types" vs. "for each cell type, a vector across genes/markers") never get tied together explicitly. A note such as "$M = [\bm \mu_1, \ldots, \bm \mu_{|\mathcal M|}]^\top$ when restricted to marker rows" would help the reader keep the orientation straight. Currently the reader has to derive this.

**Suggestion**: At the start of Section 4 (Methodology), add: "Throughout this section, $M$ denotes the marker-restricted expression matrix with rows indexed by markers in $\mathcal M$ and columns by cell types $k=1,\ldots,K$. Equivalently, $M = [\bm\mu_{j_1}, \ldots, \bm\mu_{j_{|\mathcal M|}}]^\top$ where $\{j_1,\ldots\}$ are the marker indices and $\bm\mu_j$ are the per-gene vectors of \cref{thm:rank}." This is a one-sentence fix that prevents real reader confusion.

## Major findings

### P-M1. Abstract overpromises real-data validation; the Visium application is in-dataset not Allen-Atlas

**Location**: Abstract lines 88 to 89.

**Quoted text**: "A simulation study confirms the rank condition, and application to a public Visium dataset confirms cell-total consistency exactly."

**Problem**: "Confirms cell-total consistency exactly" overclaims: the per-entry median absolute residual is $5\times 10^{-5}$ for *hard-cluster pseudobulk* (which is exact by construction, not by the theorem's mechanism, see methodology-auditor M-M2), and NMF $K=20$ gives Frobenius-relative $0.077$ (not exact). The honest abstract claim is: "confirms cell-total consistency up to Poisson noise floor and subspace truncation".

**Suggestion**: Replace "confirms cell-total consistency exactly" with "confirms cell-total consistency to within the Poisson noise floor and the $K$-dimensional subspace truncation". This is honest and still strong.

### P-M2. The "we observe that ST deconvolution is mathematically isomorphic" framing in the introduction is the central novelty claim but is hedged elsewhere

**Location**: Introduction (sections/introduction.tex lines 36 to 38).

**Quoted text**: "We observe that ST deconvolution is mathematically isomorphic to the masked-data series-system identifiability problem"

**Problem**: "Mathematically isomorphic" is the strongest possible word and it is used only once. The discussion section softens this to "subsumes... as special cases" and the abstract uses "instance of the masked-data identifiability problem". "Isomorphic" implies a structure-preserving bijection in both directions; the paper actually demonstrates a one-way embedding (ST $\to$ masked-data), not the inverse (every masked-data problem $\to$ a meaningful ST deconvolution). The technical correct word is "instance of" or "special case of"; "isomorphic" overstates.

**Suggestion**: Replace "mathematically isomorphic to" with "mathematically an instance of" in the introduction. Reserve "isomorphic" for cases where you genuinely have the inverse direction.

### P-M3. The discussion's "What the framework does not address" itemize is the strongest part of the discussion but is followed by "Broader implications" which weakens the close

**Location**: Discussion (sections/discussion.tex lines 39 to 71).

**Problem**: The "does not address" itemize ends on a strong, honest note (limitations clearly stated). Then "Broader implications" returns to high-level claim-restating ("framework's main contribution is shifting... from method-specific to assumption-specific reasoning") that is essentially the introduction repeated. Then "A framework across domains" pivots to the series-papers ad. The reader's last impression is series advertising rather than this paper's content.

**Suggestion**: Reorder discussion subsections as: (a) Relation to existing methods, (b) Broader implications, (c) A framework across domains, (d) What the framework does not address. This puts the limitations last, which is the honest place for them, and the series-papers paragraph in the middle, where it serves as connective tissue rather than the closing note. Alternatively, drop "A framework across domains" entirely and let the conclusion's final paragraph carry the series-papers cross-reference; the discussion would then end on the framework's content limits, which is the strongest position.

### P-M4. "Coarsening at random" in the title sets up an expectation the paper does not exactly fulfill

**Location**: Title and abstract.

**Quoted text**: Title: "Coarsening at random for spatial transcriptomics: identifiability conditions for cell-type deconvolution".

**Problem**: "Coarsening at random" (CAR) is Heitjan-Rubin's specific technical term: a particular condition on the masking mechanism that licenses ignorability. The paper's substantive claim is broader: it ports the C1, C2, C3 conditions (a stronger set than CAR alone) and proves identifiability under all three. The title's CAR framing is reasonable but slightly imprecise. More importantly, the paper does not engage with cases where CAR holds but a stronger condition fails, or vice versa; the title sets up that engagement and does not deliver.

**Suggestion**: Either (a) keep the title and add one paragraph in the background section discussing CAR specifically (versus the stronger C1, C2, C3), or (b) change the title to "Masked-data conditions for spatial transcriptomics: identifiability ..." which is more precise to what the paper does. Option (a) is preferred because "coarsening at random" is more recognizable to a stat-genomics audience.

## Minor findings

### P-min1. Introduction's "Practical questions go unanswered" rhetorical questions are not answered in the intro

**Location**: Introduction lines 28 to 32.

**Problem**: Three questions ("how many marker genes are needed? When can deconvolution fail silently? What is the bias when the marker-gene set undercovers a cell-type?") are posed. Q1 and Q3 are addressed in Section 4 (marker-bias). Q2 is addressed only obliquely (Theorem 3 says naive methods *do* fail silently in the per-cell-type direction). For pace, the introduction should answer each question in one phrase, then signpost where the detailed treatment lives.

### P-min2. Theorem 4 statement uses "$\hat{\bm p}_s(\Delta M)$" notation that is introduced mid-statement

**Location**: Methodology, Theorem 4 lines 40 to 41.

**Quoted text**: "Let $\hat{\bm{p}}_s(\Delta M)$ be the estimate using $M = M^* + \Delta M$."

**Problem**: Inside a theorem statement, defining notation makes the statement harder to parse. Move the definition to the preceding setup paragraph.

### P-min3. "Naive deconvolution methods" appears 4+ times without being defined

**Location**: Throughout; e.g., abstract, conclusion, introduction.

**Problem**: A reader needs to know whether "naive" means (a) unregularized MLE specifically (the Theorem 3 hypothesis), (b) something simpler than RCTD, or (c) pejorative for whatever the author wants to criticize. From context it means (a), but defining it once at first use would help.

**Suggestion**: First use: "naive (unregularized-MLE) deconvolution methods".

### P-min4. Cleveref-vs-bare-cite inconsistency in conclusion

**Location**: Conclusion (sections/conclusion.tex lines 24, 25, 30 to 33).

**Problem**: Most references use `\cref{}` for internal refs and `\citep{}` for citations. Conclusion uses `\cite{}` (bare) for all citations: `\cite{towell2026mdrelax}`, `\cite{towell2026scrnacoarsening}`, etc. Elsewhere the convention is `\citep{}` for parenthetical. Minor style fix.

### P-min5. "Tier 2 would strengthen" Sensitivity-analysis on marker-gene panel is in state.md, but the paper already does this experiment

**Location**: state.md Tier 2 (line 106).

**Problem**: The state.md Tier 2 says "Sensitivity analysis on marker-gene panel size to empirically recover Tangram's few hundred markers." Validation.tex actually does this in the marker-gene bias subsection (lines 80 to 98). The state.md is out of date. Worth updating for tracking.

## Cross-verification with prior pass

The prior 2026-05-22 pass addressed I1 (intro overclaim softened from "None... characterize" to "no prior work characterizes [...] through the lens"). The current intro line 26 is consistent with this softening. I3 softened "predicts" to "is consistent with" in the methodology bias-marker section; this is honored at line 73 ("is consistent with"). I5 added the framework-across-domains paragraph to the conclusion; present at lines 27 to 34.

Findings P-M1, P-M2, P-M4 are fresh (not previously flagged). P-M3 is structural and partially relates to I5 (the framework-across-domains paragraph was added but the discussion's narrative arc was not reconsidered after the addition).

## Severity calibration note

P-C1 (length over target) is the most consequential prose finding because it constrains venue choice. P-C2 (notation orientation) and P-M1 (abstract overclaim) are quick fixes that materially improve precision. The prose is generally tight and technically careful; the issues are at the seams (transitions between sections, theorem-statement choices, abstract calibration).
