# source: https://gist.github.com/andrie/24c9672f1ea39af89c66#file-rro-mkl-benchmark-r

runs = 10
results = data.frame(name=character(), time=numeric())

cat(c("Runs                          :", runs, "\n"))

# Initialization

set.seed (1)
m <- 10000
n <-  5000
A <- matrix (runif (m*n),m,n)

cat("Matrix Multiply               : ")
cumulate = 0
for (i in 1:runs)
    cumulate = cumulate + as.numeric(system.time (B <- crossprod(A))[3])

results = rbind(results, data.frame(name="Matrix Multiply", 
                                    time=cumulate/runs))
cat(c(cumulate/runs, "\n"))

cat("Cholesky Factorization        : ")
cumulate = 0
for (i in 1:runs)
    cumulate = cumulate + as.numeric(system.time (C <- chol(B))[3])

results = rbind(results, data.frame(name="Cholesky Factorization", 
                                    time=cumulate/runs))
cat(c(cumulate/runs, "\n"))

cat("Singular Value Deomposition   : ")
m <- 10000
n <- 2000
A <- matrix (runif (m*n),m,n)

cumulate = 0
for (i in 1:runs)
    cumulate = cumulate + as.numeric(system.time (S <- svd (A,nu=0,nv=0))[3])

results = rbind(results, data.frame(name="Singular Value Deomposition", 
                                    time=cumulate/runs))
cat(c(cumulate/runs, "\n"))

cat("Principal Components Analysis : ")
m <- 10000
n <- 2000
A <- matrix (runif (m*n),m,n)

cumulate = 0
for (i in 1:runs)
    cumulate = cumulate + as.numeric(system.time (P <- prcomp(A))[3])

results = rbind(results, data.frame(name="Principal Components Analysis", 
                                    time=cumulate/runs))
cat(c(cumulate/runs, "\n"))

cat("Linear Discriminant Analysis  : ")
library('MASS')
g <- 5
k <- round (m/2)
A <- data.frame (A, fac=sample (LETTERS[1:g],m,replace=TRUE))
train <- sample(1:m, k)

cumulate = 0
for (i in 1:runs)
    cumulate = cumulate + as.numeric(system.time (L <- lda(fac ~., data=A, prior=rep(1,g)/g, subset=train))[3])

results = rbind(results, data.frame(name="Linear Discriminant Analysis", 
                                    time=cumulate/runs))
cat(c(cumulate/runs, "\n"))

attr(results, "runs") = runs
saveRDS(results, paste0("test-revolution-", ifelse(exists("blasLibName"), blasLibName, ""), ".rds"))
