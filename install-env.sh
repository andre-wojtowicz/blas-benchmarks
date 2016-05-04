#!/bin/bash

WGET_OPTIONS="--no-check-certificate"
MRO_VERSION="3.2.4"
CHECKPOINT_DATE="2016-04-01"
R_SAMPLE_BENCHMARK="Rscript sample-benchmark.R"
DIR_BLAP="/opt/blap-lib"

#TODO: 
# - leave installed packages
# - after installation export "LD_PRELOAD"s

function mro_install {

    echo "Started installing Microsoft R Open and dependencies"

    # update debian repos & upgrade packages
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" upgrade

    # install new packages for R
    apt-get -y install build-essential gfortran ed htop libxml2-dev ca-certificates curl libcurl4-openssl-dev gdebi-core sshpass git cpufrequtils cmake

    # disable CPU throttling for ATLAS multi-threading
    echo performance | tee /sys/devices/system/cpu/cpu**/cpufreq/scaling_governor

    # hack with Microsoft R Open deps
    wget ${WGET_OPTIONS} http://ftp.pl.debian.org/debian/pool/main/libj/libjpeg8/libjpeg8_8d1-2_amd64.deb
    gdebi -n libjpeg8_8d1-2_amd64.deb
    rm libjpeg8_8d1-2_amd64.deb

    # install Microsoft R Open
    wget ${WGET_OPTIONS} https://mran.microsoft.com/install/mro/${MRO_VERSION}/MRO-${MRO_VERSION}-Ubuntu-15.4.x86_64.deb
    gdebi -n MRO-${MRO_VERSION}-Ubuntu-15.4.x86_64.deb
    rm MRO-${MRO_VERSION}-Ubuntu-15.4.x86_64.deb

    # make symbolic link to R libraries dir
    ln -s /usr/lib64/MRO-${MRO_VERSION}/R-${MRO_VERSION}/lib/R/lib/ /opt/MRO-lib

    # prepare R checkpoint
    mkdir ~/.checkpoint
    Rscript -e "library(checkpoint); checkpoint('${CHECKPOINT_DATE}')"
    sed -i "1i\library(checkpoint); checkpoint('${CHECKPOINT_DATE}', scanForPackages=FALSE, verbose=FALSE)" sample-benchmark.R

    # make directory for BLAS and LAPACK libraries
    mkdir -p ${DIR_BLAP}
    
    # clean archives
    apt-get clean
    
    echo "Finished installing Microsoft R Open and dependencies"
}

##############################################################
##############################################################
##                          CPU                             ##
##############################################################
##############################################################

##############################################################
# netlib                                                     #
# - http://www.netlib.org/                                   #
# - BLAS + LAPACK                                            #
# - single-threaded (reference)                              #
##############################################################

DIR_NETLIB="${DIR_BLAP}/netlib"

function netlib_install {

    echo "Started installing netlib"

    mkdir ${DIR_NETLIB}

    apt-get -y install libblas3 liblapack3

    cp /usr/lib/libblas/libblas.so.3.0  ${DIR_NETLIB}
    cp /usr/lib/lapack/liblapack.so.3.0 ${DIR_NETLIB}

    apt-get -y purge libblas3 liblapack3
    apt-get clean
    
    echo "Installed files:"
    find ${DIR_NETLIB} -type f

    echo "Finished installing netlib."
}

function netlib_check {

    echo "Started checking netlib."

    LD_PRELOAD="${DIR_NETLIB}/libblas.so.3.0 ${DIR_NETLIB}/liblapack.so.3.0" ${R_SAMPLE_BENCHMARK}

    echo "Finished checking netlib"
}

##############################################################
# ATLAS (st)                                                 #
# - http://math-atlas.sourceforge.net/                       #
# - BLAS + LAPACK                                            #
# - single-threaded                                          #
##############################################################

DIR_ATLAS_ST="${DIR_BLAP}/atlas-st"

function atlas_st_install {

    echo "Started installing ATLAS (single-threaded)"

    mkdir ${DIR_ATLAS_ST}

    apt-get -y install libatlas3-base

    cp /usr/lib/atlas-base/libatlas.so.3        ${DIR_ATLAS_ST}
    cp /usr/lib/atlas-base/atlas/libblas.so.3   ${DIR_ATLAS_ST}
    cp /usr/lib/atlas-base/atlas/liblapack.so.3 ${DIR_ATLAS_ST}

    apt-get -y purge libatlas3-base
    apt-get clean
    
    echo "Installed files:"
    find ${DIR_ATLAS_ST} -type f

    echo "Finished installing ATLAS (single-threaded)"
}

function atlas_st_check {

    echo "Started checking ATLAS (single-threaded)"

    LD_PRELOAD="${DIR_ATLAS_ST}/libatlas.so.3 ${DIR_ATLAS_ST}/libblas.so.3 ${DIR_ATLAS_ST}/liblapack.so.3" ${R_SAMPLE_BENCHMARK}

    echo "Finished checking ATLAS (single-threaded)"
}

##############################################################
# OpenBLAS                                                   #
# - http://www.openblas.net/                                 #
# - BLAS + LAPACK                                            #
# - multi-threaded                                           #
##############################################################

DIR_OPENBLAS="${DIR_BLAP}/openblas"

function openblas_install {

    echo "Started installing OpenBLAS"

    mkdir ${DIR_OPENBLAS}

    apt-get -y install libopenblas-base

    cp /usr/lib/libopenblas.so.0             ${DIR_OPENBLAS}
    cp /usr/lib/openblas-base/libblas.so.3   ${DIR_OPENBLAS}
    cp /usr/lib/openblas-base/liblapack.so.3 ${DIR_OPENBLAS}

    apt-get -y purge libopenblas-base
    apt-get clean
    
    echo "Installed files:"
    find ${DIR_OPENBLAS} -type f

    echo "Finished installing OpenBLAS"
}

function openblas_check {

    echo "Started checking OpenBLAS"

    LD_PRELOAD="${DIR_OPENBLAS}/libopenblas.so.0 ${DIR_OPENBLAS}/libblas.so.3 ${DIR_OPENBLAS}/liblapack.so.3" ${R_SAMPLE_BENCHMARK}

    echo "Finished checking OpenBLAS"
}

##############################################################
# ATLAS (mt)                                                 #
# - http://math-atlas.sourceforge.net/                       #
# - BLAS + netlib LAPACK                                     #
# - multi-threaded                                           #
##############################################################

DIR_ATLAS_MT="${DIR_BLAP}/atlas-mt"

function atlas_mt_install {

    echo "Started installing ATLAS (multi-threaded)"

    mkdir ${DIR_ATLAS_MT}

    curl -L https://sourceforge.net/projects/math-atlas/files/Developer%20%28unstable%29/3.11.38/atlas3.11.38.tar.bz2/download > atlas3.11.38.tar.bz2
    tar -xvf atlas3.11.38.tar.bz2
    rm atlas3.11.38.tar.bz2

    cd ATLAS
    mkdir build
    cd build

    wget ${WGET_OPTIONS} http://www.netlib.org/lapack/lapack-3.6.0.tgz

    ../configure --shared --with-netlib-lapack-tarfile=`pwd`/lapack-3.6.0.tgz
    make

    cp lib/libtatlas.so ${DIR_ATLAS_MT}

    cd ../../
    rm -r ATLAS
    
    echo "Installed files:"
    find ${DIR_ATLAS_MT} -type f

    echo "Finished installing ATLAS (multi-threaded)"
}

function atlas_mt_check {

    echo "Started checking ATLAS (multi-threaded)"

    LD_PRELOAD="${DIR_ATLAS_MT}/libtatlas.so" ${R_SAMPLE_BENCHMARK}

    echo "Finished checking ATLAS (multi-threaded)"
}

##############################################################
# GotoBLAS2                                                  #
# - https://prs.ism.ac.jp/~nakama/SurviveGotoBLAS2/          #
# - BLAS + LAPACK                                            #
# - multi-threaded                                           #
##############################################################

DIR_GOTOBLAS2="${DIR_BLAP}/gotoblas2"

function gotoblas2_install {

    echo "Started installing GotoBLAS2"

    mkdir ${DIR_GOTOBLAS2}

    wget ${WGET_OPTIONS} https://prs.ism.ac.jp/~nakama/SurviveGotoBLAS2/SurviveGotoBLAS2_3.141.tar.gz
    tar -xvf SurviveGotoBLAS2_3.141.tar.gz
    rm SurviveGotoBLAS2_3.141.tar.gz

    cd survivegotoblas2-3.141
    make REFBLAS_ANTILOGY=1 NO_CBLAS=1 GOTOBLASLIBSONAME=libgoto2blas.so GOTOLAPACKLIBSONAME=libgoto2lapack.so -j `nproc`
    
    cp exports/libgoto2blas.so   ${DIR_GOTOBLAS2}
    cp exports/libgoto2lapack.so ${DIR_GOTOBLAS2}
    
    cd ..
    rm -r survivegotoblas2-3.141
    
    Rscript -e "library(checkpoint); checkpoint('${CHECKPOINT_DATE}', scanForPackages=FALSE, verbose=FALSE); install.packages('RhpcBLASctl')"
    
    echo "Installed files:"
    find ${DIR_GOTOBLAS2} -type f

    echo "Finished installing GotoBLAS2"
}

function gotoblas2_check {

    echo "Started checking GotoBLAS2"

    echo "${DIR_GOTOBLAS2}" > /etc/ld.so.conf.d/gotoblas2.conf
    ldconfig
    sed "2i\library(RhpcBLASctl); blas_set_num_threads(`nproc`)" sample-benchmark.R > sample-benchmark-gotoblas2.R
    
    LD_PRELOAD="${DIR_GOTOBLAS2}/libgoto2blas.so ${DIR_GOTOBLAS2}/libgoto2lapack.so" GOTO_NUM_THREADS=`nproc` Rscript sample-benchmark-gotoblas2.R
    
    rm /etc/ld.so.conf.d/gotoblas2.conf
    ldconfig
    rm sample-benchmark-gotoblas2.R

    echo "Finished checking GotoBLAS2"
}

##############################################################
# MKL                                                        #
# - https://mran.microsoft.com/documents/rro/multithread/    #
# - BLAS + LAPACK                                            #
# - multi-threaded                                           #
##############################################################

DIR_MKL="${DIR_BLAP}/mkl"

function mkl_install {

    echo "Started installing MKL"

    mkdir ${DIR_MKL}

    wget ${WGET_OPTIONS} https://mran.microsoft.com/install/mro/${MRO_VERSION}/RevoMath-${MRO_VERSION}.tar.gz
    tar -xvzf RevoMath-${MRO_VERSION}.tar.gz
    rm RevoMath-${MRO_VERSION}.tar.gz
    
    cp RevoMath/mkl/libs/*.so ${DIR_MKL}

    rm RevoMath -r
    
    echo "Installed files:"
    find ${DIR_MKL} -type f

    echo "Finished installing MKL"
}

function mkl_check {

    echo "Started checking MKL"

    LD_PRELOAD="${DIR_MKL}/libRblas.so ${DIR_MKL}/libRlapack.so ${DIR_MKL}/libmkl_vml_mc3.so ${DIR_MKL}/libmkl_vml_def.so ${DIR_MKL}/libmkl_gnu_thread.so ${DIR_MKL}/libmkl_core.so ${DIR_MKL}/libmkl_gf_lp64.so ${DIR_MKL}/libiomp5.so ${DIR_MKL}/libmkl_gf_ilp64.so" MKL_INTERFACE_LAYER="GNU,LP64" MKL_THREADING_LAYER="GNU" ${R_SAMPLE_BENCHMARK}

    echo "Finished checking MKL"
}

##############################################################
# BLIS                                                       #
# - https://github.com/flame/blis                            #
# - BLAS                                                     #
# - multi-threaded                                           #
##############################################################

DIR_BLIS="${DIR_BLAP}/blis"

function blis_install {

    echo "Started installing BLIS"

    mkdir ${DIR_BLIS}

    git clone https://github.com/flame/blis.git
    cd blis
    git checkout 0b01d355ae861754ae2da6c9a545474af010f02e
    
    ./configure -t pthreads --enable-shared auto
    make -j `nproc`
    cd ..

    cp `find ./blis/ -name "libblis.so"` ${DIR_BLIS}

    rm -r blis
    
    echo "Installed files:"
    find ${DIR_BLIS} -type f

    echo "Finished installing BLIS"
}

function blis_check {

    echo "Started checking BLIS"

    # TODO: auto set variables according to https://github.com/flame/blis/wiki/Multithreading
    LD_PRELOAD="${DIR_BLIS}/libblis.so" BLIS_JC_NT=2 BLIS_IC_NT=1 BLIS_JR_NT=1 BLIS_IR_NT=1 ${R_SAMPLE_BENCHMARK}

    echo "Finished checking BLIS"
}

##############################################################
##############################################################
##                          GPU                             ##
##############################################################
##############################################################

##############################################################
# cuBLAS (NVBLAS)                                            #
# - https://developer.nvidia.com/cublas                      #
# - BLAS                                                     #
# - CUDA                                                     #
##############################################################

function cublas_install {

    echo "Started installing cuBLAS"

    # TODO: cuSOLVE (dense, LAPACK)?

    mkdir /opt/blap-lib/cublas

    modprobe -r nouveau

    apt-get install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') nvidia-driver nvidia-modprobe libcuda1 libnvblas6.5 -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" 
    # TODO: optimus - bbswitch ?

    nvidia-modprobe

    echo "#NVBLAS_LOGFILE       nvblas.log
    NVBLAS_CPU_BLAS_LIB  /opt/blap-lib/netlib/libblas.so.3.0
    NVBLAS_GPU_LIST      ALL0
    NVBLAS_TILE_DIM      2048
    NVBLAS_AUTOPIN_MEM_ENABLED" > /opt/blap-lib/cublas/nvblas.conf
    
    apt-get clean

    echo "Finished installing cuBLAS"
}

#TODO: switch to 7.5
function cublas_get_online {

    wget ${WGET_OPTIONS} http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1504/x86_64/cuda-repo-ubuntu1504_7.5-18_amd64.deb
    dpkg -i cuda-repo-ubuntu1504_7.5-18_amd64.deb
    apt-get update
    rm cuda-repo-ubuntu1504_7.5-18_amd64.deb
}

function cublas_check {

    echo "Started checking cuBLAS"

    NVBLAS_CONFIG_FILE=/opt/blap-lib/cublas/nvblas.conf LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libnvblas.so.6.5 /usr/lib/x86_64-linux-gnu/libcublas.so.6.5" ${R_SAMPLE_BENCHMARK}
    
    echo "Finished checking cuBLAS"
}

##############################################################
# clBLAS                                                     #
# - https://github.com/clMathLibraries/clBLAS                #
# - BLAS                                                     #
# - OpenCL                                                   #
##############################################################

function clblas_install {

    echo "Started installing clBLAS"
    
    apt-get install libboost-dev liblapack-dev libboost-program-options-dev opencl-headers nvidia-opencl-dev -y

    wget ${WGET_OPTIONS} https://github.com/clMathLibraries/clBLAS/archive/v2.10.tar.gz -O clBLAS-2.10.tar.gz
    tar -xvzf clBLAS-2.10.tar.gz
    rm clBLAS-2.10.tar.gz

    cd clBLAS-2.10/src
    
    cmake .
    make -j `nproc`
    
    cd ../..
    echo "TODO!"
    #rm -r clBLAS-2.10/src
    

    echo "Finished installing clBLAS"
}

##############################################################
# MAGMA                                                      #
# - http://icl.cs.utk.edu/magma/software/                    #
# - LAPACK                                                   #
# - OpenCL, CUDA                                             #
##############################################################

function magma_install {

    echo "Started installing MAGMA"
    
    apt-get install nvidia-cuda-toolkit -y
    spt-get clean

    wget http://icl.cs.utk.edu/projectsfiles/magma/downloads/magma-2.0.2.tar.gz
    tar -xvf magmamagma-2.0.2.tar.gz
    rm magma-2.0.2.tar.gz
    
    cd magma-2.0.2
    
    echo "TODO!"
    
    #make shared
    
    cd ..
    #rm -r magma-2.0.2

    echo "Finished installing MAGMA"
}

##############################################################
# CULA                                                       #
# - http://www.culatools.com/                                #
# - LAPACK                                                   #
# - CUDA                                                     #
##############################################################

function cula_install {

    echo "Started installing CULA"

    echo "TODO!"

    echo "Finished installing CULA"
}


##############################################################
##############################################################

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
else
    for i in "$@"
    do
        $i
    done
fi
