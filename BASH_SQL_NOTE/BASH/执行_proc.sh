#!/usr/bin/sh
. /opt/accapp2/.profile
. $AIOSS_HOME/etc/ai_connect.sh

echo "connect $connect_qhupar1o;
exec prc_pps_reclaim;
quit;" | sqlplus /nolog >> ./prc_pps_reclaim.log