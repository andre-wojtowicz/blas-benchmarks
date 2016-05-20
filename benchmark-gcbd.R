# source: CRAN gcbd package

size = c(100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1250, 1500, 1750, 2000, 2500, 3000, 3500, 4000, 4500, 5000)
runs = c( 50,  50,  50,  50,  50,  50,  50,  50,  50,   30,   30,   30,   30,   20,   20,    5,    5,    5,    5,    5)
meanTrim = 0.1

results = data.frame(t1=numeric(), t2=numeric(), t3=numeric(), t4=numeric())

library(Matrix)

# functions

getMatrix <- function(N) {
    a <- rnorm(N*N)
    dim(a) <- c(N,N)
    invisible(gc())
    invisible(a)
}

matmultBenchmark <- function(N, n, trim=0.1) {
    a <- getMatrix(N)
    traw <- replicate(n, system.time(crossprod(a))[3])
    tmean <- mean(traw,trim=trim)
}


qrBenchmark <- function(N, n, trim=0.1) {
    a <- getMatrix(N)
    traw <- replicate(n, system.time(qr(a, LAPACK=TRUE))[3])
    tmean <- mean(traw,trim=trim)
}

svdBenchmark <- function(N, n, trim=0.1) {
    a <- getMatrix(N)
    traw <- replicate(n, system.time(svd(a))[3])
    tmean <- mean(traw,trim=trim)
}

luBenchmark <- function(N, n, trim=0.1) {
    a <- getMatrix(N)
    traw <- replicate(n, system.time(lu(a))[3])
    tmean <- mean(traw,trim=trim)
}


# Initialization

set.seed (1)

cat(paste0("Mean trim : ", meanTrim, "\n"))

for (i in 1:length(size))
{
    n = size[i]
    r = runs[i]
    
    cat(paste0("Size : ", n, "\n"))
    cat(paste0("Runs : ", r, "\n"))
    
    t1 = matmultBenchmark(n, r, meanTrim)
    cat(paste0("Matrix Multiply             : ", t1, "\n"))
    
    t2 = qrBenchmark(n, r, meanTrim)
    cat(paste0("QR Decomposition            : ", t2, "\n"))
    
    t3 = svdBenchmark(n, r, meanTrim)
    cat(paste0("Singular Value Deomposition : ", t3, "\n"))
    
    t4 = luBenchmark(n, r, meanTrim)
    cat(paste0("Triangular Decomposition    : ", t4, "\n"))
    
    results = rbind(results, data.frame(t1=t1, t2=t2, t3=t3, t4=t4))
}

colnames(results) = c("Matrix Multiply", "QR Decomposition", 
                      "Singular Value Deomposition", "Triangular Decomposition")

attr(results, "size") = size
attr(results, "runs") = runs
attr(results, "meanTrim") = meanTrim
saveRDS(results, paste0("test-gcbd-", ifelse(exists("blasLibName"), blasLibName, ""), ".rds"))
