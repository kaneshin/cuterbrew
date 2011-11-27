#!/bin/bash

if [[ "$OPTIMHOME" == "" ]]; then
    echo "You must do a \"source .cuterrc\"."
    exit 1
fi

# 1. Put cg_user.h into $CUTER/common/include
CGD=$OPTIMHOME/CG_DESCENT
cd $CGD
cp cg_user.h $CUTER/common/include
# 2. Put cg_descentma.c into $CUTER/common/src/tools
cp cg_descentma.c  $CUTER/common/src/tools
# 3. In $CUTER/common/src/tools, "gcc -lm -O3 -c cg_descentma.c"
cd $CUTER/common/src/tools
gcc -lm -O3 -c cg_descentma.c
# 4. "cp cg_descentma.o $MYCUTER/double/bin"
cp cg_descentma.o $MYCUTER/double/bin
# 5. In the directory where you put cg_descent, type "make" and then 
#    "cp cg_descent.o $MYCUTER/double/bin"
cd $CGD
make
cp cg_descent.o $MYCUTER/double/bin
# 6. "cp cg_descent.pro $CUTER/build/prototypes"
#    "cp sdcg_descent.pro $CUTER/build/prototypes"
cp cg_descent.pro $CUTER/build/prototypes
cp sdcg_descent.pro $CUTER/build/prototypes
# 7. "cd $MYCUTER/bin"
cd $MYCUTER/bin
# 8. type the following command twice:
#    where "pack" is first "cg_descent" and then "sdcg_descent"
sed -f $MYCUTER/double/config/script.sed $CUTER/build/prototypes/cg_descent.pro > cg_descent
sed -f $MYCUTER/double/config/script.sed $CUTER/build/prototypes/sdcg_descent.pro > sdcg_descent
# 9. "chmod a+x cg_descent" and "chmod a+x sdcg_descent"
chmod a+x cg_descent
chmod a+x sdcg_descent

# ext. delete object files
# rm $CUTER/common/src/tools/cg_descentma.o
# rm $CGD/cg_descent.o
