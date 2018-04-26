#!/bin/bash

OID="1.3.6.1.4.1.2636.3.1.13.1.8.9.1.0.0"
DIR="/home/ubuntu/"
 
#NUM=$1
#OCT=$(( ${NUM} + 150 ))
#TARGET="10.10.1.${OCT}"
#DATE=$(date +%Y%m%d_%H%M)
#LOG_FILE="vSRX_snmp_log_${DATE}.txt"
#FILE_PATH=/home/ubuntu
TARGET=$1
COMMUNITY=$2
SLEEP=1
SEQ=1
 
#while :; do 
#    echo -n "$(date) vSRX_snmpget $TARGET ">>${DIR}${LOG_FILE}; 
#    /usr/bin/snmpget -c $COMMUNITY -v2c $TARGET $OID >>${FILE_PATH}/${LOG_FILE} 2>&1; 
#    if [ $? -ne 0 ]; then
#        exit 1
#    fi
#    sleep $SLEEP; 
#done &

while :; do 
    echo -n "$(date) vSRX_snmpget $TARGET seq=$SEQ "; 
    /usr/bin/snmpget -c $COMMUNITY -v2c $TARGET $OID 2>&1; 
    SEQ=$(( SEQ + 1 ))
    sleep $SLEEP; 
done 
