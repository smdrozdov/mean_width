# Mean width.

Given a simplex in R^n compute it's average width. If n = 2, and, thus, simplex is a triangle, it's mean width is triangle's perimeter up to a coefficient $2 * \sqrt(2 * pi)$.

If n >= 3 this average width becomes very difficult to compute. Known method uses Sudakov's Theorem.

This repository implements this method.

References:
