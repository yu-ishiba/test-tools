#!/bin/bash

NFSIP=`/bin/mount | /usr/bin/grep "/var/lib/nova/instances" | /usr/bin/awk '{print substr($0, index($0, ",addr="))}' | /bin/sed 's/,addr=\(.*\))/\1/'`

if [ $? -ne 0 ]; then
    echo "isilon ip get error $NFSIP"
    exit 1
fi

if [ $(($EUID - $UID)) -ne 0 ]; then
    echo "no root user"
    exit 1
fi

/sbin/iptables -L

IPTABLES_A="/sbin/iptables -A OUTPUT -d $NFSIP -j DROP"
IPTABLES_D="/sbin/iptables -D OUTPUT -d $NFSIP -j DROP"

echo -e "\n\n"
eval $IPTABLES_A
if [ $? -eq 0 ]; then
    echo "$(date) $IPTABLES_A"
else
    echo "Warning! iptables -A fail$(date)"
    /sbin/iptables -L
    exit 1
fi

echo -e "\n\n"
/sbin/iptables -L

echo -e "\n\n"
for i in `seq 5`; do sleep 60; echo "$i min $(date)"; done

echo -e "\n\n"
eval $IPTABLES_D
if [ $? -eq 0 ]; then
    echo "$(date) $IPTABLES_D"
else
    echo "Warning! iptables -D fail $(date)"
    /sbin/iptables -L
    exit 1
fi

echo -e "\n\n"
/sbin/iptables -L

