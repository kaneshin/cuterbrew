#!/bin/bash

#===========================================================================
# File: install_CGD.sh
# Version: 0.0.1
# Last Change: 11-Nov-2011.
# Maintainer:  Shintaro Kaneko <kaneshin0120@gmail.com>
# Description:
#===========================================================================

if [[ "$WORKHOME" == "" ]]; then
    echo "You must do a \"source .cuterrc\"."
    exit 1
fi

# set variables
CGDDIR=CG_DESCENT
CGDHOME=$WORKHOME/$CGDDIR
CUTEINTF=$CGDHOME/CUTEr_interface

cd `dirname ${0}`
cp run_cg_descent.sh $WORKHOME

# make src directory
s=`dir $WORKHOME/src 2>&1`
if [[ $? != 0 ]]; then
    mkdir $WORKHOME/src
fi

# wget
cd $WORKHOME/src
list=`ls | grep CG_DESCENT-C-5.0.tar.gz 2>&1`
if [[ $? != 0 ]]; then
    wget http://www.math.ufl.edu/~hager/papers/CG/Archive/CG_DESCENT-C-5.0.tar.gz
fi

# install CG_DESCENT
cd $WORKHOME
tar zxvf src/CG_DESCENT-C-5.0.tar.gz > $CGDDIR.log
c=`dir $CGDDIR 2>&1`
if [[ $? == 0 ]]; then
    rm -rf $CGDDIR
fi
mv CG_DESCENT-C-5.0/ $CGDDIR/
mv CG_DESCENT.log $CGDDIR/

cd $CUTEINTF
cp * $CGDHOME

cd $WORKHOME
mv run_cg_descent.sh $CGDHOME

# EOF
