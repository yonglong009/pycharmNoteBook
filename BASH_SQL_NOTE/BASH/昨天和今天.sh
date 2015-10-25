#!/usr/bin/env bash
year=`date '+%Y'`
month=`date '+%m'`
date=`date '+%d'`
date=`expr $date - 1`
if [ $date -eq 0 ] 
then
        month=`expr $month - 1`
        if [ $month -eq 0 ] 
        then
                year=`expr $year - 1`
                month=12
        fi
        case $month in
        1|3|5|7|8|10|12) 
                date=31
        ;;
        2)
                flag=$((year%4==0&&year%100!=0||year%400==0))
                if [ $flag -eq 1 ]
                then
                        date=29
                else
                        date=28
                fi
        ;;
        4|6|9|11)
                date=30
        ;;
        esac
fi
month=`echo $month |awk '{printf "%02s",$1}'`
date=`echo $date |awk '{printf "%02s",$1}'`
predate=$year-$month-$date
nowdate=`date '+%Y%m%d'`

echo $predate
echo $nowdate