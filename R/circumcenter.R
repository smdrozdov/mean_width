# Computes circumcenter of a given simplex.
# Args:
#   A: matrix (n + 1) by n, where n is space dimension.
Circumcenter <- function(A){
  assert_that(dim(A)[1] - dim(A)[2] == 1)
  B <- sweep(A[-1,], 2, A[1,])
  C <- (rowSums(A[-1,] ^ 2) - sum(A[1,] ^ 2)) / 2
  res <- solve(B, C)
  return(res)
}

# Test circumcenter computation.
TestCircumcenter <- function(){
  A <- matrix(nrow = 4, ncol = 3)
  A[1,] <- c(0,0,0)
  A[2,] <- c(1,0,0)
  A[3,] <- c(0,1,0)
  A[4,] <- c(0,0,1)
  center <- Circumcenter(A)
  assert_that(sum((center - c(0.5, 0.5, 0.5)) ^ 2) < 0.00000000001)
}
