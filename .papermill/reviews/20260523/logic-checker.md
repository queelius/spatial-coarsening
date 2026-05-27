# Logic Checker Report

## Scope

Proof correctness, logical chain integrity, claim support. Focus on the three theorems (rank, cell-total, marker-bias) and the chain from background to ST translation.

## Critical findings

### L-C1. Translation of C2 condition is logically vacuous as stated

**Location**: Table 1 (sections/translation.tex line 47), C2 row.

**Quoted text**: "Composition $\bm{p}_s$ does not depend on which cell of type $k$ is present"

**Problem**: This is the table's gloss of the C2 condition (symmetric masking). In the underlying reliability framework C2 says: given a system fails at time $t$ with failed component $k$, the candidate set $c$ has the same conditional probability whether the actual failed component is $j$ or $k$ for any pair in $c$. In the ST setting, the candidate set is the composition vector $\bm p_s$, which is observed and deterministic, not a random function of which cell of type $k$ is realized. The translation conflates two distinct things: (a) whether $\bm p_s$ depends on within-type cell identity (trivially true for any ST experiment because cells of the same type are indistinguishable in the model) and (b) whether the spot-membership mechanism is symmetric across types. Statement (a) is automatic. Statement (b) is the substantive analogue of C2 and is not what the table says.

**Suggestion**: Replace with "the spot-assignment mechanism is symmetric across cell types of the same kind: conditional on the spot's composition $\bm p_s$, the probability of observing $\bm p_s$ does not depend on which cell-type index produced any individual cell." Then state explicitly what C2 rules out in ST: nothing currently does, because $\bm p_s$ is treated as observed; this is worth flagging as a place where the framework's full power is latent.

**Cross-verified**: This is a logic issue that overlaps with the prose-auditor's territory on the translation table. Independent check below.

### L-C2. The cell-total consistency theorem statement is not quite right under the NMF estimator used in validation

**Location**: Theorem 3 (sections/identifiability.tex lines 65 to 76) and corresponding NMF validation.

**Quoted text from theorem**: "Let $(\hat{\bm{\mu}}_j, \hat{P})$ be an MLE in which both $\bm{\mu}_j$ and $\bm{p}_s$ are unconstrained at the optimum (no prior, no penalty, no spatial-smoothness regularization that ties the two together). Then for each spot $s$, $\sum_k \hat{P}_{sk} \hat{\mu}_{j,k} = \bar{X}_{sj} + o_p(1)$."

**Problem**: The NMF validation (sections/validation.tex, "Noiseless limit" paragraph) reports "joint NMF estimator reaches median $4.5 \times 10^{-4}$ over the same input, with occasional local optima driving the maximum to $\sim 10^{-1}$." The theorem as stated should hold to machine precision for any *first-order critical point* of an unconstrained Frobenius NMF (the multiplicative updates do enforce nonnegativity but they do not penalize). If the NMF reaches median $4.5\times 10^{-4}$ rather than machine precision, this indicates the iteration is not at a fixed point, not that the theorem fails. Either (a) the theorem should be qualified to "at a stationary point of the unconstrained objective," or (b) the validation should run the NMF to convergence (the script uses 500 iterations; this is not necessarily a stationary point for a $500 \times 5$ problem).

**Suggestion**: Add a one-sentence remark distinguishing theorem-statement (at MLE / stationary point) from numerical attainment by a specific algorithm (iterative methods may stop short). The text in validation.tex already softens this with "this is the price of the joint nonconvex problem and not a property of the theorem", which is good; the suggested edit is to make the theorem statement itself say "any stationary point of the unconstrained Frobenius loss" so the validation gap is unambiguously algorithmic, not theoretical.

**Cross-verified**: Methodology-auditor flags the same algorithmic gap independently below.

### L-C3. The "if and only if" in Theorem 1 (rank) is true only for the population OLS model and overclaims for the actual DGP

**Location**: Theorem 1 (sections/identifiability.tex lines 17 to 23), proof sketch lines 25 to 35.

**Quoted text**: "The cell-type-specific mean expression vector $\bm{\mu}_j$ is identifiable from spot-level data $\{X_{sj}\}_{s=1\ldots S}$ if and only if the spot-by-cell-type composition matrix $P$ has full column rank $K$."

**Problem**: The sketch argues identifiability through $\bm m_j = P\bm \mu_j$ which is the *mean* equation. But the actual DGP is Poisson sampling (validation.tex DGP paragraph: $X_{sj} \sim \mathrm{Poisson}(N_s \sum_k p_{s,k} \mu_{j,k})$). Identifiability of the parameter $\bm\mu_j$ from the joint distribution of $\{X_{sj}\}$ is stronger than identifiability from $\bm m_j$ alone, because the Poisson distribution determines its mean. So in this specific case the conclusions coincide, but the theorem as stated is for "spot-level data $\{X_{sj}\}$" while the proof uses only $\bm m_j$. The "only if" direction is correct (any two $\bm\mu_j, \bm\mu_j'$ giving the same mean give the same Poisson distribution), but the proof needs to say so.

A second issue: the theorem is silent on what $P$ is when only $\bm p_s$ is unknown. If $P$ is observed (e.g., from a reference panel), the statement is clean. If $P$ itself is being jointly inferred (as in NMF), the rank condition on $P$ is unobservable, and the theorem's conclusion does not apply directly to joint inference; the bias-bound theorem then bears the load.

**Suggestion**: Either (a) restate as "Under Poisson sampling with mean $N_s \sum_k p_{s,k}\mu_{j,k}$, and given known $P$, the parameter $\bm\mu_j$ is identifiable iff $P$ has full column rank", or (b) keep the existing statement but add a one-sentence justification in the sketch that identifiability of the Poisson parameter follows from identifiability of its mean.

**Cross-verified**: Methodology-auditor agrees the conditional-on-$P$ scope should be explicit.

## Major findings

### L-M1. The o_p(1) qualifier in Theorem 3 elides whether the rate is per-spot or per-(spot, gene)

**Location**: Theorem 3 statement (sections/identifiability.tex line 73).

**Quoted text**: "$\sum_k \hat{P}_{sk} \hat{\mu}_{j,k} = \bar{X}_{sj} + o_p(1)$"

**Problem**: The $o_p(1)$ is implicit in some growing index, but the theorem does not say which. Three natural candidates: $N_s \to \infty$ (per-spot count), $S \to \infty$ (number of spots), or $J \to \infty$ (number of genes). For the score-equation argument given in the sketch, the residual at an exact MLE is zero, not $o_p(1)$; the $o_p(1)$ presumably refers to finite-sample MLE convergence, which would be $O_p(1/\sqrt{N_s})$ or $O_p(1/\sqrt{S})$. The sibling scrna-coarsening paper (sections/identifiability.tex, theorem 3) gives the equivalent ZINB identity *exactly* at an interior MLE, without an $o_p$ term. The asymmetry between the two papers is unjustified.

**Suggestion**: Either (a) state $\sum_k \hat P_{sk}\hat\mu_{j,k} = \bar X_{sj}$ exactly at an interior MLE (matching scrna paper), then add a corollary about finite-sample stochastic error if needed, or (b) explicitly write "as $N_s \to \infty$" or "as $S \to \infty$" so the $o_p$ is anchored.

### L-M2. The "informed marker selection beats the iid $-0.5$ rate" claim is only partially supported by the theorem

**Location**: validation.tex marker-bias section, paragraph at lines 91 to 98.

**Quoted text**: "The empirical log--log slope is $-0.78$, steeper than the $-0.5$ predicted by the first-order Taylor bound under \emph{random} marker selection."

**Problem**: The first-order Taylor bound (Theorem 4 / eq.~\eqref{eq:bias-marker}) does not actually derive a $-0.5$ rate; it gives $\hat{\bm p}_s - \bm p_s^* = J_{p,M}\cdot \mathrm{vec}(\Delta M) + O_p(n^{-1/2}) + O(\|\Delta M\|^2)$. The $-0.5$ slope is a side-claim about how $\|\Delta M\|$ scales with $|\mathcal M|$ under random selection: $\|\Delta M\|/\sqrt{|\mathcal M|}$ is constant if entries are iid, so $\|\Delta M\| \propto \sqrt{|\mathcal M|}$, which yields a bias that grows with $\sqrt{|\mathcal M|}$, not one that decays. To get $-0.5$ as a *decay rate* on the bias with respect to $|\mathcal M|$, you need a different normalization, typically that the relevant projection magnitude scales as $1/\sqrt{|\mathcal M|}$ for a fixed signal-to-noise ratio. The text uses $-0.5$ without deriving it.

**Suggestion**: Either (a) derive the $-0.5$ baseline in one sentence (e.g., "if marker selection is uninformative, the per-spot projection variance scales as $\sigma^2/|\mathcal M|$, giving root-MSE $\propto |\mathcal M|^{-1/2}$"), or (b) drop the $-0.5$ as a baseline and just report the empirical $-0.78$ with a qualitative interpretation ("steeper than $|\mathcal M|^{-1/2}$, consistent with informed selection adding signal beyond what random selection would").

### L-M3. The "subsumes RCTD, Cell2location, Tangram as special cases" claim is not formally proven

**Location**: Discussion (sections/discussion.tex lines 6 to 28); also abstract and introduction.

**Problem**: The translation section gives a paragraph for each method describing it in the framework's language, but does not prove the equivalence. For RCTD ("ML specialization with parametric Poisson per-cell-type expression"), the claim is plausible but unproven. For Cell2location, the Bayesian prior is described as "one form of identifiability assumption on the candidate-set distribution" without explicitly mapping the prior's parameters to the C3 condition or showing that the posterior under the prior reduces to a C3-respecting likelihood. For Tangram, the framing as "singleton candidate sets via deep-learning alignment" is metaphor, not derivation: Tangram does not literally evaluate a likelihood with singleton candidate sets.

This is a major framing issue. The paper's central novelty claim ("subsumes... as special cases") needs at least one worked example to be credible.

**Suggestion**: For RCTD (the most amenable), add a half-page worked example in the translation section: write down RCTD's likelihood, identify where C1, C2, C3 enter, and identify the rank condition explicitly. For the others, soften "subsumes as special cases" to "shows how to express in the framework's language", which is honestly what the paper does. The first option is preferable for a methods venue.

## Minor findings

### L-min1. C1 condition's atlas-coverage interpretation has a subtle gap

**Location**: Table 1, C1 row (sections/translation.tex line 46).

**Quoted text**: "Reference atlas covers all cell types present in tissue (no out-of-atlas types)"

**Problem**: This is the practical condition. The strict mathematical condition would also need: the reference's mean expressions $\mu_{j,k}$ are consistent with the tissue's expressions for the same $k$, not just that the labels exist in both. Atlas-tissue distributional mismatch (a known issue, see e.g. Tasic 2018) is a kind of C1 violation in spirit but not in letter. A note in the discussion's "What the framework does not address" section would help.

### L-min2. The proof sketch for Theorem 3 uses $o_p(1)$ but the cited derivation in the proof body sets the residual to zero

**Location**: Proof sketch for Theorem 3 (sections/identifiability.tex lines 78 to 87).

**Quoted text**: "Together these force the spot-level mean residual to vanish at the optimum."

**Problem**: "Vanish at the optimum" = zero, but the theorem statement says $o_p(1)$. Internal inconsistency. See L-M1 for the resolution.

### L-min3. The "$\sigma_{\min}(M)^2$" bound in the Tangram-recovery paragraph is asserted without derivation

**Location**: Methodology (sections/methodology.tex line 78).

**Quoted text**: "through $\bm{H}_{pp}^{-1}$ the bias inflates by the inverse of $\sigma_{\min}(M)^2$"

**Problem**: True under the standard least-squares setup (Theorem 4 with squared loss) but not derived. One sentence connecting $\|\bm H_{pp}^{-1}\|$ to $\sigma_{\min}(M)^{-2}$ would close the loop.

## Cross-verification with prior pass

The prior 2026-05-22 review flagged C1 (theorem scope), C2 (IFT-based proof sketch), and C4 (sibling cross-references), all of which the current revision addresses. The current critical findings (L-C1 through L-C3) are *not* duplicates of the prior pass:
- L-C1 is a fresh translation-table issue, not in the prior log.
- L-C2 is a refinement of the prior C1 (the previous pass tightened scope but did not flag the algorithmic-vs-theoretical gap surfaced by the NMF residual mismatch).
- L-C3 is a fresh observation about the "iff" overclaiming on Poisson sampling.

## Severity calibration note

L-C1 and L-C2 are critical for the paper's correctness narrative but neither breaks the central claim; both have clean one-paragraph fixes. L-C3 is a stylistic theorem-statement fix. The framework's overall logical structure is sound: a working reader can recover the intended statement from context. The fixes are about *making the right statement easy to find*.
