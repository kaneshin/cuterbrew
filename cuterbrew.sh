#!/bin/bash

# File:         cuterbrew.sh
# Version:      1.0.0
# Maintainer:   Shintaro Kaneko <kaneshin0120@gmail.com>
# Last Change:  12-Sep-2012.

function __make_sure_command()
{
    cmd=`which $1 2>&1`
    if [[ $? != 0 ]]; then
        echo "The CUTEr can't be installed without $1" >&2
        echo "Install $1 first, and then try again." >&2
        exit $?
    fi
}

function __make_directory()
{
    dir=`dir $1 2>&1`
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

function __get_mastsif()
{
    if [[ $1 == "large" ]]; then
        size=$1
    else
        size='small'
    fi
    # get mastsif
    cd $DEST/src
    list=`ls "mastsif_$size.tar.gz" 2>&1`
    if [[ $? != 0 ]]; then
        wget ftp://ftp.numerical.rl.ac.uk/pub/cuter/mastsif_$size.tar.gz
    fi
    cd $DEST
    tar zxvf src/mastsif_$size.tar.gz
}

function cuter_install()
{
    if [[ $1 == "" ]]; then
        DEST=$CUTERHOME/cuter
    else
        DEST=$CUTERHOME/$1
    fi
    __set_environment_variable $DEST

    # Make sure that commands exist
    __make_sure_command csh
    __make_sure_command gcc
    __make_sure_command gfortran

    # Make directories
    __make_directory $DEST
    __make_directory $CUTER
    __make_directory $SIFDEC
    __make_directory $DEST/src

    # Get CUTEr and SifDec archives
    cd $DEST/src
    # cuter.tar.gz
    list=`ls cuter.tar.gz 2>&1`
    if [[ $? != 0 ]]; then
        wget ftp://ftp.numerical.rl.ac.uk/pub/cuter/cuter.tar.gz
    fi
    # sifdec.tar.gz
    list=`ls sifdec.tar.gz 2>&1`
    if [[ $? != 0 ]]; then
        wget ftp://ftp.numerical.rl.ac.uk/pub/sifdec/sifdec.tar.gz
    fi

    # get mastsif
    __get_mastsif small

    # install cuter
    cd $DEST
    tar zxvf src/cuter.tar.gz
    cd $CUTER
    TEMP=$DEST/temp_$RANDOM
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

    # install sifdec
    cd $DEST
    tar zxvf src/sifdec.tar.gz
    cd $SIFDEC
    TEMP=$DEST/temp_$RANDOM
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

    # make .cuterrc
    CUTERRC=$DEST/.cuterrc
    rm -f $CUTERRC
    touch $CUTERRC
    cat > $CUTERRC << _EOF_
export DEST=$DEST
export CUTER=\$DEST/cuter
export MYCUTER=\$CUTER/CUTEr.large.pc.lnx.gfo
export SIFDEC=\$DEST/sifdec
export MYSIFDEC=\$SIFDEC/SifDec.large.pc.lnx.gfo
export MASTSIF=\$DEST/mastsif
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
}

function cuter_uninstall()
{
    rm -rvf $CUTERHOME/$2
}

function cuter_list()
{
    ls -l1 $CUTERHOME
}

function cuter_mastsif()
{
    __get_mastsif $1
}

function __set_environment_variable()
{
    CUTER=$1/cuter
    MYCUTER=$CUTER/CUTEr.large.pc.lnx.gfo
    SIFDEC=$1/sifdec
    MYSIFDEC=$SIFDEC/SifDec.large.pc.lnx.gfo
    MASTSIF=$1/mastsif
}

# main
if [[ $CUTERHOME == "" ]]; then
    CUTERHOME=~/CUTEr
fi
dir=`dir $CUTERHOME 2>&1`
if [[ $? != 0 ]]; then
    mkdir $1
fi

case $1 in
    install )
        cuter_install $2
    ;;
    uninstall )
        cuter_uninstall $2
    ;;
    ls | list )
        cuter_list
    ;;
    mastsif )
        # cuter_mastsif $2
    ;;
    * )
        echo "Require argument"
        echo "  install"
        echo "      install CUTEr and SifDec."
        echo "  uninstall"
        echo "      remove $CUTERHOME."
    ;;
esac
