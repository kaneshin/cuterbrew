#!/bin/bash

# File:         install_CGD.sh
# Version:      1.0.0
# Maintainer:   Shintaro Kaneko <kaneshin0120@gmail.com>
# Last Change:  03-Sep-2012.

if [[ $CUTERHOME == "" ]]; then
    echo "There is no \$CUTERHOME which is an environmental variable."
    echo "You must do a \"source .cuterrc\"."
    exit 1
fi

# Set the variables
CGDDIR=CG_DESCENT
CGDVER=5.3
CGDHOME=$CUTERHOME/$CGDDIR
CUTEINTF=$CGDHOME/CUTEr_interface

cd `dirname ${0}`
cp run_cg_descent.sh $CUTERHOME

# Make src directory
dir=`dir $CUTERHOME/src 2>&1`
if [[ $? != 0 ]]; then
    mkdir $CUTERHOME/src
fi

# Get CG_DESCENT archive
cd $CUTERHOME/src
list=`ls | grep CG_DESCENT-C-5.0.tar.gz 2>&1`
if [[ $? != 0 ]]; then
    wget http://www.math.ufl.edu/~hager/papers/CG/Archive/CG_DESCENT-C-$CGDVER.tar.gz
fi

# Install CG_DESCENT
cd $CUTERHOME
tar zxvf src/CG_DESCENT-C-$CGDVER.tar.gz > $CGDDIR.log
c=`dir $CGDDIR 2>&1`
if [[ $? == 0 ]]; then
    rm -rf $CGDDIR
fi
mv CG_DESCENT-C-$CGDVER/ $CGDDIR/
mv CG_DESCENT.log $CGDDIR/

cd $CUTEINTF
cp * $CGDHOME

cd $CUTERHOME
mv run_cg_descent.sh $CGDHOME

