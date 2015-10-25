#!/usr/bin/env bash
exec_time=`date '+%Y%m%d'`
#cd /accapp2/prog/aioss/bin/
ym=`date +%m" "%Y`
if [ `date +%d` = `cal $ym|xargs|awk '{print $NF}'` ];then
   #socsbalancefilewxj -d ${exec_time} -n 3
   echo "do some apps"
fi