#!/bin/bash

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

# update R repository url
sed -i -e 's/mran.revolutionanalytics.com/mran.microsoft.com/ig' /usr/lib64/MRO-${MRO_VERSION}/R-${MRO_VERSION}/lib/R/etc/Rprofile.site

# update  R reposritory snapshot day
sed -i -e 's/2016-01-01/2016-04-10/ig' /usr/lib64/MRO-${MRO_VERSION}/R-${MRO_VERSION}/lib/R/etc/Rprofile.site

# install RevoMathUtils
wget ${WGET_OPTIONS} https://mran.microsoft.com/install/mro/${MRO_VERSION}/RevoMath-${MRO_VERSION}.tar.gz
tar -xvzf RevoMath-${MRO_VERSION}.tar.gz

cd RevoMath
sed -i '16,18d' RevoMath.sh

echo 1 | ./RevoMath.sh

cd ..
rm -r RevoMath*
