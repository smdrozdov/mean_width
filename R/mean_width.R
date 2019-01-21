# TODO(smdrozdov): Compute V_2, average R2 projection of simplex. It requires convex hull computation,
#                  which is O(d * log d). First interesting case is 4-simplex with 5
#                  vertices, so computing convex hull of pentagon.
# Returns true if points lie on the unit sphere.
# Args:
#   A: matrix, not necessarily representing simplex.
IsInscribed <- function(A){
  m <- dim(A)[1]
  n <- dim(A)[2]
  for (i in 1:m){
    if (abs(sum(A[i, ] ^ 2) - 1) > 0.0000001) {
      return(FALSE)
    }
  }
  return(TRUE)
}

# Returns pairwise distance between simplex vertices.
# Args:
#   A: matrix n by n.
ComputeEdges <- function(A){
  # Compute edges.
  assert_that(dim(A)[1] == dim(A)[2])
  dimension <- dim(A)[1]
  D <- matrix(nrow = dimension, ncol = dimension)
  for (i in 1:dimension){
    for (j in 1:dimension){
      side <- sqrt(sum((A[i, ] - A[j,]) ^ 2))
      D[i, j] <- side
    }
  }
  return(D)
}

# Computes mean width of n-point simplex in R^n.
# Important: should only be applied to simplices inscribed in unit sphere.
# TODO(smdrozdov): Divide by the factor.
# Args:
#   A: inscribed simplex.
#   sample.size: amount of Normally Distributed random values used in computation.
MeanWidthInscribed <- function(A, sample.size){
  assert_that(IsInscribed(A))
  assert_that(dim(A)[1] == dim(A)[2])

  dimension <- dim(A)[1]
  l <- vector(mode = "list", length = dimension)
  # TODO(smdrozdov): generate set only once per session.
  for (i in 1:dimension){
    l[[i]] <- rnorm(sample.size, 0, 1)
  }

  image <- matrix(ncol = sample.size, nrow = dimension)
  for (i in 1:dimension){
    image[i,] <- l[[1]] * A[i, 1];
    for (j in 2:dimension){
      image[i,] <- image[i,] + l[[j]] * A[i, j];
    }
  }

  reality <- mean(colMaxs(image))
  return(reality)
}

# Computes mean width of an arbitrary simplex.
# Args:
#   A: arbitrary simplex.
#   sample.size: amount of Normally Distributed random values used in computation.
MeanWidth <- function(A, sample.size){
  dimension <- dim(A)[1]
  circumcenter <- Circumcenter(A)

  for (i in 1:dimension){
    A[i,] <- A[i,] - circumcenter
  }
  radius <- sqrt(sum(A[1, ] ^ 2))
  A <- A * (1 / radius)
  A <- cbind(A, numeric(dimension))
  mean.width.normalized <- MeanWidthInscribed(A, sample.size)
  mean.width <- mean.width.normalized * radius
  return(mean.width)
}

# TODO(smdrozdov): Find out real constant here. Compute for diameter of S^n.
Factor <- function(dimension){
  return(2 * sqrt(2 * pi))
}

TestAll <- function(){
  A <- rbind(c(1,0,0),c(0,0,1),c(0,-1,0))
  assert_that(IsInscribed(A))
  B <- rbind(c(1,0,0),c(0,0,1),c(0,1.1,0))
  assert_that(!IsInscribed(B))

  A <- matrix(nrow = 3,
              ncol = 3,
              byrow = TRUE)

  # Generate.
  for (i in 1:3){
    for (j in 1:3){
      A[i, j] <- runif(1, -1, 1)
    }
  }

  # Normalize to S^(n-1).
  for (i in 1:3){
    n <- sqrt(sum(A[i, ] ^ 2))
    for (j in 1:3){
      A[i, j] <- A[i, j] / n
    }
  }

  mean.width <- MeanWidthInscribed(A, 1000000)
  e <- ComputeEdges(A)
  perimeter <- e[1,2] + e[1,3] + e[2,3]
  assert_that(abs(perimeter - mean.width * Factor(3)) < 0.1)

  A <- rbind(c(0,0),c(1,0),c(0,1))
  mean.width <- MeanWidth(A, 1000000)
  assert_that(abs((2 + sqrt(2)) - mean.width * Factor(2)) < 0.1)

  A <- rbind(c(0,0,1),
             c(1,0,0),
             c(0,2,0),
             c(-1,-1,0))
  assert_that(MeanWidth(A, 1000000) > 0)
}

