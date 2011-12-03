#!/bin/bash

#===========================================================================
# File: install_CUTEr_SifDec.sh
# Version: 0.1.0
# Last Change: 03-Dec-2011.
# Maintainer:  Shintaro Kaneko <kaneshin0120@gmail.com>
# Description:
#   This program is the auto running installation for CUTEr and SifDec.
#   You must install bash, csh, gcc and gfortran on your PC beforehand.
#   This software license is The MIT License.
#===========================================================================

# set variables
OPTIMHOME=~/optim
## for cuter
CUTER=$OPTIMHOME/cuter
MYCUTER=$CUTER/CUTEr.large.pc.lnx.gfo
## for sifdec
SIFDEC=$OPTIMHOME/sifdec
MYSIFDEC=$SIFDEC/SifDec.large.pc.lnx.gfo
## for mastsif
MASTSIF=$OPTIMHOME/mastsif

# make sure that csh exists
csh=`which csh 2>&1`
ret=$?
if [ $ret -eq 0 ] && [ -x "$csh" ]; then
    (exit 0)
else
    echo "CUTEr and SifDec can't be installed without csh." >&2
    echo "Install csh first, and then try again." >&2
    exit $ret
fi

# make sure that gcc exists
gcc=`which gcc 2>&1`
ret=$?
if [ $ret -eq 0 ] && [ -x "$gcc" ]; then
    (exit 0)
else
    echo "CUTEr can't be installed without gcc." >&2
    echo "Install gcc first, and then try again." >&2
    exit $ret
fi

# make sure that gfortran exists
gfortran=`which gfortran 2>&1`
ret=$?
if [ $ret -eq 0 ] && [ -x "$gfortran" ]; then
    (exit 0)
else
    echo "CUTEr and SifDec can't be installed without gfortran." >&2
    echo "Install gfortran first, and then try again." >&2
    exit $ret
fi


# CUTEr directory
optim=`dir $OPTIMHOME 2>&1`
ret=$?
if [ $ret -eq 0 ]; then
    yesno=""
    while [[ $yesno != "Y" ]] && [[ $yesno != "N" ]]; do
        echo "$OPTIMHOME exists on your PC." >&2
        echo -n "Do you want to finish [Y/n]? "
        read yesno
        if [[ "$yesno" == "" ]]; then
            yesno="Y"
        fi
        yesno=`echo $yesno | tr '[a-z]' '[A-Z]'`
    done
    if [[ "$yesno" == "Y" ]]; then
        exit 1
    fi
else
    mkdir $OPTIMHOME
fi
optimsrc=`dir $OPTIMHOME/src 2>&1`
ret=$?
if [ $ret -eq 0 ]; then
    yesno=""
    while [[ $yesno != "Y" ]] && [[ $yesno != "N" ]]; do
        echo "$OPTIMHOME/src exists on your PC." >&2
        echo -n "Do you want to finish [Y/n]? "
        read yesno
        if [[ "$yesno" == "" ]]; then
            yesno="Y"
        fi
        yesno=`echo $yesno | tr '[a-z]' '[A-Z]'`
    done
    if [[ "$yesno" == "Y" ]]; then
        exit 1
    fi
else
    mkdir $OPTIMHOME/src
fi
# wget
cd $OPTIMHOME/src
# CUTEr
wget ftp://ftp.numerical.rl.ac.uk/pub/cuter/cuter.tar.gz
# SifDec
wget ftp://ftp.numerical.rl.ac.uk/pub/sifdec/sifdec.tar.gz

# download SIF files
# SIF small
yesno=""
while [[ $yesno != "Y" ]] && [[ $yesno != "N" ]]; do
    echo -n "Do you want to download a SIF(small) [Y/n]? "
    read yesno
    if [[ "$yesno" == "" ]]; then
        yesno="Y"
    fi
    yesno=`echo $yesno | tr '[a-z]' '[A-Z]'`
done
if [[ "$yesno" == "Y" ]]; then
    cd $OPTIMHOME/src
    wget ftp://ftp.numerical.rl.ac.uk/pub/cuter/mastsif_small.tar.gz
    cd $OPTIMHOME
    tar zxvf src/mastsif_small.tar.gz
fi
# SIF large
yesno=""
while [[ $yesno != "Y" ]] && [[ $yesno != "N" ]]; do
    echo -n "Do you want to download a SIF(large) [Y/n]? "
    read yesno
    if [[ "$yesno" == "" ]]; then
        yesno="Y"
    fi
    yesno=`echo $yesno | tr '[a-z]' '[A-Z]'`
done
if [[ "$yesno" == "Y" ]]; then
    cd $OPTIMHOME/src
    wget ftp://ftp.numerical.rl.ac.uk/pub/cuter/mastsif_large.tar.gz
    cd $OPTIMHOME
    tar zxvf src/mastsif_large.tar.gz
fi

# install sifdec
cd $OPTIMHOME
tar zxvf src/sifdec.tar.gz
cd $SIFDEC
TEMP=~/__temp_$RANDOM
touch $TEMP
echo '5' >> $TEMP       # Select platform => (5) PC
echo '11' >> $TEMP      # Select Fortran compiler => [11] GNU gfortran
echo 'D' >> $TEMP       # Set install precision => D=double
echo 'L' >> $TEMP       # Set install size => L=large
echo 'Y' >> $TEMP       # SifDec will be installed in $SIFDEC => Y=Yes
echo 'Y' >> $TEMP       # install_mysifdec will be run in $MYSIFDEC => Y=Yes
echo 'Y' >> $TEMP       # make all in $MYSIFDEC => Y=Yes
./install_sifdec < $TEMP
rm -f $TEMP

# install cuter
cd $OPTIMHOME
tar zxvf src/cuter.tar.gz
cd $CUTER
TEMP=~/__temp_$RANDOM
touch $TEMP
echo '5' >> $TEMP       # Select platform => (5) PC
echo '7' >> $TEMP       # Select Fortran compiler => [7 ] GNU gfortran
echo '2' >> $TEMP       # Select C compiler => [2 ] GNU gcc
echo 'D' >> $TEMP       # Set install precision => D=double
echo 'L' >> $TEMP       # Set install size => L=large
echo 'Y' >> $TEMP       # CUTEr will be installed in $CUTER => Y=Yes
echo 'Y' >> $TEMP       # install_mycuter will be run in $MYCUTER => Y=Yes
echo 'Y' >> $TEMP       # make all in $MYCUTER => Y=Yes
./install_cuter < $TEMP
rm -f $TEMP

# TODO
#   echo Using
CUTERRC=$OPTIMHOME/.cuterrc
cat > $CUTERRC << _EOF_
export OPTIMHOME=$OPTIMHOME
export CUTER=\$OPTIMHOME/cuter
export MYCUTER=\$CUTER/CUTEr.large.pc.lnx.gfo
export SIFDEC=\$OPTIMHOME/sifdec
export MYSIFDEC=\$SIFDEC/SifDec.large.pc.lnx.gfo
export MASTSIF=\$OPTIMHOME/mastsif
export PATH=\$PATH:\$MYCUTER/bin:\$MYCUTER/double/bin
export PATH=\$PATH:\$MYSIFDEC/bin:\$MYSIFDEC/double/bin
export MANPATH=\$MANPATH:\$CUTER/common/man:\$SIFDEC/common/man
export LIBPATH=\$LIBPATH:\$MYCUTER/double/lib
_EOF_

# EOF
