# source: https://gist.github.com/andrie/24c9672f1ea39af89c66#file-rro-mkl-benchmark-r

# Initialization

set.seed (1)
m <- 10000
n <-  5000
A <- matrix (runif (m*n),m,n)

# Matrix multiply
system.time (B <- crossprod(A))

# Cholesky Factorization
system.time (C <- chol(B))

# Singular Value Deomposition
m <- 10000
n <- 2000
A <- matrix (runif (m*n),m,n)
system.time (S <- svd (A,nu=0,nv=0))

# Principal Components Analysis
m <- 10000
n <- 2000
A <- matrix (runif (m*n),m,n)
system.time (P <- prcomp(A))

# Linear Discriminant Analysis
library('MASS')
g <- 5
k <- round (m/2)
A <- data.frame (A, fac=sample (LETTERS[1:g],m,replace=TRUE))
train <- sample(1:m, k)
system.time (L <- lda(fac ~., data=A, prior=rep(1,g)/g, subset=train))
