#!/bin/bash

# File:         install_CUTEr_SifDec.sh
# Version:      1.0.0
# Maintainer:   Shintaro Kaneko <kaneshin0120@gmail.com>
# Last Change:  03-Sep-2012.

# Set the variables
function set_environment_variable()
{
    CUTER=$1/cuter
    MYCUTER=$CUTER/CUTEr.large.pc.lnx.gfo
    SIFDEC=$1/sifdec
    MYSIFDEC=$SIFDEC/SifDec.large.pc.lnx.gfo
    MASTSIF=$1/mastsif
}
if [[ $CUTERHOME == "" ]]; then
    CUTERHOME=~/CUTEr
fi
set_environment_variable $CUTERHOME

function make_sure_command()
{
    cmd=`which $1 2>&1`
    if [[ $? != 0 ]]; then
        echo "The CUTEr can't be installed without $1" >&2
        echo "Install $1 first, and then try again." >&2
        exit $?
    fi
}

function make_directory()
{
    dir=`ls $1 2>&1`
    if [[ $? == 0 ]]; then
        yesno=""
        while [[ $yesno != "Y" ]] && [[ $yesno != "N" ]]; do
            echo ""
            echo " -------------------------------------------------------"
            echo "$1 exists on your PC." >&2
            echo -n "Do you want to remove $1 [Y/n]? "
            read yesno
            if [[ "$yesno" == "" ]]; then
                yesno="Y"
            fi
            yesno=`echo $yesno | tr '[a-z]' '[A-Z]'`
        done
        if [[ "$yesno" == "Y" ]]; then
            rm -rf $1
        fi
    else
        mkdir $1
    fi
}

case $1 in
    install )
        # Make sure that csh exists
        make_sure_command csh

        # Make sure that gcc exists
        make_sure_command gcc

        # Make sure that gfortran exists
        make_sure_command gfortran

        # Make CUTEr directory
        make_directory $CUTERHOME

        # Make cuter directory
        make_directory $CUTER

        # Make sifdec directory
        make_directory $SIFDEC

        # Make src directory
        make_directory $CUTERHOME/src

        # Get CUTEr and SifDec archives
        cd $CUTERHOME/src
        # cuter.tar.gz
        list=`ls | grep cuter.tar.gz 2>&1`
        if [[ $? != 0 ]]; then
            wget ftp://ftp.numerical.rl.ac.uk/pub/cuter/cuter.tar.gz
        fi
        # sifdec.tar.gz
        list=`ls | grep sifdec.tar.gz 2>&1`
        if [[ $? != 0 ]]; then
            wget ftp://ftp.numerical.rl.ac.uk/pub/sifdec/sifdec.tar.gz
        fi

        # Get SIF small
        yesno=""
        while [[ $yesno != "Y" ]] && [[ $yesno != "N" ]]; do
            echo ""
            echo " -------------------------------------------------------"
            echo -n "Do you want to download a SIF(small) [Y/n]? "
            read yesno
            if [[ "$yesno" == "" ]]; then
                yesno="Y"
            fi
            yesno=`echo $yesno | tr '[a-z]' '[A-Z]'`
        done
        if [[ "$yesno" == "Y" ]]; then
            cd $CUTERHOME/src
            wget ftp://ftp.numerical.rl.ac.uk/pub/cuter/mastsif_small.tar.gz
            cd $CUTERHOME
            tar zxvf src/mastsif_small.tar.gz
        fi
        # Get SIF large
        yesno=""
        while [[ $yesno != "Y" ]] && [[ $yesno != "N" ]]; do
            echo ""
            echo " -------------------------------------------------------"
            echo -n "Do you want to download a SIF(large) [Y/n]? "
            read yesno
            if [[ "$yesno" == "" ]]; then
                yesno="Y"
            fi
            yesno=`echo $yesno | tr '[a-z]' '[A-Z]'`
        done
        if [[ "$yesno" == "Y" ]]; then
            cd $CUTERHOME/src
            wget ftp://ftp.numerical.rl.ac.uk/pub/cuter/mastsif_large.tar.gz
            cd $CUTERHOME
            tar zxvf src/mastsif_large.tar.gz
        fi

        # Install sifdec
        cd $CUTERHOME
        tar zxvf src/sifdec.tar.gz
        cd $SIFDEC
        CUTERTEMP=$CUTERHOME/temp_$RANDOM
        touch $CUTERTEMP
        echo '5' >> $CUTERTEMP       # Select platform => (5) PC
        echo '11' >> $CUTERTEMP      # Select Fortran compiler => [11] GNU gfortran
        echo 'D' >> $CUTERTEMP       # Set install precision => D=double
        echo 'L' >> $CUTERTEMP       # Set install size => L=large
        echo 'Y' >> $CUTERTEMP       # SifDec will be installed in $SIFDEC => Y=Yes
        echo 'Y' >> $CUTERTEMP       # install_mysifdec will be run in $MYSIFDEC => Y=Yes
        echo 'Y' >> $CUTERTEMP       # make all in $MYSIFDEC => Y=Yes
        ./install_sifdec < $CUTERTEMP
        rm -f $CUTERTEMP

        # Install cuter
        cd $CUTERHOME
        tar zxvf src/cuter.tar.gz
        cd $CUTER
        CUTERTEMP=$CUTERHOME/temp_$RANDOM
        touch $CUTERTEMP
        echo '5' >> $CUTERTEMP       # Select platform => (5) PC
        echo '7' >> $CUTERTEMP       # Select Fortran compiler => [7 ] GNU gfortran
        echo '2' >> $CUTERTEMP       # Select C compiler => [2 ] GNU gcc
        echo 'D' >> $CUTERTEMP       # Set install precision => D=double
        echo 'L' >> $CUTERTEMP       # Set install size => L=large
        echo 'Y' >> $CUTERTEMP       # CUTEr will be installed in $CUTER => Y=Yes
        echo 'Y' >> $CUTERTEMP       # install_mycuter will be run in $MYCUTER => Y=Yes
        echo 'Y' >> $CUTERTEMP       # make all in $MYCUTER => Y=Yes
        ./install_cuter < $CUTERTEMP
        rm -f $CUTERTEMP

        # Make .cuterrc
        CUTERRC=$CUTERHOME/.cuterrc
        rm -f $CUTERRC
        touch $CUTERRC
        cat > $CUTERRC << _EOF_
export CUTERHOME=$CUTERHOME
export CUTER=\$CUTERHOME/cuter
export MYCUTER=\$CUTER/CUTEr.large.pc.lnx.gfo
export SIFDEC=\$CUTERHOME/sifdec
export MYSIFDEC=\$SIFDEC/SifDec.large.pc.lnx.gfo
export MASTSIF=\$CUTERHOME/mastsif
export PATH=\$PATH:\$MYCUTER/bin:\$MYCUTER/double/bin
export PATH=\$PATH:\$MYSIFDEC/bin:\$MYSIFDEC/double/bin
export MANPATH=\$MANPATH:\$CUTER/common/man:\$SIFDEC/common/man
export LIBPATH=\$LIBPATH:\$MYCUTER/double/lib
_EOF_

        # Using .cuterrc
        echo "Create \"$CUTERRC\" which must run CUTEr and SidDec."
        echo "You write down \"source $CUTERRC\" on your .zshrc or .bashrc."
        echo " -------------------------------------------------------"
        echo " --- @INC $CUTERRC ---"
        cat $CUTERRC
    ;;
    uninstall )
        rm -rvf $CUTERHOME
    ;;
    * )
        echo "Require argument"
        echo "  install"
        echo "      install CUTEr and SifDec."
        echo "  uninstall"
        echo "      remove $CUTERHOME."
    ;;
esac

