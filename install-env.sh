#!/bin/bash

# TODO: move from /root to /opt

WGET_OPTIONS="--no-check-certificate"
MRO_VERSION="3.2.4"

# update debian repos & upgrade packages
sed -i -e 's/ftp.debian.org/ftp.pl.debian.org/ig' /etc/apt/sources.list
sed -i -e 's/wheezy/jessie/ig' /etc/apt/sources.list

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" upgrade

# install new packages for R
apt-get -y install build-essential gfortran ed htop libxml2-dev ca-certificates curl libcurl4-openssl-dev gdebi-core sshpass

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

############################################################
#                        BLAS CPU                          #
############################################################

########################
# netlib - http://www.netlib.org/blas/ - reference singlethread
########################

# already in R

########################
# ATLAS - http://math-atlas.sourceforge.net/ - generic singlethread
########################

# install:   apt-get -y install libatlas3-base
#            mv /opt/MRO-lib/libRblas.so   /opt/MRO-lib/libRblas.so.orig
#            mv /opt/MRO-lib/libRlapack.so /opt/MRO-lib/libRlapack.so.orig
#            ln -s /usr/lib/atlas-base/atlas/libblas.so.3   /opt/MRO-lib/libRblas.so
#            ln -s /usr/lib/atlas-base/atlas/liblapack.so.3 /opt/MRO-lib/libRlapack.so

# uninstall: rm /opt/MRO-lib/libRblas.so
#            rm /opt/MRO-lib/libRlapack.so
#            mv /opt/MRO-lib/libRblas.so.orig   /opt/MRO-lib/libRblas.so
#            mv /opt/MRO-lib/libRlapack.so.orig /opt/MRO-lib/libRlapack.so
#            apt-get -y purge libatlas3-base

########################
# OpenBLAS - libopenblas-base - http://www.openblas.net/ - multithread
########################

# install:   apt-get -y install libopenblas-base
#            mv /opt/MRO-lib/libRblas.so   /opt/MRO-lib/libRblas.so.orig
#            mv /opt/MRO-lib/libRlapack.so /opt/MRO-lib/libRlapack.so.orig
#            ln -s /usr/lib/openblas-base/libblas.so.3   /opt/MRO-lib/libRblas.so
#            ln -s /usr/lib/openblas-base/liblapack.so.3 /opt/MRO-lib/libRlapack.so

# uninstall: rm /opt/MRO-lib/libRblas.so
#            rm /opt/MRO-lib/libRlapack.so
#            mv /opt/MRO-lib/libRblas.so.orig   /opt/MRO-lib/libRblas.so
#            mv /opt/MRO-lib/libRlapack.so.orig /opt/MRO-lib/libRlapack.so
#            apt-get -y purge libopenblas-base

########################
# ATLAS multithread - http://math-atlas.sourceforge.net/ - multithread
########################

# disable CPU throttling!

# netlib lapack
#
#wget ${WGET_OPTIONS} http://www.netlib.org/lapack/lapack-3.6.0.tgz
#tar -xvf lapack-3.6.0.tgz
#rm lapack-3.6.0.tgz
#
#cd lapack-3.6.0
#cp make.inc.example make.inc
#make lapacklib -j `nproc`
#cd ..

# atlas

curl -L https://sourceforge.net/projects/math-atlas/files/Developer%20%28unstable%29/3.11.38/atlas3.11.38.tar.bz2/download > atlas3.11.38.tar.bz2
tar -xvf atlas3.11.38.tar.bz2
rm atlas3.11.38.tar.bz2

cd ATLAS
mkdir build
cd build

wget ${WGET_OPTIONS} http://www.netlib.org/lapack/lapack-3.6.0.tgz

../configure --shared --with-netlib-lapack-tarfile=/root/blas-benchmark/ATLAS/build/lapack-3.6.0.tgz
make

rm lapack-3.6.0.tgz

########################
# GotoBLAS2 - https://prs.ism.ac.jp/~nakama/SurviveGotoBLAS2/ - multithread
########################

wget ${WGET_OPTIONS} https://prs.ism.ac.jp/~nakama/SurviveGotoBLAS2/SurviveGotoBLAS2_3.141.tar.gz
tar -xvf SurviveGotoBLAS2_3.141.tar.gz
rm SurviveGotoBLAS2_3.141.tar.gz

cd survivegotoblas2-3.141
make -j `nproc`
cd ..

# install:   mv /opt/MRO-lib/libRblas.so   /opt/MRO-lib/libRblas.so.orig
#            mv /opt/MRO-lib/libRlapack.so /opt/MRO-lib/libRlapack.so.orig
#            ln -s /root/blas-benchmark/survivegotoblas2-3.141/exports/libgoto2_nehalemp-r3.141_blas.so   /opt/MRO-lib/libRblas.so
#            ln -s /root/blas-benchmark/survivegotoblas2-3.141/exports/libgoto2_nehalemp-r3.141_lapack.so /opt/MRO-lib/libRlapack.so
#            ln -s /root/blas-benchmark/survivegotoblas2-3.141/exports/libgoto2_nehalemp-r3.141_blas.so   /opt/MRO-lib/libgoto2_nehalemp-r3.141_blas.so
#            ln -s /root/blas-benchmark/survivegotoblas2-3.141/exports/libgoto2_nehalemp-r3.141_lapack.so /opt/MRO-lib/libgoto2_nehalemp-r3.141_lapack.so

# uninstall: rm /opt/MRO-lib/libRblas.so
#            rm /opt/MRO-lib/libRlapack.so
#            rm /opt/MRO-lib/libgoto2_nehalemp-r3.141_blas.so
#            rm /opt/MRO-lib/libgoto2_nehalemp-r3.141_lapack.so
#            mv /opt/MRO-lib/libRblas.so.orig   /opt/MRO-lib/libRblas.so
#            mv /opt/MRO-lib/libRlapack.so.orig /opt/MRO-lib/libRlapack.so

########################
# MKL - https://mran.microsoft.com/documents/rro/multithread/ - multithread
########################

# install:   cd ~/RevoMath ; echo 1 | ./RevoMath.sh
# uninstall: cd ~/RevoMath ; echo 2 | ./RevoMath.sh

wget ${WGET_OPTIONS} https://mran.microsoft.com/install/mro/${MRO_VERSION}/RevoMath-${MRO_VERSION}.tar.gz
tar -xvzf RevoMath-${MRO_VERSION}.tar.gz
rm RevoMath-${MRO_VERSION}.tar.gz
sed -i '16,18d' RevoMath/RevoMath.sh

########################
# BLIS - https://github.com/flame/blis - multithread
########################

git clone https://github.com/flame/blis.git
cd blis

./configure --enable-shared auto
make -j `nproc`
cd ..

# install:   mv /opt/MRO-lib/libRblas.so   /opt/MRO-lib/libRblas.so.orig
#            ln -s `find /root/blas-benchmark/blis/ -name "libblis.so"`   /opt/MRO-lib/libRblas.so

# uninstall: rm /opt/MRO-lib/libRblas.so
#            mv /opt/MRO-lib/libRblas.so.orig   /opt/MRO-lib/libRblas.so


############################################################
#                        BLAS GPU                          #
############################################################

########################
# clBLAS - https://github.com/clMathLibraries/clBLAS - OpenCL
########################

git clone https://github.com/clMathLibraries/clBLAS.git

########################
# cuBLAS/NVBLAS - https://developer.nvidia.com/cublas - CUDA
########################

wget ${WGET_OPTIONS} http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda-repo-ubuntu1504-7-5-local_7.5-18_amd64.deb
gdebi -n cuda-repo-ubuntu1504-7-5-local_7.5-18_amd64.deb
rm cuda-repo-ubuntu1504-7-5-local_7.5-18_amd64.deb

############################################################
#                        LAPACK GPU                        #
############################################################

########################
# MAGMA  - http://icl.cs.utk.edu/magma/software/ - multithread GPU OpenCL/CUDA
########################

########################
# CULA - http://www.culatools.com/ - multithread GPU CUDA
########################