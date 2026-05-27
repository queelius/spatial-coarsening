# Methodology Auditor Report

## Scope

Experimental design, statistical rigor, reproducibility of simulation and real-data validation.

## Critical findings

### M-C1. NMF "noiseless limit" residual disagrees with the theorem; cause is algorithmic but reporting conflates the two

**Location**: validation.tex, Noiseless-limit paragraph (lines 58 to 65). Corresponding script: scripts/run.R lines 70 to 88.

**Quoted text**: "The joint NMF estimator reaches median $4.5 \times 10^{-4}$ over the same input, with occasional local optima driving the maximum to $\sim 10^{-1}$; this is the price of the joint nonconvex problem and not a property of the theorem."

**Problem**: The script runs NMF for 500 iterations on a $500 \times 50$ matrix with $K=5$. The cited median $4.5\times 10^{-4}$ is the value the code happens to attain at iteration 500, not the value at a stationary point. The validation text acknowledges this is algorithmic, which is honest, but it omits the standard diagnostic that would resolve the question: did the iteration converge? Run-to-convergence (e.g., until $\|\nabla\|_F < 10^{-10}$, or for 50000 iterations on this size problem) should drive the median to machine precision. If it does not, the theorem's hypothesis (unconstrained MLE at a stationary point) is not what NMF achieves, and the validation is testing a different statement.

This matters because a careful reader will ask: when the paper applies Theorem 3 to Visium real data via NMF (validation.tex Real Visium section, Frobenius-relative residual $0.077$ for NMF $K=20$), is the gap from zero because (a) NMF did not converge, (b) noise floor at this $N_s$, (c) cell-type-substructure unmodeled at $K=20$, or (d) the theorem does not apply? The current text leaves this ambiguous.

**Suggestion**: Add one row to the noiseless-limit experiment: run NMF for many more iterations (or a second-order solver) until stationarity is reached, and report the residual at stationarity. If it is machine precision, the theorem is validated; if not, the script has a bug. Either outcome closes a real ambiguity. The text should then say which of (a)-(d) explains the real-data $0.077$.

**Cross-verified**: Logic-checker L-C2 flags the same theorem-vs-algorithm gap.

### M-C2. The "$1/\sqrt{N_s}$ Poisson scaling" claim has off-by-a-factor issues with reported numbers

**Location**: validation.tex, Noisy-regime paragraph (lines 67 to 71), and Visium real-data section (lines 154 to 167).

**Quoted text**: "$0.075$ at $N_s = 100$, $0.024$ at $N_s = 1{,}000$, and $0.0075$ at $N_s = 10{,}000$, consistent with the $1/\sqrt{N_s}$ Poisson scaling."

**Problem**: $0.075 / 0.024 = 3.13 \approx \sqrt{10}$, and $0.024 / 0.0075 = 3.20 \approx \sqrt{10}$. So the scaling checks. Good. But for the Visium real data: "per-entry median absolute residual is $\sim 5 \times 10^{-5}$, within the Poisson noise floor at this sequencing depth ($1/\sqrt{N_s} \approx 6 \times 10^{-3}$)." This compares an *absolute* residual on $\bar X = X/N$ (which has variance $\mu/N_s$ for Poisson, so SD $\sim \sqrt{\mu/N_s}$) to $1/\sqrt{N_s}$, dropping the $\sqrt{\mu}$ factor. For median $\bar X$ on the order of $1$ to $10$, the Poisson SD on $\bar X$ is $\sqrt{\mu}/\sqrt{N_s} \approx 0.01$ to $0.03$, putting the cited noise floor about $2\times$ to $5\times$ higher than $6\times 10^{-3}$. The argument's conclusion (residual is within Poisson floor) still stands, but the $6\times 10^{-3}$ number is dimensional analysis carried out incompletely.

**Suggestion**: Replace "$1/\sqrt{N_s} \approx 6 \times 10^{-3}$" with the per-entry standard deviation under Poisson with median mean $\mu$ in the data, namely $\sqrt{\mu}/\sqrt{N_s}$. Cite the value (one or two sentences).

## Major findings

### M-M1. No head-to-head with any deconvolution method; deferral framing is partly honest, partly hides the gap

**Location**: validation.tex, last paragraph "Scope of the empirical validation" (lines 204 to 218). Discussion (sections/discussion.tex lines 41 to 60).

**Quoted text**: "Head-to-head benchmarking of RCTD, Cell2location, and Tangram against one another on the synthetic and real Visium inputs is a complementary methodological study, deferred to the longer companion manuscript... performing that benchmark adds engineering effort (Python and PyTorch pipelines) but does not test the framework's claims, which are about conditions-on-inputs rather than method ranking on a fixed input."

**Problem**: The deferral is partly defensible (the framework's claims are indeed about inputs not methods) but the framing slides past a legitimate weakness: *the rank-condition diagnostic and bias bound are proposed as practitioner tools*, and a tool's value is best argued by showing it picks the right method on a real case. The current paper offers diagnostics but never demonstrates that a different diagnostic verdict would have changed which method one should use. At minimum, an RCTD run on the same synthetic Visium data (already at hand in R) would let the paper say "method X was identified as appropriate by the diagnostic, performed best on this case; method Y was flagged as inappropriate, performed worst", closing the loop. The state file explicitly notes RCTD is "R, easy" in the Tier 2 list.

This is not a Critical (the paper's theorems do not need the benchmark) but it is the most material weakness for a methods-venue submission. The state.md submission-strategy block flags it: "For Genome Biology, expand validation with at least one head-to-head against RCTD on the existing simulated Visium-scale data, even if Cell2location/Tangram are deferred." This recommendation is sound and should be implemented before Genome Biology submission.

**Suggestion**: Add one RCTD comparison on the synthetic Visium-scale data, in a single subsection of validation.tex (~half page). This converts the framework from "framework predicts conditions" to "framework predicts conditions and the conditions predict method ranking on this case", which is a much stronger pitch.

**Cross-verified**: This is a methodology-novelty boundary issue; the novelty assessor below confirms it is the central differentiator gap.

### M-M2. The real-data Visium "cell-total consistency" verification is not quite testing the theorem

**Location**: validation.tex, Real Visium subsection (lines 154 to 167).

**Quoted text**: "Across four estimators (hard cluster pseudobulk at $K = 7$ and $K = 10$, joint NMF at $K = 10$ and $K = 20$) the per-entry median absolute residual is $\sim 5 \times 10^{-5}$"

**Problem**: The theorem (Theorem 3) is about MLEs. Hard-cluster pseudobulk is not an MLE; it is a method-of-moments-style projection onto a cluster assignment. It will satisfy a cell-total identity by construction (each spot is in exactly one cluster, so its row's pseudobulk equals its own observed expression by definition), not because of the theorem. Reporting hard-cluster pseudobulk residuals as evidence for the theorem is a category error. NMF residuals are the relevant test; the hard-cluster numbers should be moved to "as expected by construction" or dropped.

The real test is the NMF residuals (0.108 at $K=10$, 0.077 at $K=20$). The text mentions these as Frobenius-relative, then offers an explanation involving Poisson noise and substructure, but does not connect the residual to the theorem's prediction. Theorem 3 says residual is exactly zero at an MLE; observed is 0.077; explanation needed.

**Suggestion**: Restructure as: "(a) hard-cluster pseudobulk: zero residual by construction, not a test of the theorem; (b) NMF $K=20$: 0.077 residual, of which $\approx X\%$ is the algorithmic gap from a true stationary point (cf. M-C1) and $\approx Y\%$ is the noise floor / substructure beyond $K=20$." Decomposing the residual is what a methodologist would want to see.

### M-M3. The "high-variance gene subset" preprocessing is not justified statistically

**Location**: validation.tex Real Visium section (line 144).

**Quoted text**: "We restrict to the top $2{,}000$ high-variance genes to focus on the cell-type-bearing signal"

**Problem**: This is standard practice in single-cell pipelines but it interacts with the theorems in a way that is not addressed. The rank condition (Theorem 1) and bias bound (Theorem 4) are stated for a particular gene set; subsetting genes changes both the implicit marker set and the conditioning of the relevant matrices. A reader can ask: does the framework predict that HVG selection helps the rank condition, and how? The paper doesn't say.

**Suggestion**: Add one sentence: "HVG selection is a deliberate marker-gene-set choice; the framework predicts that selecting genes with high cross-type expression range improves the conditioning of $M$ (smaller $\sigma_{\min}^{-1}$ in Theorem 4), consistent with the practical purpose of HVG selection." If this is what's happening, it is good evidence that the framework matches practice.

### M-M4. Real-data reference is in-dataset, not an external atlas

**Location**: validation.tex Real Visium "Cell-total consistency" paragraph; state.md note (lines 99 to 100).

**Problem**: The state.md notes "Reference is in-dataset (10x CellRanger graph clusters + K-means K=10) rather than external Allen Atlas, to keep the pipeline self-contained." This is reasonable for a scaffold pass but is a real limitation: the C1 condition (atlas covers all tissue cell types) is automatically satisfied when "atlas" = "clusters from the same data". The paper's narrative throughout (especially intro and discussion) emphasizes external-atlas-driven deconvolution as the workflow being unified; the real-data section does not actually exercise that workflow. The paper should either (a) acknowledge this explicitly in the Visium section, or (b) replace with a true external Allen-Brain Atlas run for the published version. Given the Tier 1 priority of the Visium validation and the venue strategy (Genome Biology primary), option (b) is the cleaner positioning.

**Suggestion**: At minimum, add a sentence: "We use in-dataset reference (clusters derived from the same expression matrix) for self-containment; the framework's C1 condition is trivially satisfied in this setup. An external-atlas test (Allen Brain Atlas) on the same Visium data is in preparation for the longer manuscript." This honest framing closes the gap without overclaiming.

## Minor findings

### M-min1. Random seed but no replicate variance reporting on the real-data section

**Location**: validation.tex Real Visium throughout.

**Problem**: The simulation section reports across replicates; the Visium section reports point values. A single Frobenius-relative residual of $0.077$ has uncertainty from the NMF initialization (the script in scripts/visium.R presumably uses a seed). Reporting $0.077$ as a point value, while reasonable for a single dataset, would benefit from "across $N$ NMF seeds, median residual $0.077 \pm \delta$".

### M-min2. The marker-bias simulation uses $K=5$, much smaller than the real-data $K=30$ scale

**Location**: validation.tex marker-bias subsection (line 84).

**Problem**: The marker-bias claim "few hundred markers suffice" is stated to scale with $K$, but the simulation uses $K=5$. At $K=5$, $|\mathcal M|=100$ is 20 markers per type, which is well above the regime Tangram observed. The simulation result ("median TV bias saturates near $0.010$ for $|\mathcal M| \geq 100$") happens at a regime not informative about the Tangram claim. Either run a $K=30$ replicate of the marker-bias experiment, or soften the "recovers Tangram's observation" claim.

### M-min3. Reproducibility: seed in run.R is 20260517, but scripts/visium.R seed not visible from the validation text

**Location**: scripts/visium.R (not read here, but the validation.tex implies it exists).

**Suggestion**: Mention the visium.R seed explicitly in validation.tex parenthetically, parallel to the sim.R "(seed 20260517)" mention.

## Cross-verification with prior pass

The prior pass addressed C3 (method-comparison gap) by reframing as a "framework predictions vs. method ranking" scope decision. This reframing is sound but it does not address the secondary issue M-M1 raises: even within the framework's own scope (predicting which conditions hold), a single RCTD comparison would convert a soft claim ("framework predicts X") into a strong claim ("framework predicts X and X holds on this real case for the method best-suited to the data"). The prior pass closed the *positioning* gap; M-M1 flags that the *content* gap remains and is the most material remaining weakness.

The Visium real-data section is new in the 2026-05-23 revision (not yet reviewed by the prior pass). All Real-Visium-related findings (M-M2, M-M3, M-M4, M-min1) are fresh.

## Severity calibration note

M-C1 and M-C2 are critical-to-fix-before-submission but neither invalidates results; both are 1-paragraph clarifications. M-M1 is the most consequential finding: not a defect in the present work, but the difference between "good theory paper" and "Genome-Biology-competitive methods paper". M-M2 is the most subtle finding (hard-cluster pseudobulk does not test the theorem). M-M4 is an honest-positioning fix that costs nothing.
