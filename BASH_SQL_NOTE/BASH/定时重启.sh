#!/bin/bash
while true
do
  NOWIP=`/sbin/ifconfig eth0 | grep 'inet addr' | cut -d : -f2 | awk '{print $1}'`
  if [ $NOWIP != '192.168.2.20' ] ; then
      /sbin/ifconfig eth0 192.168.2.20/24
      /sbin/ifconfig eth0 up
      /sbin/route add default gw 192.168.2.1
      echo -e 'nameserver 192.168.2.1\nnameserver 202.106.0.20' > /etc/resolv.conf
  fi
  PNUM=`netstat -anptl | grep :80 | wc -l`
  if [ $PNUM  -eq 0 ] ; then
      /etc/init.d/httpd start
  fi
  sleep 5m
done