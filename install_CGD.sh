#!/bin/bash

#===========================================================================
# File: install_CGD.sh
# Version: 0.0.1
# Last Change: 11-Nov-2011.
# Maintainer:  Shintaro Kaneko <kaneshin0120@gmail.com>
# Description:
#   TODO
#===========================================================================

if [[ "$OPTIMHOME" == "" ]]; then
    echo "You must do a \"source .cuterrc\"."
    exit 1
fi

# set variables
CGDDIR=CG_DESCENT
CGDHOME=$OPTIMHOME/$CGDDIR
CUTEINTF=$CGDHOME/CUTEr_interface

cd `dirname ${0}`
cp run_cg_descent.sh $OPTIMHOME

# wget
cd $OPTIMHOME/src
wget http://www.math.ufl.edu/~hager/papers/CG/Archive/CG_DESCENT-C-5.0.tar.gz

# install CG_DESCENT
cd $OPTIMHOME
tar zxvf src/CG_DESCENT-C-5.0.tar.gz 2>&1 > $CGDDIR.log
mv CG_DESCENT-C-5.0/ $CGDDIR/
mv CG_DESCENT.log $CGDDIR/

cd $CUTEINTF
cp * $CGDHOME

cd $OPTIMHOME
mv run_cg_descent.sh $CGDHOME

# EOF
