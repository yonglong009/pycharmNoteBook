#!/bin/bash
LOG_DIR=/var/log
ROOT_UID=0
if [  "$UID" -ne "$ROOT_UID"  ];then
    echo "Must be root to do it"
    exit 1
fi
cd $LOG_DIR || 
{
    echo "The file $LOG_DIR is not exist"
    exit 1
}    
cat  /dev/null > messages && echo "The Log is cleaned up..."
exit 0