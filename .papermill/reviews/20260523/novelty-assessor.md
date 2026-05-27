# Novelty Assessor Report

## Scope

Contribution clarity, differentiation from prior work, significance to target venues.

## Position summary

The paper claims four contributions: (1) a bridge from ST deconvolution to masked-data inference, formalizing existing methods as special cases; (2) a rank-condition identifiability theorem; (3) a cell-total consistency theorem; (4) a closed-form bias bound under marker-gene undercoverage. The intended novelty is the *bridge* itself: porting Heitjan-Rubin and the masked-cause reliability framework to ST deconvolution, with the four named ST deconvolution methods landing as special cases.

This positioning is genuinely novel as far as I can establish from the bibliography and the paper's own framing. The framework-level reframing of ST deconvolution as a coarsening problem has not been done in any of the cited prior work (Cell2location, RCTD, Tangram, CARD, SPOTlight, Stereoscope, SpatialDecon, DestVI, STdeconvolve, GraphST), and the Li 2023 comprehensive benchmarking paper is explicitly empirical rather than identifiability-theoretic.

## Critical findings

### N-C1. The "subsumes... as special cases" claim is the central novelty but is asserted rather than demonstrated

**Location**: Abstract; Introduction; Discussion; Conclusion; Section 3.3 Translation.

**Quoted text** (abstract): "The framework subsumes RCTD, Cell2location, and Tangram as special cases and provides a precise vocabulary for when each method is appropriate."

**Problem**: Subsumption is a strong technical claim. For it to be a contribution, the paper needs to: (a) write down a method's likelihood / objective, (b) show it matches the framework's general form, and (c) identify which C-conditions and rank conditions are at play. The paper currently does step (a) and (b) at the level of one English-language paragraph per method (Section 3.3) and does not do (c) for any method. The reader is asked to take on faith that "RCTD = ML specialization of the framework with parametric Poisson per-cell-type expression". A skeptical reviewer at any of the target venues (Genome Biology, Nature Methods, RECOMB) will press on this.

The strongest move would be a worked-example subsection for RCTD: state its objective verbatim, identify each C-condition explicitly, derive the rank condition for it. This is one-to-two pages and dramatically strengthens the central novelty claim. It also lets the bias bound (Theorem 4) bite in a specific way: "RCTD's bias under marker-gene undercoverage is given by Theorem 4 with $\bm H_{pp}$ equal to..."

**Suggestion**: Either add a worked-example subsection for RCTD specifically (preferred), or soften the language throughout from "subsumes as special cases" to "shows how to formulate in the framework's language". The current text falls between these, claiming the strong form without doing the work.

**Cross-verified**: Logic-checker L-M3 flags the same issue from the proof-correctness angle.

## Major findings

### N-M1. The novelty differentiation from the precursor scrna-coarsening paper is implicit, should be explicit

**Location**: Introduction lines 49 to 55; Background line 65 to 69.

**Quoted text** (introduction): "ST is a strict generalization in that the candidate set has non-trivial structure (multiple cell types per spot) rather than being a single bit (zero vs. nonzero count)."

**Problem**: This sentence does the work but is buried in a parenthetical. For a reader new to the series, the novelty of *this* paper relative to the scrna-coarsening paper deserves a paragraph, not a clause. The "strict generalization" framing is a real claim: the binary candidate set (scrna case) is the $K=2$ degenerate ST case. Conversely, the technical apparatus differs (rank conditions on a structured composition matrix vs. an extrapolation condition on a dropout function shape), so the novelty is not "applying the same theorem in a new domain" but "developing a different identifiability characterization within the same coarsening framework". This deserves clear positioning.

**Suggestion**: Add one paragraph after the bridge subsection of the introduction, explicitly contrasting: "Relative to the scRNA-seq coarsening setup of Towell (2026), the ST setting has [richer candidate-set structure, requiring rank-condition rather than spike-in-extrapolation analysis, but recovering the same cell-total consistency mechanism]. The two papers share the C1, C2, C3 apparatus but require different identifiability characterizations." This both differentiates and unifies, which is what a series paper needs.

### N-M2. Tangram's "few hundred markers" claim is reframed as a corollary; the strength of this contribution is venue-dependent

**Location**: Methodology section, "Recovery of Tangram's empirical observation" (sections/methodology.tex lines 68 to 90); Conclusion line 13 to 14.

**Quoted text** (conclusion): "a first-order bias bound under marker-gene undercoverage that recovers Tangram's empirical 'a few hundred markers' rule as a corollary."

**Problem**: The framing "recovers as a corollary" is venue-dependent in strength. For RECOMB and AISTATS this is a strong sell ("here is theory that explains an empirical observation"). For Genome Biology and Bioinformatics this is weaker because biology audiences want to see the new prediction the theory makes, not the recovery of a known one. The current text says (validation.tex line 87 to 90) "we do not derive this absolute number analytically, but its scaling with $K$ matches the rank-condition intuition", which is more honest but undercuts the "recovers as a corollary" framing.

Two paths: (a) for the bio venues, demote "recovers Tangram's observation" to a methodology remark and lead with the novel prediction (the framework predicts that marker-set size needed scales linearly with $K$, which has not been characterized previously; this is testable across datasets); (b) keep current framing for conference venues (RECOMB, AISTATS).

**Suggestion**: Move the Tangram-recovery framing to a single paragraph in the discussion (where it belongs as a sanity check against existing data), and lead the methodology section with the novel claim: "the bias bound predicts marker-set size scales as $K / \sigma_{\min}(M)$, with sharp degradation when $\sigma_{\min}(M)$ approaches noise scale."

### N-M3. The framework-across-domains paragraph is good positioning but reads as series-paper advertising

**Location**: Discussion lines 73 to 90; Conclusion lines 27 to 34.

**Quoted text** (discussion): "ST deconvolution is one application of a portable apparatus. The same masked-data conditions ground a series of companion papers in distinct domains..."

**Problem**: The four sibling papers (dp, weaksup, phenotype, scrna) are all cited as "Manuscript in preparation" (refs.bib). Citing in-preparation papers four times in a single paper, across discussion and conclusion, reads as series advertising rather than substantive cross-reference. The right move is to cite the published precursor (scrna-coarsening, when posted) and the foundational masked-data paper, and reduce the others to a single mention ("companion papers extend the framework to differential privacy, weak supervision, and EHR phenotyping").

**Suggestion**: Consolidate the four sibling-paper mentions to a single sentence in the conclusion. The discussion's framework-across-domains subsection should focus on what the framework predicts in the ST domain that goes beyond existing methods, not on the existence of other domain papers.

## Minor findings

### N-min1. The framework's "diagnostic" framing is novel but the actual diagnostic procedure is not packaged for use

**Location**: Throughout; especially introduction, intro contributions, and discussion.

**Problem**: The paper repeatedly says practitioners can use the rank condition "as a diagnostic" before applying a deconvolution method. But the paper does not give the diagnostic as a procedure: a numbered set of steps a practitioner would follow on their data. Without that, the framework's practical contribution is at the level of "be aware that rank matters", not at the level of "here is what to compute". For the bio venues, a half-page Algorithm or Checklist would substantially strengthen the contribution.

**Suggestion**: Add a small "Algorithm 1: Rank-condition diagnostic" pseudocode block in the methodology section: inputs (spot composition matrix $P$, optional marker panel $\mathcal M$, optional singleton augmentation), output (full-rank yes/no, $\sigma_{\min}$, recommended augmentation strategy). This converts the framework from descriptive theory to prescriptive tool.

### N-min2. The "single-cell-resolution platforms restore identifiability" rephrasing of "singletons restore identifiability" is genuinely useful

**Location**: Section 4.1 (sections/identifiability.tex lines 37 to 44).

**Comment**: This is the paper's best soundbite: the formal reliability statement about singletons becomes the intuitive ST statement about single-cell platforms. The paper could lead with this in the introduction; currently it appears mid-Theorem-1 sketch.

### N-min3. Relation to GraphST is asserted (intro cites it) but not analyzed

**Location**: refs.bib has GraphST (zhang2023spatially) and discussion line 45 cites it as the "joint inference is a richer problem" reference.

**Problem**: GraphST is a graph-based spatially informed deconvolution method that does joint inference. The framework, as presented, does not subsume it. Acknowledging this explicitly (rather than relegating to a single Discussion sentence) would strengthen the limits-of-framework framing.

## Differentiation vs. external literature

The paper's central novelty, ST deconvolution as a coarsening problem, does not appear to be anticipated by the cited literature. The closest prior work is:

- **Heitjan-Rubin 1991**: the foundational coarsening framework being ported, not applied to ST.
- **Tsiatis 2006 (Semiparametric Theory and Missing Data)**: cited in refs.bib but not used in the paper; this is a strong reference for the general framework. Worth one citation in the background section, since CAR/MAR/coarsening is the central conceptual move.
- **Li 2023 benchmarking**: cited; empirical, not identifiability-theoretic.
- **Cell2location, RCTD, etc.**: each treats identifiability informally; none does what this paper does.

I find no prior work treating ST deconvolution as a coarsening problem. The contribution is novel as positioned.

## Cross-verification with prior pass

The prior 2026-05-22 pass softened the introduction's overclaim about prior work characterizing identifiability (I1 in the state log). The current intro line 26 reads "no prior work characterizes deconvolution identifiability through the lens of masked-data coarsening conditions", which is the right framing.

The novelty findings here (N-C1, N-M1, N-M2, N-M3) are all fresh: they concern whether the central novelty is *demonstrated* (N-C1) and *positioned for the target audience* (N-M1, N-M2, N-M3), separate from the question of whether it is *literally novel* (yes).

## Severity calibration note

N-C1 is the central novelty problem: the paper has a genuinely novel positioning and a sound theorem set, but the bridging claim ("subsumes RCTD, Cell2location, Tangram as special cases") needs at least one fully worked example to be credible at the target venues. N-M1 through N-M3 are positioning fixes for venue strategy: same content, different framing for different audiences.
