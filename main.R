#install.packages("microbenchmark")
library(microbenchmark)

A <- matrix(1, nrow = 400, ncol = 300)
B <- matrix(1, nrow = 300, ncol = 30)
C <- matrix(1, nrow = 30, ncol = 500)
D <- matrix(1, nrow = 500, ncol = 400)

res <- microbenchmark(A %*% B %*% C %*% D,
                      ((A %*% B) %*% C) %*% D,
                      (A %*% (B %*% C)) %*% D,
                      (A %*% B) %*% (C %*% D),
                      A %*% (B %*% (C %*% D)),
                      A %*% ((B %*% C) %*% D))
options(microbenchmark.unit="relative")
print("With microbenchmark we compute each expression 100 times and collect the time each evaluation takes.")
print(res, signif = 3, order = "mean")
plot(res)

m <- function(data) {
  structure (data,
             nrow = nrow(data),
             ncol = ncol(data),
             class = c("matrix_expr", class(data)))
}

matrix_mult <- function(A,B) {
  structure(list(left = A, right = B),
            nrow = nrow(A),
            ncol = ncol(B),
            class = c("matrix_mult", "matrix_expr"))
}

`*.matrix_expr` <- function(A, B) { matrix_mult(A, B)
}
m(A) * m(B) * m(C) * m(D)
