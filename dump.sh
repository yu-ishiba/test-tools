#!/bin/bash


if [ $# = 3 ]; then
    DATE=$3
else
    DATE=$(date +%Y%m%d)
fi

tcpdump -r vSRX1b_ge000_${DATE}.pcap| sed -n "/$1/,/$2/p"
echo
tcpdump -r vSRX1b_ge001_${DATE}.pcap| sed -n "/$1/,/$2/p"
