#!/usr/bin/sh
#############################  Usage:$0  #########################################
############################# BSS2OCS_FLOW_BALANCE.sql  -->每月执行的*.sql文件######  
. /opt/accapp2/.profile
. $AIOSS_HOME/etc/ai_connect.sh

billcycle=`date +'%Y%m%d'`
file=BSS2OCS_FLOW_BALANCE_$billcycle.txt

##echo "
##create table qhuinv1o.bss2ocs_flow_balance as select * from qhucrm1o.pbill_variant_res_used@crmdb where 1=2;">aaa.sql
##str_sql=`echo "connect $connect_qhuinv1o;";cat ./aaa.sql`
##nohup echo "$str_sql"|sqlplus /nolog;

##--   导入内存库流量卡相关两个表，used、date 作为当月 bss2ocs 前流量账本备份！！！
sh /accapp2/prog/aioss/shell/mayl/load_pbill_variant_res_date.sh
echo "load over1111111111111111111111111111111111111"
#------select * from qhucrm1o.pbill_variant_res_date;
sh /accapp2/prog/aioss/shell/mayl/load_bill_recharge_resource.sh
#------select * from qhucrm1o.bill_recharge_resource;
echo "load over2222222222222222222222222222222222222"

echo "=============================begin, BSS2OCS_FLOW_BALANCE_INSERT2INV =============================="
echo "
truncate table qhuinv1o.bss2ocs_flow_balance;
insert into qhuinv1o.bss2ocs_flow_balance select * from qhucrm1o.pbill_variant_res_used@crmdb t where t.subscription_id in (
select subscription_id from qhucrm1o.bms_subs_svc_chg_log@crmdb t where t.service_type1='1001'
and t.flag='3') and t.current_amount>0;">BSS2OCS_FLOW_BALANCE_INSERT2INV.sql
str_sql=`echo "connect $connect_qhuinv1o;";cat ./BSS2OCS_FLOW_BALANCE_INSERT2INV.sql`
nohup echo "$str_sql"|sqlplus /nolog;

echo "
update bss2ocs_flow_balance t set t.refund_type=decode(t.component_id,170449,1,170450,1,170451,1,170452,1,170453,0,'');">BSS2OCS_FLOW_BALANCE_INSERT2INV.sql
str_sql=`echo "connect $connect_qhuinv1o;";cat ./BSS2OCS_FLOW_BALANCE_INSERT2INV.sql`
nohup echo "$str_sql"|sqlplus /nolog;

echo "
truncate table qhuinv1o.bss2ocs_flow_balance_;
commit;
insert into qhuinv1o.bss2ocs_flow_balance_
select a.subscription_id,a.refund_res,a.component_id,a.book_id,a.current_amount,a.refund_type,to_date(b.effect_date,'YYYY/MM/DD HH24:MI:SS'),to_date(b.expire_date,'YYYY/MM/DD HH24:MI:SS') from qhuinv1o.bss2ocs_flow_balance a,qhucrm1o.pbill_variant_res_date@crmdb b where a.subscription_id=b.subscription_id and a.refund_res=b.refund_res and a.book_id=b.book_id and a.refund_type=b.refund_type
union
select a.subscription_id,a.refund_res,a.component_id,a.book_id,a.total_amount,a.refund_type,to_date(b.effect_date,'YYYY/MM/DD HH24:MI:SS'),to_date(b.expire_date,'YYYY/MM/DD HH24:MI:SS') from qhucrm1o.bill_recharge_resource@crmdb a,qhucrm1o.pbill_variant_res_date@crmdb b where not exists(select 1 from qhuinv1o.bss2ocs_flow_balance where a.subscription_id=subscription_id and a.refund_res=refund_res and a.book_id=book_id and a.refund_type=refund_type) and a.subscription_id=b.subscription_id and a.refund_res=b.refund_res and a.book_id=b.book_id and a.refund_type=b.refund_type and to_date(b.expire_date,'YYYY/MM/DD HH24:MI:SS')>sysdate;
commit;">BSS2OCS_FLOW_BALANCE_ALL.sql
str_sql=`echo "connect $connect_qhuinv1o;";cat ./BSS2OCS_FLOW_BALANCE_ALL.sql`
nohup echo "$str_sql"|sqlplus /nolog;

echo "
update bss2ocs_flow_balance_ t set t.refund_type=decode(t.component_id,170449,1,170450,1,170451,1,170452,1,170453,0,'');">BSS2OCS_FLOW_BALANCE_INSERT2INV.sql
str_sql=`echo "connect $connect_qhuinv1o;";cat ./BSS2OCS_FLOW_BALANCE_INSERT2INV.sql`
nohup echo "$str_sql"|sqlplus /nolog;

echo "=============================begin, SPOOL: BSS2OCS_FLOW_BALANCE_$billcycle.txt ===================="
echo "
set termout off
set pagesize 0
set echo off
set heading off
set term off
set feedback off
set linesize 150
spool ./${file}
select  rownum||'|'||to_char(sysdate,'yyyymmdd')||'|'||k.service_num||'|'||t.subscription_id||'|'||k.account_id||'|'||decode(t.component_id,170449,21001,170450,21005,170451,21010,170452,21450,170453,22010,0)||'|'||t.total_amount*1024||'|'||to_char(t.effect_date,'yyyymmddHH24miss')||'|'||to_char(t.expire_date,'yyyymmddHH24miss')||'|'||t.refund_type
from qhuinv1o.bss2ocs_flow_balance_ t,qhucrm1o.ucs_subscription@crmdb k where t.subscription_id=k.subscription_id and sysdate between k.active_date and k.inactive_date;
spool off;
exit;
">./BSS2OCS_FLOW_BALANCE.sql
str_sql=`echo "connect $connect_qhuinv1o;";cat ./BSS2OCS_FLOW_BALANCE.sql`
nohup echo "$str_sql"|sqlplus /nolog;

./del_head_tail_line.sh $file 2 1 $file
sleep 1
line=`cat ${file}|wc -l`
echo $line


echo "=============begin ftp_puts: BSS2OCS_FLOW_BALANCE_$billcycle.txt =============================="
#ftp   -i -n -v  <<EOF
#open 135.225.1.110
#user bssbatch 39FkS_23_Wh
#cd  BeforeAC
#bin
#prompt off
#put $file
#bye
#EOF

echo "============begin update, 设置内存库流量卡 bss2ocs 剩余使用量为0, 还有删除date表中refund_type=1的记录！！！删除resource！ =============================="
echo "
set termout off
set pagesize 0
set echo off
set heading off
set term off
set feedback off
set linesize 150
spool ./BSS2OCS_FLOW_BALANCE_update_alti_0.sql
select 
distinct 'delete from pbill_variant_res_date where SUBSCRIPTION_ID='||t.SUBSCRIPTION_ID||';'||chr(13)||'commit;'||chr(13)||'delete from bill_recharge_resource where SUBSCRIPTION_ID='||t.SUBSCRIPTION_ID||';'||chr(13)||'commit;'||chr(13)||'delete from pbill_variant_res_used where SUBSCRIPTION_ID='||t.SUBSCRIPTION_ID||';'||chr(13)||'commit;' from  qhuinv1o.bss2ocs_flow_balance_ t;
spool off;
exit;
">./BSS2OCS_FLOW_BALANCE_update_alti.sql
str_sql=`echo "connect $connect_qhuinv1o;";cat ./BSS2OCS_FLOW_BALANCE_update_alti.sql`
nohup echo "$str_sql"|sqlplus /nolog;

#cat BSS2OCS_FLOW_BALANCE_update_alti_0.sql |$ALTIBASE_HOME/bin/isql -s 130.70.1.120 -port 20300 -NLS_USE US7ASCII -u bss  -p $connect_altibase