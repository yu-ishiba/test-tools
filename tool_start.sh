#!/bin/bash

CLIENT="10.255.255.2"
SERVER="10.255.255.3"
OUTPUT_PATH="/home/ubuntu/isilon_test/"
TOOL_PATH="/home/ubuntu/"
DATE=$(date +%Y%m%d_%H%M)

TARGET_CL="10.10.1.10"
TARGET_SV="10.10.2.10"
TARGET_VSRX_IF1="10.10.1.12"
TARGET_VSRX_IF2="10.10.2.12"

CL_PING1="NN-1_client_ping1"
CL_HTTP="NN-2_http_get"
CL_PING2="NN-3_client_ping2_IF"
SV_PING1="NN-4_server_ping1"
SV_PING2="NN-5_server_ping2_IF"
SV_SNMP="NN-6_snmp"
SV_API="NN-7_api"

F_CL_PING1="${CL_PING1}_${DATE}.txt"
F_CL_HTTP="${CL_HTTP}_${DATE}.txt"
F_CL_PING2="${CL_PING2}_${DATE}.txt"
F_SV_PING1="${SV_PING1}_${DATE}.txt"
F_SV_PING2="${SV_PING2}_${DATE}.txt"
F_SV_SNMP="${SV_SNMP}_${DATE}.txt"
F_SV_API="${SV_API}_${DATE}.txt"

echo -e "\n#client\n#arp\n" >> ${OUTPUT_PATH}${F_CL_PING1}
/usr/bin/ssh ${CLIENT} /usr/sbin/arp 2>&1 >> ${OUTPUT_PATH}${F_CL_PING1}
echo -e "\n#NN-1 client -> server\n" >> ${OUTPUT_PATH}${F_CL_PING1}
/usr/bin/ssh ${CLIENT} ${TOOL_PATH}ping.sh ${TARGET_SV} 2>&1 >> ${OUTPUT_PATH}${F_CL_PING1} &

echo -e "\n#NN-2 http get\n" >> ${OUTPUT_PATH}${F_CL_HTTP}
/usr/bin/ssh ${CLIENT} ${TOOL_PATH}http.sh ${TARGET_SV} 2>&1 >> ${OUTPUT_PATH}${F_CL_HTTP} &

echo -e "\n#NN-3 client -> IF\n" >> ${OUTPUT_PATH}${F_CL_PING2}
/usr/bin/ssh ${CLIENT} ${TOOL_PATH}ping.sh ${TARGET_VSRX_IF1} 2>&1 >> ${OUTPUT_PATH}${F_CL_PING2} &

echo -e "\n\n#server\n#arp\n" >> ${OUTPUT_PATH}${F_SV_PING1}
/usr/bin/ssh ${SERVER} /usr/sbin/arp 2>&1 >> ${OUTPUT_PATH}${F_SV_PING1}
echo -e "\n#NN-4 server -> client\n" >> ${OUTPUT_PATH}${F_SV_PING1}
/usr/bin/ssh ${SERVER} ${TOOL_PATH}ping.sh ${TARGET_CL} 2>&1 >> ${OUTPUT_PATH}${F_SV_PING1} &

echo -e "\n#NN-5 server -> IF\n" >> ${OUTPUT_PATH}${F_SV_PING2}
/usr/bin/ssh ${SERVER} ${TOOL_PATH}ping.sh ${TARGET_VSRX_IF2} 2>&1 >> ${OUTPUT_PATH}${F_SV_PING2} &

for i in $1 $2; do
    case "$i" in
        "--snmp" ) echo -e "\n#NN-6 snmp\n" >> ${OUTPUT_PATH}${F_SV_SNMP}
                   /usr/bin/ssh ${SERVER} ${TOOL_PATH}snmp.sh community ${TARGET_VSRX_IF2} 2>&1 >> ${OUTPUT_PATH}${F_SV_SNMP} & ;;

        "--api" ) echo -e "\n#NN-7 api\n" >> ${OUTPUT_PATH}${F_SV_API}
                  /usr/bin/ssh ${SERVER} ${TOOL_PATH}api.sh ${TARGET_VSRX_IF2} hogehoge 2>&1 >> ${OUTPUT_PATH}${F_SV_API} & ;;
    esac
done
