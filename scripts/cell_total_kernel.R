## cell_total_kernel.R
##
## Backs the corrected cell-total consistency theorem (thm:cell-total-st).
## The score equations at an interior MLE give P^T R = 0 and R U = 0 for the
## residual R = Xbar - P U^T. The (pre-correction) draft claimed this forces
## R = 0 per-entry whenever P, U have full column rank. That is FALSE: the
## operator Lambda: R -> (P^T R, R U) has kernel dimension (S-K)(J-K).
##
## Experiment #1: confirm kernel dimension == (S-K)(J-K), >0 when K<min(S,J).
## Experiment #2: per-entry vs aggregate residual when rank(Xbar) > K
##                (non-saturated) vs rank(Xbar) <= K (saturated).
##
## Run: Rscript scripts/cell_total_kernel.R
## Writes: results_cell_total.rds and prints a summary.

set.seed(20260603)

## ---------------------------------------------------------------------------
## Experiment 1: kernel dimension of Lambda: R -> (P^T R, R U)
## ---------------------------------------------------------------------------

kernel_dim <- function(S, K, J, seed = 1) {
  set.seed(seed)
  P <- matrix(rnorm(S * K), S, K)
  U <- matrix(rnorm(J * K), J, K)
  ## Build the matrix of Lambda acting on vec(R), R in R^{S x J}.
  rows <- vector("list", S * J)
  idx <- 1L
  for (r in seq_len(S)) for (c in seq_len(J)) {
    E <- matrix(0, S, J); E[r, c] <- 1
    rows[[idx]] <- c(as.vector(crossprod(P, E)),  # P^T E  (K x J)
                     as.vector(E %*% U))           # E U    (S x K)
    idx <- idx + 1L
  }
  Lmat <- do.call(cbind, rows)            # (KJ + SK) x (S J)
  (S * J) - qr(Lmat)$rank                 # nullity
}

exp1 <- function() {
  shapes <- list(c(2,1,2), c(3,1,3), c(4,2,3), c(5,2,4), c(3,3,3),
                 c(6,2,5), c(4,1,4))
  do.call(rbind, lapply(shapes, function(sh) {
    S <- sh[1]; K <- sh[2]; J <- sh[3]
    kd <- kernel_dim(S, K, J)
    data.frame(S = S, K = K, J = J, observed = kd,
               predicted = (S - K) * (J - K),
               match = kd == (S - K) * (J - K))
  }))
}

## ---------------------------------------------------------------------------
## Experiment 2: per-entry vs aggregate residual, saturated vs not
## ---------------------------------------------------------------------------
## Alternating least squares for the unregularized Poisson-mean factorization
## min || Xbar - P U^T ||_F^2 over P (rows on simplex relaxed to >=0) and U>=0.
## We compare:
##   - aggregate residual: max | P^T R | and | R U |  (theorem part a: ~0)
##   - per-entry residual: max | R |                   (theorem part b)
## under two truths: rank(Xbar_true) = K (saturated) and > K (non-saturated).

## Unconstrained alternating least squares (the interior-optimum object the
## theorem is about: no nonnegativity clipping, which would create boundary
## solutions that need not satisfy the interior score equations). At a
## stationary point the normal equations are exactly P^T R = 0 and R U = 0.
als_fit <- function(Xbar, K, iters = 20000, tol = 1e-14) {
  S <- nrow(Xbar); J <- ncol(Xbar)
  P <- matrix(runif(S * K), S, K)
  U <- matrix(runif(J * K), J, K)
  prev <- Inf
  for (it in seq_len(iters)) {
    U <- t(qr.solve(P, Xbar))            # least-squares, unconstrained
    P <- t(qr.solve(U, t(Xbar)))
    rss <- sum((Xbar - P %*% t(U))^2)
    if (abs(prev - rss) < tol) break
    prev <- rss
  }
  list(P = P, U = U, R = Xbar - P %*% t(U))
}

make_truth <- function(S, J, K, rank_target) {
  ## Build Xbar_true with controlled rank.
  Pt <- matrix(abs(rnorm(S * K)), S, K); Pt <- Pt / rowSums(Pt)
  Ut <- matrix(abs(rnorm(J * K)), J, K)
  Xb <- Pt %*% t(Ut)                       # rank <= K (saturated)
  if (rank_target > K) {
    ## add a rank-(rank_target-K) nonnegative perturbation to exceed K
    extra <- rank_target - K
    A <- matrix(abs(rnorm(S * extra)), S, extra)
    B <- matrix(abs(rnorm(J * extra)), J, extra)
    Xb <- Xb + 0.3 * A %*% t(B)
  }
  Xb
}

exp2 <- function() {
  S <- 8; J <- 10; K <- 3
  out <- lapply(c(K, K + 2), function(rt) {
    Xb <- make_truth(S, J, K, rt)
    rk <- qr(Xb)$rank
    fit <- als_fit(Xb, K)
    list(rank_target = rt, rank_Xbar = rk, saturated = (rk <= K),
         agg_PtR = max(abs(crossprod(fit$P, fit$R))),
         agg_RU  = max(abs(fit$R %*% fit$U)),
         per_entry_max = max(abs(fit$R)),
         per_entry_frob = sqrt(sum(fit$R^2)))
  })
  out
}

## ---------------------------------------------------------------------------
## Driver
## ---------------------------------------------------------------------------

cat("=== Experiment 1: kernel dim of R -> (P^T R, R U) ===\n")
e1 <- exp1()
print(e1, row.names = FALSE)
cat(sprintf("all match (S-K)(J-K): %s; kernel > 0 whenever K<min(S,J): %s\n",
            all(e1$match),
            all(e1$observed[e1$K < pmin(e1$S, e1$J)] > 0)))

cat("\n=== Experiment 2: per-entry vs aggregate residual ===\n")
e2 <- exp2()
for (d in e2) {
  cat(sprintf("  rank(Xbar)=%d (K=3, %s): aggregate |P^T R|=%.2e |R U|=%.2e ; per-entry max|R|=%.4f\n",
              d$rank_Xbar, if (d$saturated) "SATURATED" else "non-saturated",
              d$agg_PtR, d$agg_RU, d$per_entry_max))
}
cat("Expectation: aggregate ~0 in both; per-entry ~0 only in the saturated case.\n")

saveRDS(list(exp1 = e1, exp2 = e2, seed = 20260603), "results_cell_total.rds")
cat("\nSaved results_cell_total.rds\n")
