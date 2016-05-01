library(rbenchmark)

f = function()
{
set.seed (1)
m <- 1000
n <- 500
A <- matrix (runif (m*n),m,n)

# Matrix multiply
B <- crossprod(A)
}

benchmark(f(), replications=100)

