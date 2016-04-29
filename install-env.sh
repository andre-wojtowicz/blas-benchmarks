#!/bin/bash

WGET_OPTIONS="--no-check-certificate"
MRO_VERSION="3.2.4"

# update debian repos & upgrade packages
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" upgrade

# install new packages for R
apt-get -y install build-essential gfortran ed htop libxml2-dev ca-certificates curl libcurl4-openssl-dev gdebi-core sshpass git cpufrequtils

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

# make directory for BLAS and LAPACK libraries
mkdir -p /opt/blap-lib/

# Generic BLAS & LAPACK install/uninstall in R:
#
# install:   mv /opt/MRO-lib/libRblas.so   /opt/MRO-lib/libRblas.so.orig
#            mv /opt/MRO-lib/libRlapack.so /opt/MRO-lib/libRlapack.so.orig
#            ln -s /opt/blap-lib/xxx/libblas.so   /opt/MRO-lib/libRblas.so
#            ln -s /opt/blap-lib/xxx/liblapack.so /opt/MRO-lib/libRlapack.so
#
# uninstall: rm /opt/MRO-lib/libRblas.so
#            rm /opt/MRO-lib/libRlapack.so
#            mv /opt/MRO-lib/libRblas.so.orig   /opt/MRO-lib/libRblas.so
#            mv /opt/MRO-lib/libRlapack.so.orig /opt/MRO-lib/libRlapack.so

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

mkdir /opt/blap-lib/netlib/

apt-get -y install libblas3 liblapack3

cp /usr/lib/libblas/libblas.so.3.0  /opt/blap-lib/netlib/
cp /usr/lib/lapack/liblapack.so.3.0 /opt/blap-lib/netlib/

apt-get -y purge libblas3 liblapack3

##############################################################
# ATLAS (st)                                                 #
# - http://math-atlas.sourceforge.net/                       #
# - BLAS + LAPACK                                            #
# - single-threaded                                          #
##############################################################

mkdir /opt/blap-lib/atlas-st/

apt-get -y install libatlas3-base

cp /usr/lib/atlas-base/atlas/libblas.so.3   /opt/blap-lib/atlas-st/
cp /usr/lib/atlas-base/atlas/liblapack.so.3 /opt/blap-lib/atlas-st/

apt-get -y purge libatlas3-base

##############################################################
# OpenBLAS                                                   #
# - http://www.openblas.net/                                 #
# - BLAS + LAPACK                                            #
# - multi-threaded                                           #
##############################################################

mkdir /opt/blap-lib/openblas/

apt-get -y install libopenblas-base

cp /usr/lib/openblas-base/libblas.so.3   /opt/blap-lib/openblas/
cp /usr/lib/openblas-base/liblapack.so.3 /opt/blap-lib/openblas/

apt-get -y purge libopenblas-base

##############################################################
# ATLAS (mt)                                                 #
# - http://math-atlas.sourceforge.net/                       #
# - BLAS + LAPACK                                            #
# - multi-threaded                                           #
##############################################################

mkdir /opt/blap-lib/atlas-mt/

curl -L https://sourceforge.net/projects/math-atlas/files/Developer%20%28unstable%29/3.11.38/atlas3.11.38.tar.bz2/download > atlas3.11.38.tar.bz2
tar -xvf atlas3.11.38.tar.bz2
rm atlas3.11.38.tar.bz2

cd ATLAS
mkdir build
cd build

wget ${WGET_OPTIONS} http://www.netlib.org/lapack/lapack-3.6.0.tgz

../configure --shared --with-netlib-lapack-tarfile=`pwd`/lapack-3.6.0.tgz
make

cp lib/libtatlas.so /opt/blap-lib/atlas-mt/

cd ../../
rm -r ATLAS

##############################################################
# GotoBLAS2                                                  #
# - https://prs.ism.ac.jp/~nakama/SurviveGotoBLAS2/          #
# - BLAS + LAPACK                                            #
# - multi-threaded                                           #
##############################################################

mkdir /opt/blap-lib/gotoblas2/

wget ${WGET_OPTIONS} https://prs.ism.ac.jp/~nakama/SurviveGotoBLAS2/SurviveGotoBLAS2_3.141.tar.gz
tar -xvf SurviveGotoBLAS2_3.141.tar.gz
rm SurviveGotoBLAS2_3.141.tar.gz

cd survivegotoblas2-3.141
make -j `nproc`
cd ..

cp survivegotoblas2-3.141/exports/libgoto2_nehalemp-r3.141_blas.so   /opt/blap-lib/gotoblas2/
cp survivegotoblas2-3.141/exports/libgoto2_nehalemp-r3.141_lapack.so /opt/blap-lib/gotoblas2/

rm -r survivegotoblas2-3.141

##############################################################
# MKL                                                        #
# - https://mran.microsoft.com/documents/rro/multithread/    #
# - BLAS + LAPACK                                            #
# - multi-threaded                                           #
##############################################################

mkdir /opt/blap-lib/mkl/

wget ${WGET_OPTIONS} https://mran.microsoft.com/install/mro/${MRO_VERSION}/RevoMath-${MRO_VERSION}.tar.gz
tar -xvzf RevoMath-${MRO_VERSION}.tar.gz
rm RevoMath-${MRO_VERSION}.tar.gz
sed -i '16,18d' RevoMath/RevoMath.sh

mv RevoMath /opt/blap-lib/mkl/

# install:   cd /opt/blap-lib/mkl/RevoMath ; echo 1 | ./RevoMath.sh
# uninstall: cd /opt/blap-lib/mkl/RevoMath ; echo 2 | ./RevoMath.sh

##############################################################
# BLIS                                                       #
# - https://github.com/flame/blis                            #
# - BLAS                                                     #
# - multi-threaded                                           #
##############################################################

mkdir /opt/blap-lib/blis/

git clone https://github.com/flame/blis.git
cd blis

./configure --enable-shared auto
make -j `nproc`
cd ..

cp `find ./blis/ -name "libblis.so"` /opt/blap-lib/blis/

rm -r blis

##############################################################
##############################################################
##                          GPU                             ##
##############################################################
##############################################################

##############################################################
# clBLAS                                                     #
# - https://github.com/clMathLibraries/clBLAS                #
# - BLAS                                                     #
# - OpenCL                                                   #
##############################################################

git clone https://github.com/clMathLibraries/clBLAS.git

##############################################################
# cuBLAS (NVBLAS)                                            #
# - https://developer.nvidia.com/cublas                      #
# - BLAS                                                     #
# - CUDA                                                     #
##############################################################

# Ubuntu dependencies
wget ${WGET_OPTIONS} http://de.archive.ubuntu.com/ubuntu/pool/main/x/x-kit/python3-xkit_0.5.0ubuntu2_all.deb
wget ${WGET_OPTIONS} http://de.archive.ubuntu.com/ubuntu/pool/main/s/screen-resolution-extra/screen-resolution-extra_0.17.1_all.deb
gdebi -n python3-xkit_0.5.0ubuntu2_all.deb
gdebi -n screen-resolution-extra_0.17.1_all.deb

wget ${WGET_OPTIONS} http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda-repo-ubuntu1504-7-5-local_7.5-18_amd64.deb
gdebi -n cuda-repo-ubuntu1504-7-5-local_7.5-18_amd64.deb
rm cuda-repo-ubuntu1504-7-5-local_7.5-18_amd64.deb

##############################################################
# MAGMA                                                      #
# - http://icl.cs.utk.edu/magma/software/                    #
# - LAPACK                                                   #
# - OpenCL, CUDA                                             #
##############################################################

##############################################################
# CULA                                                       #
# - http://www.culatools.com/                                #
# - LAPACK                                                   #
# - CUDA                                                     #
##############################################################
