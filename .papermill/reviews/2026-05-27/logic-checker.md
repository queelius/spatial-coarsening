# Logic Checker Report (2026-05-27)

## Scope

Verify the rigor of (a) the new RCTD worked-example derivation
(`sections/translation.tex` lines 65 to 135), (b) the tightened
`thm:cell-total-st` proof sketch (`sections/identifiability.tex` lines
99 to 136), and (c) the self-contained `thm:rank` proof now in
`sections/identifiability.tex` lines 28 to 51. Findings from the
2026-05-23 round (L-C1, L-C2, L-C3, L-M1, L-M2, L-M3, L-min1, L-min2,
L-min3) are not re-litigated where the current text addresses them.

## Critical findings

None at the level that would block submission.

## Major findings

### L-M1 (new). The `thm:cell-total-st` proof sketch has a subtle gap on the bilinear identifiability step

**Location**: `sections/identifiability.tex` lines 117 to 136.

**Quoted text**: "both score equations imply $\hat P^\top R = 0$ and $R
\hat U = 0$ on the active support. When both $\hat P$ and $\hat U$
have full column rank on their respective active supports (the
conditions of \cref{thm:rank} applied to the joint estimator), the
only common-kernel solution is $R = 0$ on the active support, giving
\eqref{eq:cell-total-st} exactly at any interior MLE."

**Problem**: The implication $\hat P^\top R = 0$ and $R \hat U = 0$
implies $R = 0$ when $\hat P$ has full column rank and $\hat U$ has
full row rank (since $\hat U \in \R^{J \times K}$ with $J \gg K$, full
column rank gives a right inverse only after combining with the row
condition). The sketch correctly invokes \cref{thm:rank} on both
factors but does not state which side gives the kernel collapse. The
clean statement is: $\hat P^\top R = 0$ pins $R$ to the orthogonal
complement of the column space of $\hat P$ in $\R^S$; $R \hat U = 0$
pins $R$ to the left-orthogonal complement of $\hat U$ in $\R^J$. When
$\hat P$ has full column rank $K$ and $\hat U$ has full column rank
$K$, both kernels are nontrivial (codimension $K$ in $\R^S$ and
$\R^J$). The conclusion $R = 0$ requires a further argument: that the
intersection of these two subspace conditions on the matrix $R \in
\R^{S \times J}$ is the zero matrix. This follows because $R$
satisfies $R = (I - \hat P \hat P^+) R (I - \hat U \hat U^+) = 0$
exactly when the score equations hold for *all* $(s,k)$ and $(j,k)$
pairs simultaneously, which they do at an interior MLE. The current
text glosses this step.

**Suggestion**: Replace the final sentence of the sketch with: "The
two score conditions read $R = (I_S - \hat P(\hat P^\top \hat P)^{-1}
\hat P^\top) R$ (row condition) and $R = R(I_K - \hat U(\hat U^\top
\hat U)^{-1} \hat U^\top)^\top$ (column condition); since $\hat P$ has
full column rank $K$ and $\hat U$ has full column rank $K$, the unique
$R$ satisfying both is the zero matrix on the active support."

This is a one-sentence fix; the result holds, the rigor of the path
needs one line of clarification. The sibling scrna-coarsening proof
(reachable in `~/github/papers/scrna-coarsening/sections/appendix.tex`
lines 224 to 331) uses single-variable score equations and is
correspondingly cleaner; the bilinear case here genuinely needs the
extra sentence.

### L-M2 (new). The RCTD worked example asserts that "RCTD inherits identifiability" but does not specify under which of its two operating regimes

**Location**: `sections/translation.tex` lines 101 to 109.

**Quoted text**: "Under all three [C1, C2, C3], the Poisson likelihood
in \eqref{eq:rctd-likelihood} is the ignorable-coarsening likelihood
of the framework... RCTD inherits identifiability when the
spot-by-cell-type composition matrix $P$ has full column rank $K$"

**Problem**: The text states that RCTD fits $\hat{\bm p}_s$ given
fixed $\hat\mu_{j,k}$ (line 82). In that regime, the rank condition
operative is $\sigma_{\min}(\mu)$ (per-spot identifiability of $\bm
p_s$), not $\sigma_{\min}(P)$ (joint $\mu$ identifiability). The
worked example correctly identifies which theorems apply (rank theorem
on $P$, cell-total on the joint MLE, bias-bound on the per-spot fit)
but the rank condition cited at line 107 is the one that governs
joint $\mu$ recovery, which RCTD does not perform. This is exactly the
distinction the validation section's RCTD comparison
(`sections/validation.tex` lines 172 to 205) makes explicitly: per-spot
$\bm p_s$ recovery is governed by $\sigma_{\min}(\mu)$, joint $\mu$
recovery by $\sigma_{\min}(P)$. The translation section is one step
behind that distinction.

**Suggestion**: After "RCTD inherits identifiability when the
spot-by-cell-type composition matrix $P$ has full column rank $K$",
add a parenthetical clarifying that this rank condition governs the
joint-$\mu$ identifiability that RCTD does not exercise (since it
takes $\hat\mu_{j,k}$ as fixed); the per-spot $\bm p_s$ identifiability
RCTD does exercise is governed by $\sigma_{\min}(\mu) > 0$, which is
the bias-bound regime of \cref{thm:bias-marker}. This is then
cross-consistent with the validation results and removes a small but
real conceptual seam.

## Minor findings

### L-min1 (new). `thm:rank` self-contained proof is correct but the necessary direction needs a positivity caveat

**Location**: `sections/identifiability.tex` lines 35 to 42.

**Quoted text**: "Suppose $P$ has column rank less than $K$, so there
exists $\bm{v} \neq \bm{0}$ with $P\bm{v} = \bm{0}$. For any candidate
parameter $\bm{\mu}_j$, the perturbed $\bm{\mu}_j' = \bm{\mu}_j +
\bm{v}$ (chosen so $\bm{\mu}_j'$ remains in $\R_{\geq 0}^K$, possible
whenever $\bm{\mu}_j$ has all positive entries) satisfies $P\bm{\mu}_j'
= P\bm{\mu}_j = \bm{m}_j$."

**Problem**: The proof restricts to $\bm{\mu}_j$ with all positive
entries to keep $\bm{\mu}_j'$ in the nonnegative orthant. This is a
fine restriction; the standard reading is that nonidentifiability fails
generically, not at every parameter. One sentence acknowledging
"identifiability fails on an open subset of $\R_{> 0}^K$" rather than
"is not identifiable" full stop would be tighter.

**Suggestion**: Replace "$\bm{\mu}_j$ is not identifiable" at line 42
with "$\bm{\mu}_j$ is not identifiable on the open subset where the
perturbation remains nonnegative; on the boundary (some $\mu_{j,k} =
0$) the perturbation may exit the parameter space and the failure is
partial". One sentence; non-load-bearing for the result.

### L-min2 (new). The Remark on extensions to dropout cites C2 violation but the rank theorem proof was for the no-dropout case

**Location**: `sections/identifiability.tex` lines 53 to 69 (the
`\begin{remark}[Extensions]` block).

**Comment**: Item (iii) of the remark says cell-type-dependent dropout
"violates condition C2... and is the regime treated by
\cite{towell2026mdrelax}; the rank condition is no longer sufficient
and identifiability degrades quantitatively in the gap between the
maximum and minimum $\pi_k$." This is a useful framing but elides the
specific result from `towell2026mdrelax` being invoked. For a reader
who consults that paper, the connection to be made should be a
specific lemma or proposition number. Without it, the citation reads
as gesture rather than reference. A pointer such as "see Proposition X
of \cite{towell2026mdrelax}" would close the loop.

## Cross-verification status

- The 2026-05-23 L-C1 (translation C2 row vacuous) is fixed: the
  current text (translation.tex lines 47 to 48) describes the
  spot-assignment symmetry concretely as a property of tissue geometry
  and protocol rather than of within-type cell identity.
- The 2026-05-23 L-C2 (NMF-vs-theorem ambiguity) is addressed by the
  validation text's Noiseless-limit paragraph and the convergence trace.
- The 2026-05-23 L-C3 (Poisson iff) is addressed by the explicit
  Poisson-sampling hypothesis in `thm:rank` and the mean-equivalence
  argument in the proof.
- The 2026-05-23 L-M3 (subsumes-as-special-case unproven) is
  substantially addressed by the new RCTD worked-example subsection;
  the worked example does the work the prior round flagged was
  missing. The remaining seam (L-M2 above) is small.

## Severity calibration note

The two major findings (L-M1, L-M2) are one-sentence text fixes that
improve precision of existing proofs and worked examples but do not
change any conclusion. The minor findings are polish.
