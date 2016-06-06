# BLAS libraries benchmarks
Andrzej Wójtowicz  

Document generation date: 2016-06-06 15:01:42



## Table of Contents

 1. [Configuration](#configuration)
 2. [Results per host](#results-per-host)
    * [Intel Core i7-4790K + MSI GeForce GTX 980 Ti Lightning](#intel-core-i7-4790k--msi-geforce-gtx-980-ti)
    * [Intel Core i5-4590 + NVIDIA GeForce GT 430](#intel-core-i5-4590--nvidia-geforce-gt-430)
    * [Intel Core i5-4590 + NVIDIA GeForce GTX 750 Ti](#intel-core-i5-4590--nvidia-geforce-gtx-750-ti)
    * [Intel Core i5-3570](#intel-core-i5-3570)
    * [Intel Core i3-2120](#intel-core-i3-2120)
    * [Intel Core i3-3120M](#intel-core-i3-3120m)
    * [Intel Core i5-3317U + NVIDIA GeForce GT 630M](#intel-core-i5-3317u--nvidia-geforce-gt-630m)
    * [Intel Pentium Dual-Core E5300](#intel-pentium-dual-core-e5300)
 3. [Results per library](#results-per-library)
    * [Netlib](#netlib)
    * [Atlas (st)](#atlas-st)
    * [OpenBLAS](#openblas)
    * [Atlas (mt)](#atlas-mt)
    * [GotoBLAS2](#gotoblas2)
    * [MKL](#mkl)
    * [BLIS](#blis)
    * [cuBLAS](#cublas)
 
***

## Configuration

**R software**: [Microsoft R Open](https://mran.microsoft.com/open/) (3.2.4)

**Libraries**:

|CPU (single-threaded)|CPU (multi-threaded)|GPU|
|---|---|---|
|[Netlib](http://www.netlib.org/) (debian package, blas 1.2.20110419, lapack 3.5.0)|[OpenBLAS](http://www.openblas.net/) (debian package, 0.2.12)|[NVIDIA cuBLAS](https://developer.nvidia.com/cublas) (NVBLAS 6.5 + Intel MKL)|
|[ATLAS](http://math-atlas.sourceforge.net/) (debian package, 3.10.2)|[ATLAS](http://math-atlas.sourceforge.net/) (dev branch, 3.11.38)|   |
|   |[GotoBLAS2](https://prs.ism.ac.jp/~nakama/SurviveGotoBLAS2/) (Survive fork, 3.141)|   |
|   |[Intel MKL](https://mran.microsoft.com/download/) (part of RevoMath package, 3.2.4)|   |
|   |[BLIS](https://github.com/flame/blis) (dev branch, 0.2.0+/17.05.2016)|   |

**Hosts**:

|No.|CPU|GPU|
|---|---|---|
|1.|[Intel Core i7-4790K](http://ark.intel.com/products/80807/Intel-Core-i7-4790K-Processor-8M-Cache-up-to-4_40-GHz)|[MSI GeForce GTX 980 Ti Lightning](https://us.msi.com/Graphics-card/GTX-980-Ti-LIGHTNING.html#hero-specification)|
|2.|[Intel Core i5-4590](http://ark.intel.com/products/80815/Intel-Core-i5-4590-Processor-6M-Cache-up-to-3_70-GHz)|[NVIDIA GeForce GT 430](http://www.geforce.com/hardware/desktop-gpus/geforce-gt-430/specifications)|
|3.|[Intel Core i5-4590](http://ark.intel.com/products/80815/Intel-Core-i5-4590-Processor-6M-Cache-up-to-3_70-GHz)|[NVIDIA GeForce GTX 750 Ti](http://www.geforce.com/hardware/desktop-gpus/geforce-gtx-750-ti/specifications)|
|4.|[Intel Core i5-3570](http://ark.intel.com/products/65702/Intel-Core-i5-3570-Processor-6M-Cache-up-to-3_80-GHz)| - |
|5.|[Intel Core i3-2120](http://ark.intel.com/products/53426/Intel-Core-i3-2120-Processor-3M-Cache-3_30-GHz)| - |
|6.|[Intel Core i3-3120M](http://ark.intel.com/products/71465/Intel-Core-i3-3120M-Processor-3M-Cache-2_50-GHz)| - |
|7.|[Intel Core i5-3317U](http://ark.intel.com/products/65707/Intel-Core-i5-3317U-Processor-3M-Cache-up-to-2_60-GHz)|[NVIDIA GeForce GT 630M](http://www.geforce.com/hardware/notebook-gpus/geforce-gt-630m/specifications)|
|8.|[Intel Pentium Dual-Core E5300](http://ark.intel.com/products/35300/Intel-Pentium-Processor-E5300-2M-Cache-2_60-GHz-800-MHz-FSB)| - |

**Benchmarks**: [R-benchmark-25](http://r.research.att.com/benchmarks/R-benchmark-25.R), [Revolution](https://gist.github.com/andrie/24c9672f1ea39af89c66#file-rro-mkl-benchmark-r), [Gcbd](https://cran.r-project.org/web/packages/gcbd/vignettes/gcbd.pdf).





# Results per host

## Intel Core i7-4790K + MSI GeForce GTX 980 Ti Lightning



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h1_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h1_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h1_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h1_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h1_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h1_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h1_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h1_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h1_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h1_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h1_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h1_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h1_b3_t1.png)![](gen/img/img_ph_h1_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h1_b3_t2.png)![](gen/img/img_ph_h1_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h1_b3_t3.png)![](gen/img/img_ph_h1_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h1_b3_t4.png)![](gen/img/img_ph_h1_b3_t4b.png)



## Intel Core i5-4590 + NVIDIA GeForce GT 430



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h2_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h2_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h2_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h2_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h2_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h2_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h2_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h2_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h2_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h2_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h2_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h2_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h2_b3_t1.png)![](gen/img/img_ph_h2_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h2_b3_t2.png)![](gen/img/img_ph_h2_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h2_b3_t3.png)![](gen/img/img_ph_h2_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h2_b3_t4.png)![](gen/img/img_ph_h2_b3_t4b.png)



## Intel Core i5-4590 + NVIDIA GeForce GTX 750 Ti



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h3_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h3_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h3_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h3_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h3_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h3_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h3_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h3_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h3_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h3_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h3_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h3_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h3_b3_t1.png)![](gen/img/img_ph_h3_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h3_b3_t2.png)![](gen/img/img_ph_h3_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h3_b3_t3.png)![](gen/img/img_ph_h3_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h3_b3_t4.png)![](gen/img/img_ph_h3_b3_t4b.png)



## Intel Core i5-3570



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h4_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h4_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h4_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h4_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h4_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h4_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h4_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h4_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h4_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h4_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h4_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h4_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h4_b3_t1.png)![](gen/img/img_ph_h4_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h4_b3_t2.png)![](gen/img/img_ph_h4_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h4_b3_t3.png)![](gen/img/img_ph_h4_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h4_b3_t4.png)![](gen/img/img_ph_h4_b3_t4b.png)



## Intel Core i3-2120



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h5_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h5_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h5_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h5_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h5_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h5_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h5_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h5_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h5_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h5_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h5_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h5_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h5_b3_t1.png)![](gen/img/img_ph_h5_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h5_b3_t2.png)![](gen/img/img_ph_h5_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h5_b3_t3.png)![](gen/img/img_ph_h5_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h5_b3_t4.png)![](gen/img/img_ph_h5_b3_t4b.png)



## Intel Core i3-3120M



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h6_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h6_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h6_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h6_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h6_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h6_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h6_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h6_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h6_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h6_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h6_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h6_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h6_b3_t1.png)![](gen/img/img_ph_h6_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h6_b3_t2.png)![](gen/img/img_ph_h6_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h6_b3_t3.png)![](gen/img/img_ph_h6_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h6_b3_t4.png)![](gen/img/img_ph_h6_b3_t4b.png)



## Intel Core i5-3317U + NVIDIA GeForce GT 630M



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h7_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h7_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h7_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h7_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h7_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h7_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h7_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h7_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h7_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h7_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h7_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h7_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h7_b3_t1.png)![](gen/img/img_ph_h7_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h7_b3_t2.png)![](gen/img/img_ph_h7_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h7_b3_t3.png)![](gen/img/img_ph_h7_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h7_b3_t4.png)![](gen/img/img_ph_h7_b3_t4b.png)



## Intel Pentium Dual-Core E5300



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h8_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h8_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

BLIS hangs in this test

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h8_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h8_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h8_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h8_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h8_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h8_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h8_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h8_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h8_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_ph_h8_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h8_b3_t1.png)![](gen/img/img_ph_h8_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h8_b3_t2.png)![](gen/img/img_ph_h8_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h8_b3_t3.png)![](gen/img/img_ph_h8_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_ph_h8_b3_t4.png)![](gen/img/img_ph_h8_b3_t4b.png)




# Results per library

## Netlib



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l1_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l1_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l1_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l1_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l1_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l1_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l1_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l1_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l1_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l1_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l1_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l1_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l1_b3_t1.png)![](gen/img/img_pl_l1_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l1_b3_t2.png)![](gen/img/img_pl_l1_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l1_b3_t3.png)![](gen/img/img_pl_l1_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l1_b3_t4.png)![](gen/img/img_pl_l1_b3_t4b.png)



## ATLAS (st)



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l2_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l2_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l2_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l2_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l2_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l2_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l2_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l2_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l2_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l2_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l2_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l2_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l2_b3_t1.png)![](gen/img/img_pl_l2_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l2_b3_t2.png)![](gen/img/img_pl_l2_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l2_b3_t3.png)![](gen/img/img_pl_l2_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l2_b3_t4.png)![](gen/img/img_pl_l2_b3_t4b.png)



## OpenBLAS



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l3_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l3_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l3_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l3_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l3_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l3_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l3_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l3_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l3_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l3_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l3_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l3_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l3_b3_t1.png)![](gen/img/img_pl_l3_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l3_b3_t2.png)![](gen/img/img_pl_l3_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l3_b3_t3.png)![](gen/img/img_pl_l3_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l3_b3_t4.png)![](gen/img/img_pl_l3_b3_t4b.png)



## ATLAS (mt)



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l4_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l4_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l4_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l4_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l4_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l4_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l4_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l4_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l4_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l4_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l4_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l4_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l4_b3_t1.png)![](gen/img/img_pl_l4_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l4_b3_t2.png)![](gen/img/img_pl_l4_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l4_b3_t3.png)![](gen/img/img_pl_l4_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l4_b3_t4.png)![](gen/img/img_pl_l4_b3_t4b.png)



## GotoBLAS2



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l5_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l5_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l5_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l5_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l5_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l5_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l5_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l5_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l5_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l5_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l5_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l5_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l5_b3_t1.png)![](gen/img/img_pl_l5_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l5_b3_t2.png)![](gen/img/img_pl_l5_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l5_b3_t3.png)![](gen/img/img_pl_l5_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l5_b3_t4.png)![](gen/img/img_pl_l5_b3_t4b.png)



## MKL



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l6_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l6_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l6_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l6_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l6_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l6_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l6_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l6_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l6_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l6_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l6_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l6_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l6_b3_t1.png)![](gen/img/img_pl_l6_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l6_b3_t2.png)![](gen/img/img_pl_l6_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l6_b3_t3.png)![](gen/img/img_pl_l6_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l6_b3_t4.png)![](gen/img/img_pl_l6_b3_t4b.png)



## BLIS



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l7_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l7_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Intel Pentium Dual-Core E5300 hangs in this test

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l7_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l7_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l7_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l7_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l7_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l7_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l7_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l7_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l7_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l7_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l7_b3_t1.png)![](gen/img/img_pl_l7_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l7_b3_t2.png)![](gen/img/img_pl_l7_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l7_b3_t3.png)![](gen/img/img_pl_l7_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l7_b3_t4.png)![](gen/img/img_pl_l7_b3_t4b.png)



## cuBLAS



### R-benchmark-25

#### 2800x2800 cross-product matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l8_b1_t1.png)



#### Linear regr. over a 2000x2000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l8_b1_t2.png)



#### Eigenvalues of a 600x600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l8_b1_t3.png)



#### Determinant of a 2500x2500 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l8_b1_t4.png)



#### Cholesky decomposition of a 3000x3000 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l8_b1_t5.png)



#### Inverse of a 1600x1600 random matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l8_b1_t6.png)



#### Escoufier's method on a 45x45 matrix 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l8_b1_t7.png)



### Revolution benchmark

#### Matrix Multiply 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l8_b2_t1.png)



#### Cholesky Factorization 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l8_b2_t2.png)



#### Singular Value Deomposition 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l8_b2_t3.png)



#### Principal Components Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l8_b2_t4.png)



#### Linear Discriminant Analysis 

Time in seconds  - 10 runs - lower is better

![](gen/img/img_pl_l8_b2_t5.png)



### Gcbd benchmark

#### Matrix Multiply 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l8_b3_t1.png)![](gen/img/img_pl_l8_b3_t1b.png)



#### QR Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l8_b3_t2.png)![](gen/img/img_pl_l8_b3_t2b.png)



#### Singular Value Deomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l8_b3_t3.png)![](gen/img/img_pl_l8_b3_t3b.png)



#### Triangular Decomposition 

Time in seconds regarding matrix size - right panel on log scale -  from  50  to  5 runs - lower is better

![](gen/img/img_pl_l8_b3_t4.png)![](gen/img/img_pl_l8_b3_t4b.png)

