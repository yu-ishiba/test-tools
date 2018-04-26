#!/bin/bash

CLIENT="10.255.255.2"
SERVER="10.255.255.3"

OUTPUT_PATH="/home/ubuntu/isilon_test/"

kill -9 $(ps auxf | grep ${CLIENT} | grep -v grep | awk '{print $2}')
kill -9 $(ps auxf | grep ${SERVER} | grep -v grep | awk '{print $2}')
/usr/bin/ssh kill -9 $(/usr/bin/ssh ps auxf | grep ${CLIENT} | grep -v grep | awk '{print $2}')
/usr/bin/ssh kill -9 $(/usr/bin/ssh ps auxf | grep ${SERVER} | grep -v grep | awk '{print $2}')

sleep 2

YEAR="$(date +%Y)"
PATTERN=$(ls -tr ${OUTPUT_PATH} | tail -1 | awk '{print substr($0, index($0, "'${YEAR}'"))}')

CL_PING1="NN-1_client_ping1_${PATTERN}"
CL_HTTP="NN-2_http_get_${PATTERN}"
CL_PING2="NN-3_client_ping2_IF_${PATTERN}"
SV_PING1="NN-4_server_ping1_${PATTERN}"
SV_PING2="NN-5_server_ping2_IF_${PATTERN}"
SV_SNMP="NN-6_snmp_${PATTERN}"
SV_API="NN-7_api_${PATTERN}"

if [  -f ${OUTPUT_PATH}${CL_PING1} ]; then
    echo "OK = $(/bin/grep seq= ${OUTPUT_PATH}${CL_PING1}| /usr/bin/wc -l)" >> ${OUTPUT_PATH}${CL_PING1}
else
    echo "###${OUTPUT_PATH}${CL_PING1} not found"
fi

if [  -f ${OUTPUT_PATH}${CL_PING2} ]; then
    echo "OK = $(/bin/grep seq= ${OUTPUT_PATH}${CL_PING2}| /usr/bin/wc -l)" >> ${OUTPUT_PATH}${CL_PING2}
else
    echo "###${OUTPUT_PATH}${CL_PING2} not found"
fi

if [  -f ${OUTPUT_PATH}${SV_PING1} ]; then
    echo "OK = $(/bin/grep seq= ${OUTPUT_PATH}${SV_PING1}| /usr/bin/wc -l)" >> ${OUTPUT_PATH}${SV_PING1}
else
    echo "###${OUTPUT_PATH}${SV_PING1} not found"
fi

if [  -f ${OUTPUT_PATH}${SV_PING2} ]; then
    echo "OK = $(/bin/grep seq= ${OUTPUT_PATH}${SV_PING2}| /usr/bin/wc -l)" >> ${OUTPUT_PATH}${SV_PING2}
else
    echo "###${OUTPUT_PATH}${SV_PING2} not found"
fi

if [  -f ${OUTPUT_PATH}${CL_HTTP} ]; then
    echo "OK = $(/bin/grep "HTTP_CODE: 200" ${OUTPUT_PATH}${CL_HTTP}| /usr/bin/wc -l)" >> ${OUTPUT_PATH}${CL_HTTP}
else
    echo "###${OUTPUT_PATH}${CL_HTTP} not found"
fi

if [  -f ${OUTPUT_PATH}${SV_SNMP} ]; then
    echo "OK = $(/bin/grep "Gauge32:" ${OUTPUT_PATH}${SV_SNMP}| /usr/bin/wc -l)" >> ${OUTPUT_PATH}${SV_SNMP}
else
    echo "###${OUTPUT_PATH}${SV_SNMP} not found"
fi

if [  -f ${OUTPUT_PATH}${SV_API} ]; then
    echo "OK = $(/bin/grep "HTTP_CODE: 200" ${OUTPUT_PATH}${SV_API}| /usr/bin/wc -l)" >> ${OUTPUT_PATH}${SV_API}
else
    echo "###${OUTPUT_PATH}${SV_API} not found"
fi


cat ${OUTPUT_PATH}*${PATTERN}
echo
${OUTPUT_PATH}/arp.sh
echo -e "\n${PATTERN%.*}"
