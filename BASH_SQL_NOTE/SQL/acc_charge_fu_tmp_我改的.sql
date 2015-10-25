create or replace procedure acc_charge_fu_tmp
 is
        total_amount1 number(15);
        service_number varchar2(30);
        acc_id NUMBER(9);
        service_type number(4);
        subs_id NUMBER(9);
        reg_id VARCHAR2(10);
        cus_id NUMBER(9);
        subject_id number;
        pay NUMBER(2);
        v_cnt number;
        charge_sql number(15);
        bill_counttmp number;
        v_count number;
        val number;
        v_lastmonth varchar2(12);
        v_sql1 varchar2(4000);
        v_sql2 varchar2(2000);
        L_CURSOR3 sys_refcursor;
        un_mon char(6);
        adjust_type number(2);
       
cursor acc_charge is select t.service_num,t.diff_fee,t.account_id, t.svc_type, t.subscription_id, t.region_id, t.customer_id
,t.subject_id,t.adjust_type
        from DIFF_CHARGE_INFO t
        where  t.stat=5;
begin

    select to_char(add_months(sysdate,-1),'yyyymm') into v_lastmonth  from dual;
  --select to_char(add_months(sysdate,-1),'yyyydd') into v_lastmonth  from dual;
    bill_counttmp:=0;
  /*update DIFF_CHARGE_INFO t set t.remark='please check NO.',t.stat=1 where not exists
  (select service_num from ucs_subscription a where t.service_num=a.service_num
  and sysdate between a.active_date and a.inactive_date);----错误号码
     commit;*/
open acc_charge;
   loop
   fetch acc_charge  into service_number,total_amount1,acc_id,service_type,subs_id,reg_id, cus_id,subject_id,adjust_type;
      exit when acc_charge%notfound;

      begin
         open L_CURSOR3 for select pay_type  from ucs_account t where t.account_id =acc_id;
         fetch L_CURSOR3 into pay;
         if pay is null then
          pay:=18;
         end if;
         begin
            begin
             select bill_count into bill_counttmp  from acc_account_info t where account_id=acc_id ;
             v_sql2:='select count(*)  from   acc_invoice_'||v_lastmonth||' where account_id='||acc_id;
             execute immediate v_sql2 into v_cnt;
                   if(v_cnt=0) then
                    update acc_account_info t set t.bill_count=bill_count+1,t.unsettled_bill_count=unsettled_bill_count+1 
                    where account_id=acc_id ;
                else
                bill_counttmp:=bill_counttmp-1;
                   end if;
             end;

            select seq_acc_charge_scp.nextval into  charge_sql from dual;
         v_sql1:='insert into acc_charge_'||v_lastmonth ||'(CHARGE_SEQ,BATCH_CODE,BUSINESS_CODE,CHARGE_GEN_TYPE,
         ACCOUNT_ID,DEFAULT_ACCOUNT_ID,SVC_TYPE,SUBSCRIPTION_ID,SERVICE_NUM,BILL_COUNT,VALUE_DATE,SUBJECT_ID,SUBJECT_DERIVE_TYPE,TOTAL_AMOUNT,
  DISC_TOTAL_AMOUNT,BALANCE,RES_SUBJECT_ID,RES_RAW_TOTAL,RES_BILL_TOTAL,REPORT_FLAG,STATUS,LAST_STATUS_DATE,
  PAY_STATUS,LAST_PAY_DATE,PAY_TYPE,ACCT_TYPE,CUSTOMER_ID,CUSTOMER_TYPE,REGION_ID,COMPONENT_ID,PACKAGE_ID,
  BRAND_ID,RELE_OFFICE_ID,ACCT_ID)values('||charge_sql||','''',''110200'','||adjust_type||','||acc_id||',
         '||acc_id||','||service_type||','||subs_id||','''||service_number||''','||bill_counttmp||',to_date(to_char(last_day(add_months(sysdate,-1)),''yyyy-mm-dd''),''yyyy-mm-dd''),'||subject_id||'
         ,''0'','||total_amount1||',''0'','||total_amount1||',''0'',''0'',''0'',''0'',''0'',sysdate,''0'',sysdate,'||pay||',''1'',
           '||cus_id||',''0'','''||reg_id||''',''0'',''0'',''0'',''142'','''')';
             execute immediate v_sql1;
             v_count:=0;
             v_sql1:='select count(subscription_id)  from acc_invoice_'||v_lastmonth||' where subscription_id='||subs_id;
             execute immediate v_sql1 into v_count;
             if(v_count=1)  then
              v_sql1:='update acc_invoice_'||v_lastmonth||' t  set t.total_amount=t.total_amount+'||total_amount1||'
               ,t.balance=t.balance+'||total_amount1||' where subscription_id='||subs_id;
               execute immediate  v_sql1;
               else
            select SEQ_ACC_INVOICE.Nextval into val from dual;
             v_sql1:='insert into acc_invoice_'||v_lastmonth||'(INVOICE_SEQ,SUBSCRIPTION_ID,BATCH_CODE,BUSINESS_CODE,BILL_COUNT,ACCOUNT_ID,
  DEFAULT_ACCOUNT_ID,SVC_TYPE,SERVICE_NUM,VALUE_DATE,TOTAL_AMOUNT,ADJUST_AFTERWARDS,DISC_TOTAL_AMOUNT,
  BALANCE,REPORT_FLAG,STATUS,LAST_STATUS_DATE,PAY_STATUS,LAST_PAY_DATE,PRINT_TIMES,CUSTOMER_ID,
  CUSTOMER_TYPE,REGION_ID,PROMOTION_CODE,PAY_TYPE,ACCT_TYPE,PACKAGE_ID,BRAND_ID,RELE_OFFICE_ID)values('||val||','||subs_id||',null,''110200'','||bill_counttmp||','||acc_id||','||acc_id||',
               '||service_type||','''||service_number||''',to_date(to_char(last_day(add_months(sysdate,-1)),''yyyy-mm-dd''),''yyyy-mm-dd''),'||total_amount1||',''0'',''0'','||total_amount1||',''0'',''0'',sysdate,
                ''0'',sysdate,''0'','||cus_id||',''0'','''||reg_id||''',''0'','||pay||',''1'',''0'',''0'',''142'')';
               execute immediate v_sql1;
               update acc_account_info t set t.unsettled_bill_count=t.unsettled_bill_count+1
               where t.account_id=acc_id;
             end if;
             select unsettled_month into un_mon from acc_account_info t where t.account_id=acc_id;
               if un_mon<to_char(sysdate,'yyyymm') then
                 update acc_account_info t set /*t.unsettled_month=v_lastmonth,*/
                 t.unsettled_bill_balance=t.unsettled_bill_balance+total_amount1 where
                 t.account_id=acc_id;
                 commit;
               elsif un_mon=to_char(sysdate,'yyyymm') then
                 update acc_account_info t set t.unsettled_month=v_lastmonth,
                 t.unsettled_bill_balance=t.unsettled_bill_balance+total_amount1 where
                 t.account_id=acc_id;
               end if;
               update DIFF_CHARGE_INFO t set t.stat=0 where account_id=acc_id;---成功更新
               commit;
            exception when others then
               rollback;
               update DIFF_CHARGE_INFO t set t.stat=1 where account_id=acc_id;---失败更新
            end;
        end;  
  end loop;
 close  acc_charge;
 /*负账单调账 charge_gen_type=7  */
 v_sql1:='
 update  acc_charge_'||v_lastmonth||'  set charge_gen_type=7 , pay_status = 13  where  subject_id = 108030  and  total_amount<0 and charge_gen_type >4 and charge_gen_type<>9 and charge_gen_type<>6';
 execute immediate v_sql1;
 commit;
end;
