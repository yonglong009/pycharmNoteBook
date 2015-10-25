#!/bin/bash



##########################################################
preMonth()
{
 sav_months=`echo $2`;
 year=`echo $1|cut -c 1-4`
 month=`echo $1 | cut -c 5-6`
  #day=`echo $1 | cut -c 7-8`
 mm=`echo "$sav_months + 1"|bc`
  if [ $month -lt $mm ]; then
   month=`expr $month + 12 - $sav_months`
   year=`expr $year - 1 `
  else
   month=`expr $month - $sav_months`
  fi
   DATE=`printf "%04s%02s" $year $month`
  return $DATE;
}

DATE=`date +%C%y\%m`;

# {$2} 月之前
preMonth $DATE 1;
gzipdate=`echo $DATE | sed s/[^0-9]//g`
echo "------------------billcycle:-------------------"
echo $DATE
echo $gzipdate
billcycle=$DATE
##########################################################
