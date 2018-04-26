#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: ping.sh TARGET"
    exit 1
fi

TARGET=$1
/bin/ping -W 1 $TARGET 2>&1 | while read pi; do echo "$(date '+[%Y/%m/%d_%H:%M:%S_UTC]') $(hostname) $pi"; done
