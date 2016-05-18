#!/bin/bash

WGET_OPTIONS="--no-check-certificate"
MRO_VERSION="3.2.4"
CHECKPOINT_DATE="2016-04-01"
R_BENCHMARK_SCRIPT="sample-benchmark.R"
DIR_BLAS="/opt/blas-libs"

if [ ! -f ./cpuinfo ]; then
    echo "Intel processor family information utility not found, aborting..."
    exit 1
fi

PROCESSOR_CORES=`./cpuinfo -g | grep -oP 'Cores( +):( +)\K(\d+)'`
PROCESSOR_CPUS=`./cpuinfo -g | grep -oP 'Processors\(CPUs\)( +):( +)\K(\d+)'`

NPROC=${PROCESSOR_CORES}

function mro_install {

    echo "Started installing Microsoft R Open and dependencies"

    # update debian repos & upgrade packages
    echo "deb http://snapshot.debian.org/archive/debian/20160411T102554Z/ jessie-backports main" >> /etc/apt/sources.list
    apt-get -o Acquire::Check-Valid-Until=false update
    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" upgrade

    # install core packages
    apt-get -y install build-essential gfortran ed htop libxml2-dev ca-certificates curl libcurl4-openssl-dev gdebi-core sshpass git cpufrequtils cmake initramfs-tools linux-headers-$(uname -r) nvidia-detect bc

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
    sed -i "1i\library(checkpoint); checkpoint('${CHECKPOINT_DATE}', scanForPackages=FALSE, verbose=FALSE)" revolution-benchmark.R
    sed -i "1i\library(checkpoint); checkpoint('${CHECKPOINT_DATE}', scanForPackages=FALSE, verbose=FALSE)" R-benchmark-25.R

    # make directory for BLAS and LAPACK libraries
    mkdir -p ${DIR_BLAS}
    
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

DIR_NETLIB="${DIR_BLAS}/netlib"

function netlib_install {

    echo "Started installing netlib"

    mkdir ${DIR_NETLIB}

    apt-get -y install libblas3 liblapack3

    cp /usr/lib/libblas/libblas.so.3.0  ${DIR_NETLIB}
    cp /usr/lib/lapack/liblapack.so.3.0 ${DIR_NETLIB}

    apt-get -y purge libblas3 liblapack3
    apt-get -y autoremove
    apt-get clean
    
    echo "Installed files:"
    find ${DIR_NETLIB} -type f

    echo "Finished installing netlib."
}

function netlib_remove {

    echo "Started removing netlib"

    rm ${DIR_NETLIB} -r

    echo "Finished removing netlib."
}

function netlib_check {

    echo "Started checking netlib."

    LD_PRELOAD="${DIR_NETLIB}/libblas.so.3.0 ${DIR_NETLIB}/liblapack.so.3.0" Rscript ${R_BENCHMARK_SCRIPT}

    echo "Finished checking netlib"
}

##############################################################
# ATLAS (st)                                                 #
# - http://math-atlas.sourceforge.net/                       #
# - BLAS + LAPACK                                            #
# - single-threaded                                          #
##############################################################

DIR_ATLAS_ST="${DIR_BLAS}/atlas-st"

function atlas_st_install {

    echo "Started installing ATLAS (single-threaded)"

    mkdir ${DIR_ATLAS_ST}

    apt-get -y install libatlas3-base

    cp /usr/lib/atlas-base/libatlas.so.3        ${DIR_ATLAS_ST}
    cp /usr/lib/atlas-base/atlas/libblas.so.3   ${DIR_ATLAS_ST}
    cp /usr/lib/atlas-base/atlas/liblapack.so.3 ${DIR_ATLAS_ST}

    apt-get -y purge libatlas3-base
    apt-get -y autoremove
    apt-get clean
    
    echo "Installed files:"
    find ${DIR_ATLAS_ST} -type f

    echo "Finished installing ATLAS (single-threaded)"
}

function atlas_st_check {

    echo "Started checking ATLAS (single-threaded)"

    LD_PRELOAD="${DIR_ATLAS_ST}/libatlas.so.3 ${DIR_ATLAS_ST}/libblas.so.3 ${DIR_ATLAS_ST}/liblapack.so.3" Rscript ${R_BENCHMARK_SCRIPT}

    echo "Finished checking ATLAS (single-threaded)"
}

function atlas_st_remove {

    echo "Started removing ATLAS (single-threaded)"

    rm ${DIR_ATLAS_ST} -r

    echo "Finished removing ATLAS (single-threaded)"
}

##############################################################
# OpenBLAS                                                   #
# - http://www.openblas.net/                                 #
# - BLAS + LAPACK                                            #
# - multi-threaded                                           #
##############################################################

DIR_OPENBLAS="${DIR_BLAS}/openblas"

function openblas_install {

    echo "Started installing OpenBLAS"

    mkdir ${DIR_OPENBLAS}

    apt-get -y install libopenblas-base

    cp /usr/lib/libopenblas.so.0             ${DIR_OPENBLAS}
    cp /usr/lib/openblas-base/libblas.so.3   ${DIR_OPENBLAS}
    cp /usr/lib/openblas-base/liblapack.so.3 ${DIR_OPENBLAS}

    apt-get -y purge libopenblas-base
    apt-get -y autoremove
    apt-get clean
    
    echo "Installed files:"
    find ${DIR_OPENBLAS} -type f

    echo "Finished installing OpenBLAS"
}

function openblas_check {

    echo "Started checking OpenBLAS"

    LD_PRELOAD="${DIR_OPENBLAS}/libopenblas.so.0 ${DIR_OPENBLAS}/libblas.so.3 ${DIR_OPENBLAS}/liblapack.so.3" Rscript ${R_BENCHMARK_SCRIPT}

    echo "Finished checking OpenBLAS"
}

function openblas_remove {

    echo "Started removing OpenBLAS"

    rm ${DIR_OPENBLAS} -r

    echo "Finished removing OpenBLAS"
}

##############################################################
# ATLAS (mt)                                                 #
# - http://math-atlas.sourceforge.net/                       #
# - BLAS + netlib LAPACK                                     #
# - multi-threaded                                           #
##############################################################

DIR_ATLAS_MT="${DIR_BLAS}/atlas-mt"

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

    sed -i "1423i\thrchk=0;" ../CONFIG/src/config.c

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

    LD_PRELOAD="${DIR_ATLAS_MT}/libtatlas.so" Rscript ${R_BENCHMARK_SCRIPT}

    echo "Finished checking ATLAS (multi-threaded)"
}

function atlas_mt_remove {

    echo "Started removing ATLAS (multi-threaded)"

    rm ${DIR_ATLAS_MT} -r

    echo "Finished removing ATLAS (multi-threaded)"
}

##############################################################
# GotoBLAS2                                                  #
# - https://prs.ism.ac.jp/~nakama/SurviveGotoBLAS2/          #
# - BLAS + LAPACK                                            #
# - multi-threaded                                           #
##############################################################

DIR_GOTOBLAS2="${DIR_BLAS}/gotoblas2"

function gotoblas2_install {

    echo "Started installing GotoBLAS2"

    mkdir ${DIR_GOTOBLAS2}

    wget ${WGET_OPTIONS} https://prs.ism.ac.jp/~nakama/SurviveGotoBLAS2/SurviveGotoBLAS2_3.141.tar.gz
    tar -xvf SurviveGotoBLAS2_3.141.tar.gz
    rm SurviveGotoBLAS2_3.141.tar.gz

    cd survivegotoblas2-3.141
    make REFBLAS_ANTILOGY=1 NO_CBLAS=1 GOTOBLASLIBSONAME=libgoto2blas.so GOTOLAPACKLIBSONAME=libgoto2lapack.so -j ${NPROC}
    
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
    sed "2i\library(RhpcBLASctl); blas_set_num_threads(${NPROC})" ${R_BENCHMARK_SCRIPT} > benchmark-gotoblas2.R
    
    LD_PRELOAD="${DIR_GOTOBLAS2}/libgoto2blas.so ${DIR_GOTOBLAS2}/libgoto2lapack.so" GOTO_NUM_THREADS=${NPROC} Rscript benchmark-gotoblas2.R
    
    rm /etc/ld.so.conf.d/gotoblas2.conf
    ldconfig
    rm benchmark-gotoblas2.R

    echo "Finished checking GotoBLAS2"
}

function gotoblas2_remove {

    echo "Started removing GotoBLAS2"

    rm ${DIR_GOTOBLAS2} -r

    echo "Finished removing GotoBLAS2"
}

##############################################################
# MKL                                                        #
# - https://mran.microsoft.com/documents/rro/multithread/    #
# - BLAS + LAPACK                                            #
# - multi-threaded                                           #
##############################################################

DIR_MKL="${DIR_BLAS}/mkl"

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

    LD_PRELOAD="${DIR_MKL}/libRblas.so ${DIR_MKL}/libRlapack.so ${DIR_MKL}/libmkl_vml_mc3.so ${DIR_MKL}/libmkl_vml_def.so ${DIR_MKL}/libmkl_gnu_thread.so ${DIR_MKL}/libmkl_core.so ${DIR_MKL}/libmkl_gf_lp64.so ${DIR_MKL}/libiomp5.so ${DIR_MKL}/libmkl_gf_ilp64.so" MKL_INTERFACE_LAYER="GNU,LP64" MKL_THREADING_LAYER="GNU" Rscript ${R_BENCHMARK_SCRIPT}

    echo "Finished checking MKL"
}

function mkl_remove {

    echo "Started removing MKL"

    rm ${DIR_MKL} -r

    echo "Finished removing MKL"
}

##############################################################
# BLIS                                                       #
# - https://github.com/flame/blis                            #
# - BLAS                                                     #
# - multi-threaded                                           #
##############################################################

DIR_BLIS="${DIR_BLAS}/blis"

function blis_install {

    echo "Started installing BLIS"

    mkdir ${DIR_BLIS}

    git clone https://github.com/flame/blis.git
    cd blis
    git checkout 32db0adc218ea4ae370164dbe8d23b41cd3526d3 # 17.05.2016
    
    ./configure -t pthreads --enable-shared auto
    make -j ${NPROC}
    cd ..

    cp `find ./blis/ -name "libblis.so"` ${DIR_BLIS}

    rm -r blis
    
    echo "Installed files:"
    find ${DIR_BLIS} -type f

    echo "Finished installing BLIS"
}

function blis_check {

    echo "Started checking BLIS"

    # auto set threading variables (more or less) according to https://github.com/flame/blis/wiki/Multithreading
    
    CPU_L3_PRESENT=`./cpuinfo -c | grep -coP "^L3"`
    CPU_L3_PRIVATE=`./cpuinfo -c | grep -coP "^L3(.*)no sharing"`
    CPU_L2_PRIVATE=`./cpuinfo -c | grep -coP "^L2(.*)no sharing"`
    CPU_L1_PRIVATE=`./cpuinfo -c | grep -coP "^L1(.*)no sharing"`
    
    COUNT_JC=1
    COUNT_IC=1
    COUNT_JR=1
    COUNT_IR=1
    
    PARALLEL_STEPS=`echo "l(${NPROC})/l(2)" | bc -l | grep -oP "^\d+"`
    PARALLEL_I_LOOP=0
    PARALLEL_J_LOOP=0
    
    while [ $PARALLEL_STEPS -gt 0 ]
    do
        if [ $PARALLEL_I_LOOP -lt $PARALLEL_J_LOOP ]; then
            if [ ${CPU_L2_PRIVATE} -eq 1 ]; then
                COUNT_IC=$((${COUNT_IC} * 2))
                PARALLEL_I_LOOP=$((${PARALLEL_I_LOOP} + 1))
            elif [ ${CPU_L3_PRESENT} -eq 1 -a ${CPU_L3_PRIVATE} -eq 1 ]; then
                COUNT_JC=$((${COUNT_JC} * 2))
                PARALLEL_J_LOOP=$((${PARALLEL_J_LOOP} + 1))
            elif [ ${CPU_L1_PRIVATE} -eq 1 ]; then
                COUNT_JR=$((${COUNT_JR} * 2))
                PARALLEL_J_LOOP=$((${PARALLEL_J_LOOP} + 1))
            else
                COUNT_IR=$((${COUNT_IR} * 2))
                PARALLEL_I_LOOP=$((${PARALLEL_I_LOOP} + 1))
            fi
        elif [ $PARALLEL_J_LOOP -lt $PARALLEL_I_LOOP ]; then
            if [ ${CPU_L3_PRESENT} -eq 1 -a ${CPU_L3_PRIVATE} -eq 1 ]; then
                COUNT_JC=$((${COUNT_JC} * 2))
                PARALLEL_J_LOOP=$((${PARALLEL_J_LOOP} + 1))
            elif [ ${CPU_L1_PRIVATE} -eq 1 ]; then
                COUNT_JR=$((${COUNT_JR} * 2))
                PARALLEL_J_LOOP=$((${PARALLEL_J_LOOP} + 1))
            elif [ ${CPU_L2_PRIVATE} -eq 1 ]; then
                COUNT_IC=$((${COUNT_IC} * 2))
                PARALLEL_I_LOOP=$((${PARALLEL_I_LOOP} + 1))
            else
                COUNT_IR=$((${COUNT_IR} * 2))
                PARALLEL_I_LOOP=$((${PARALLEL_I_LOOP} + 1))
            fi
        else
            if [ ${CPU_L3_PRESENT} -eq 1 -a ${CPU_L3_PRIVATE} -eq 1 ]; then
                COUNT_JC=$((${COUNT_JC} * 2))
                PARALLEL_J_LOOP=$((${PARALLEL_J_LOOP} + 1))
            elif [ ${CPU_L2_PRIVATE} -eq 1 ]; then
                COUNT_IC=$((${COUNT_IC} * 2))
                PARALLEL_I_LOOP=$((${PARALLEL_I_LOOP} + 1))
            elif [ ${CPU_L1_PRIVATE} -eq 1 ]; then
                COUNT_JR=$((${COUNT_JR} * 2))
                PARALLEL_J_LOOP=$((${PARALLEL_J_LOOP} + 1))
            else
                COUNT_IR=$((${COUNT_IR} * 2))
                PARALLEL_I_LOOP=$((${PARALLEL_I_LOOP} + 1))
            fi
        fi
    
        ((PARALLEL_STEPS--))
    done    
    
    LD_PRELOAD="${DIR_BLIS}/libblis.so" BLIS_JC_NT=${COUNT_JC} BLIS_IC_NT=${COUNT_IC} BLIS_JR_NT=${COUNT_JR} BLIS_IR_NT=${COUNT_IR} Rscript ${R_BENCHMARK_SCRIPT}

    echo "Finished checking BLIS"
}

function blis_remove {

    echo "Started removing BLIS"

    rm ${DIR_BLIS} -r

    echo "Finished removing BLIS"
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

DIR_CUBLAS="${DIR_BLAS}/cublas"

function cublas_install {

    if [ $(nvidia-detect | grep -c "No NVIDIA GPU detected.") -eq 1 ]; then
        echo "No NVIDIA GPU detected, cuBLAS installation aborted"
        return 1
    fi

    echo "Started installing cuBLAS"

    mkdir ${DIR_CUBLAS}

    modprobe -r nouveau

    DEBIAN_FRONTEND=noninteractive apt-get install nvidia-driver nvidia-modprobe libcuda1 libnvblas6.5 -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" 

    nvidia-modprobe

    echo "
    #NVBLAS_LOGFILE       nvblas.log
    NVBLAS_CPU_BLAS_LIB  ${DIR_MKL}/libRblas.so
    NVBLAS_GPU_LIST      ALL0
    NVBLAS_TILE_DIM      2048
    NVBLAS_AUTOPIN_MEM_ENABLED" > ${DIR_CUBLAS}/nvblas.conf

    apt-get clean

    echo "Finished installing cuBLAS"
}

# CUDA 7.5 currently supports linux kernel 3.x
#
#function cublas_online_install {
#
#    if [ $(nvidia-detect | grep -c "No NVIDIA GPU detected.") -eq 1 ]; then
#        echo "No NVIDIA GPU detected, cuBLAS online installation aborted"
#        return 1
#    fi
#
#    echo "Started installing online cuBLAS"
#
#    mkdir ${DIR_CUBLAS}
#
#    modprobe -r nouveau
#
#    # Ubuntu dependencies
#    wget ${WGET_OPTIONS} http://de.archive.ubuntu.com/ubuntu/pool/main/x/x-kit/python3-xkit_0.5.0ubuntu2_all.deb
#    wget ${WGET_OPTIONS} http://de.archive.ubuntu.com/ubuntu/pool/main/s/screen-resolution-extra/screen-resolution-extra_0.17.1_all.deb
#    gdebi -n python3-xkit_0.5.0ubuntu2_all.deb
#    gdebi -n screen-resolution-extra_0.17.1_all.deb
#
#    wget ${WGET_OPTIONS} http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1504/x86_64/cuda-repo-ubuntu1504_7.5-18_amd64.deb
#    dpkg -i cuda-repo-ubuntu1504_7.5-18_amd64.deb
#    apt-get -o Acquire::Check-Valid-Until=false update
#
#    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" install cuda-drivers cuda-cublas-7-5 nvidia-modprobe libcuda1-352
#
#    nvidia-modprobe
#
#    echo "
#    #NVBLAS_LOGFILE       nvblas.log
#    NVBLAS_CPU_BLAS_LIB   ${DIR_MKL}/libRblas.so
#    NVBLAS_GPU_LIST       ALL0
#    NVBLAS_TILE_DIM       2048
#    NVBLAS_AUTOPIN_MEM_ENABLED" > ${DIR_CUBLAS}/nvblas.conf
#
#    rm python3-xkit_0.5.0ubuntu2_all.deb
#    rm screen-resolution-extra_0.17.1_all.deb
#    rm cuda-repo-ubuntu1504_7.5-18_amd64.deb
#
#    apt-get clean
#
#    echo "Finished installing online cuBLAS"
#}

function cublas_check {

    if [ $(nvidia-detect | grep -c "No NVIDIA GPU detected.") -eq 1 ]; then
        echo "No NVIDIA GPU detected, cuBLAS check aborted"
        return 1
    fi

    echo "Started checking cuBLAS"

    NVBLAS_CONFIG_FILE="${DIR_CUBLAS}/nvblas.conf" LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libnvblas.so.6.5 /usr/lib/x86_64-linux-gnu/libcublas.so.6.5" Rscript ${R_BENCHMARK_SCRIPT}
    
    echo "Finished checking cuBLAS"
}


##############################################################
##############################################################

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
else
    for i in "$@"
    do  
        case "$i" in
            nproc_cores)
                NPROC=${PROCESSOR_CORES}
                ;;
            nproc_cpus)
                NPROC=${PROCESSOR_CPUS}
                ;;
            test_sample)
                R_BENCHMARK_SCRIPT="sample-benchmark.R"
                ;;
            test_urbanek)
                R_BENCHMARK_SCRIPT="R-benchmark-25.R"
                ;;
            test_revolution)
                R_BENCHMARK_SCRIPT="revolution-benchmark.R"
                ;;
            *)
                $i
        esac
    done
fi
