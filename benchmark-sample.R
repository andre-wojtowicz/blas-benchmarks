runs = 10

f = function()
{
    set.seed (1)
    m <- 4000
    n <- 4000
    A <- matrix (runif (m*n),m,n)

    # Matrix multiply
    B <- crossprod(A)
}

cumulate = 0
for (i in 1:runs)
    cumulate = cumulate + as.numeric(system.time(f())[3])
    
cat(paste0(round(cumulate/runs, 3), "\n"))
