# Expectation of maximum of two normal variables.

Assume, A and B are normally distributed random variables with mean equal to 0 and variance equal to 1, not necessarily independent (A, B ~ N(0,1)). Given E(A*B) = r, find E(max(A, B)).

If r = 1, A = B, and E(max(A, B)) = E(A) = 0.

If r = -1, A = - B and E(max(A, B)) = E(|A|) = sqrt(2 / pi).

It is quite obvious, that these are extreme values of E(max(A, B)), moreover it can be shown that E(max(A, B)) =  sqrt((1 - r) / pi).

But what if there are more than two correlated normal random variables? Thus, what is E(max(X_1,...X_n)) if covariance matrix of X_1,...X_n is known.

# Mean width.

Given a simplex in R^n compute it's average width. If n = 2, and, thus, simplex is a triangle, it's mean width is triangle's perimeter up to a coefficient $2 * \sqrt(2 * pi)$.

If n >= 3 no closed-form solution exists. Known method is called Sudakov's Theorem and states that

If rows of covariance matrix of X_1,..X_n represent coordinates of simplex' vertices it's mean width equals E(max(X_1,...X_n)) up to a coefficient depending on n.

The repository implements this method.

References:
