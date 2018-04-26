#!/bin/bash
 
TARGET=$1
PW=$2
SLEEP=1
SEQ=1
#TEST_PATH="/home/ubuntu"
#DATE=$(date +%Y%m%d_%H%M)
#LOG_FILE="vSRX_api_log_${DATE}.txt"
 
#while :; do /usr/bin/curl -isS http://${TARGET}:3000/rpc/ -H "Accept: application/xml" -u "root:${PW}" -d "<get-system-uptime-information/>" -w "$(date) vSRX_API $TARGET HTTP_CODE: %{http_code}\n" -o /dev/null >>${TEST_PATH}/${LOG_FILE} 2>&1; sleep 1; done &

while :; do /usr/bin/curl -isS http://${TARGET}:3000/rpc/ -H "Accept: application/xml" -u "root:${PW}" -d "<get-system-uptime-information/>" -w "$(date) vSRX_API $TARGET seq=$SEQ HTTP_CODE: %{http_code}\n" -o /dev/null 2>&1; SEQ=$(( SEQ + 1 )); sleep $SLEEP; done

