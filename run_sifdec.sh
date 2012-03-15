#!/bin/bash

LOG=result.log
rm -f $LOG
touch $LOG

SDFILE=("3PK" "BRYBND" "VARDIM" "PORTSQP")
for (( i = 0; i < ${#SDFILE[@]}; i++ ))
do
    echo ${SDFILE[$i]}
    echo -e "\n${SDFILE[$i]}\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> $LOG
    date >> $LOG
    sdcg_descent ${SDFILE[$i]} 2>&1 >> $LOG
done

echo ""
echo "ALL FINISH"
echo "log file is \"$LOG\"."

