---表空间使用率真  95.65%
select a.tablespace_name 表空间,
       a.total_bytes     总计,
       a.total_bytes - nvl(b.free_bytes, 0)     已使用,
       round((a.total_bytes - nvl(b.free_bytes, 0)) / a.total_bytes, 4) * 100 || '%' 已使用百分比,
       nvl(b.free_bytes, 0)    剩余,
       round(nvl(b.free_bytes, 0) / a.total_bytes, 4) * 100 || '%' 剩余百分比
from (select df.tablespace_name, sum(df.bytes) / 1024 / 1024 Total_bytes
          from dba_data_files df
         group by df.tablespace_name) a,
       (select fs.tablespace_name, sum(fs.bytes) / 1024 / 1024 Free_bytes
          from dba_free_space fs
         group by fs.tablespace_name) b
where a.tablespace_name = b.tablespace_name(+)
  --and round((a.total_bytes - nvl(b.free_bytes, 0)) / a.total_bytes, 4) * 100 >=90
 --and  a.tablespace_name = 'TS_BILL_GSM_BILL_10M_02'
order by round(nvl(b.free_bytes, 0) / a.total_bytes, 4) * 100




---查看表空间有哪些表
select owner,segment_name,sum(bytes)/1024/1024/1024 from dba_segments where --owner='QHUPAR1O'
tablespace_name='TS_BILL_USER_TEMP_10M_01'
group by owner,segment_name
order by sum(bytes)/1024/1024/1024 desc

SELECT 'alter table ' ||'QHUPAR1O.'||t1.TABLE_NAME || ' move partition ' ||
       t2.PARTITION_NAME || ' tablespace TS_BILL_GSM_BILL_10M_01;'
  FROM DBA_TABLES t1, DBA_SEGMENTS t2
 WHERE t1.TABLE_NAME = t2.segment_name
   AND t2.tablespace_name = 'TS_BILL_NGN_BILL_10M_IDX_02'
   and t1.table_name = 'DR_SCPSMS_201304'
   AND T2.segment_type='TABLE PARTITION';
--重建索引
    ALTER INDEX  DR_GPRS_201306_S_BILL  REBUILD PARTITION APART TABLESPACE TS_BILL_GSM_BILL_10M_01 parallel 1 nologging;
    ALTER INDEX  IDX_DR_SCPG_201305_BEGIN_DATE  REBUILD PARTITION APART TABLESPACE TS_BILL_GSM_BILL_10M_02 parallel 1 nologging;
    ALTER INDEX  IDX_DR_SCPG_201304_BEGIN_DATE  REBUILD PARTITION APART TABLESPACE TS_BILL_GSM_BILL_10M_02 parallel 1 nologging;
        select 'ALTER INDEX  '|| SEGMENT_NAME||'  REBUILD PARTITION '||PARTITION_NAME||' TABLESPACE TS_BILL_GSM_BILL_10M_02 parallel 1 nologging;'
     from Dba_Segments where tablespace_name = 'TS_BILL_SCP_BILL_2M_01'  and   segment_type like 'INDEX%'
--重建索引  无分区
     select 'ALTER INDEX  '|| SEGMENT_NAME||'  REBUILD TABLESPACE TS_BILL_GSM_SMS_10M_IDX_02 nologging;',sum(bytes)/1024/1024/1024
     from Dba_Segments where tablespace_name = 'TS_BILL_SCP_BILL_2M_01'  and   segment_type like 'INDEX%'
     and segment_name like 'IDX%201306%'
     group by SEGMENT_NAME



-----移动表空间
/*select * from (
select  'ALTER TABLE QHUpar1O.'||SEGMENT_NAME||' MOVE PARTITION '|| PARTITION_NAME ||' TABLESPACE TS_BILL_GPRS_BILL_10M_01;',(bytes/1024/1024) bytee
from Dba_Segments where tablespace_name = 'TS_BILL_SCP_BILL_2M_01'  ) where bytee>1000
*/
--alter index IDX_DR_GPRS_201208_BEGIN_DATE rebuild tablespace TS_BILL_GPRS_BILL_10M_IDX_01 online;
select  'ALTER TABLE QHUPAR1O.'||SEGMENT_NAME||' MOVE PARTITION '|| PARTITION_NAME ||' TABLESPACE TS_BILL_GSM_BILL_10M_02;',(bytes/1024/1024) bytee
from Dba_Segments where tablespace_name = 'TS_BILL_GPRS_BILL_10M_02' and segment_name like '%DR_GPRS_201304%'


    alter index indexname rebuild partition partitionname tablespace spacename parallel 1 nologging;
    ALTER INDEX  ACC_CHARGE_200904_IDX02  REBUILD PARTITION APART TABLESPACE TS_ACC_BILL_10M_03 parallel 1 nologging;


    TS_ACC_BILL_HIS_1M_IDX_01

          select A.*,B.LAST_DDL_TIME
     from Dba_Segments A, DBA_OBJECTS B where A.tablespace_name = 'TS_ACC_RES_10M_01'  AND A.SEGMENT_NAME =B.OBJECT_NAME
     AND B.OBJECT_TYPE = 'TABLE'
     AND A.OWNER=B.OWNER
      AND A.OWNER<>'QHUINV1O'
     AND B.LAST_DDL_TIME< TO_dATE('20120601','YYYYMMDD')
   --  and  A.OWNER='SUSY'

----sqlplus qhupar1o/qhltbill%yfxj07@qhbilldb
--qhucrm1o/qhltcrm%day07@qhcrmdb
--qhuinv1o/qhltacc%mhttl07@qhaccdb

---检查索引是否生效
select * from dba_indexes where owner='qhuinv1o' and status='UNUSABLE'

select * from dba_ind_partitions where index_owner='qhuinv1o' and status='UNUSABLE'

----分区表
select 'ALTER TABLE QHUPAR1O.' || TABLE_NAME || ' MOVE PARTITION ' ||
       PARTITION_NAME || ' COMPRESS;'
  from ALL_TAB_PARTITIONS
 where tablespace_name = 'TS_BILL_USER_TEMP_10M_01' and compression = 'DISABLED'
   and TABLE_NAME like 'ROAM_IN_2013%' and partition_name is not null
   and partition_name like 'C%';
----无分区表
select 'ALTER TABLE QHUPAR1O.' || TABLE_NAME|| 'MOVE COMPRESS;'
  from all_tables
 where tablespace_name = 'TS_BILL_USER_TEMP_10M_01' --and compression = 'DISABLED'
   and TABLE_NAME like 'ROAM_IN_2013%'

--查看是否已压缩
SELECT TABLE_NAME, PARTITION_NAME,COMPRESSION,tablespace_name
  FROM ALL_TAB_PARTITIONS
 where table_owner = 'QHUPAR1O'
 and table_name like 'DR_SCPG_201304%'
   and compression <> 'DISABLED';

select * from all_tab_partitions where table_name like 'DR_GPRS_201304%'
and compression <> 'DISABLED';
--
select segment_name,sum(bytes)/1024/1024/1024 from dba_segments where owner='QHUPAR1O'
and tablespace_name='TS_BILL_GPRS_BILL_10M_IDX_02'
group by segment_name
order by sum(bytes)/1024/1024/1024 desc


select * from qhupar1o.dr_scpg_201304
select * from dba_tables where table_name='DR_SCPG_201304'

select compression,count(1) from all_tables /*where table_name='DR_SCPG_201305'*/
group by compression


select * from all_tables where compression='ENABLED'

alter index xxxx rebuild tablespace xxxx


--==================================
alter index  qhuinv1o.ACC_EVENT_NOTIFY_LOG_IDX1 rebuild tablespace TS_ACC_BILL_10M_05 online;


alter index  qhuinv1o.ACC_EVENT_NOTIFY_LOG_IDX1 rebuild tablespace TS_ACC_BILL_HIS_10M_02 online;

  alter index indexname rebuild partition partitionname tablespace spacename parallel 1 nologging;
    ALTER INDEX  ACC_CHARGE_200904_IDX02  REBUILD PARTITION APART TABLESPACE TS_ACC_BILL_10M_03 parallel 1 nologging;

alter index  ACC_PAYMENT_LOG_201306_IDX4 tablespace TS_ACC_BILL_10M_05 online;
alter index  ACC_PAYMENT_LOG_201309_IDX4 tablespace TS_ACC_BILL_10M_05 online;
alter index  ACC_PAYMENT_LOG_201305_IDX4 tablespace TS_ACC_BILL_10M_05 online;
alter index  ACC_PAYMENT_LOG_201310_IDX4 tablespace TS_ACC_BILL_10M_05 online;
alter index  ACC_PAYMENT_LOG_201307_IDX4 tablespace TS_ACC_BILL_10M_05 online;
alter index  ACC_PAYMENT_LOG_201311_IDX4 tablespace TS_ACC_BILL_10M_05 online;
alter index  ACC_PAYMENT_LOG_201312_IDX4 tablespace TS_ACC_BILL_10M_05 online;
alter index  ACC_PAYMENT_LOG_201308_IDX4 tablespace TS_ACC_BILL_10M_05 online;
alter index  ACC_PAYMENT_LOG_201206_IDX4 tablespace TS_ACC_BILL_10M_05 online;
alter index  ACC_PAYMENT_LOG_201207_IDX4 tablespace TS_ACC_BILL_10M_05 online;
alter index  ACC_PAYMENT_LOG_201303_IDX4 tablespace TS_ACC_BILL_10M_05 online;
alter index  ACC_PAYMENT_LOG_201304_IDX4 tablespace TS_ACC_BILL_10M_05 online;
alter index  ACC_PAYMENT_LOG_201401_IDX4 tablespace TS_ACC_BILL_10M_05 online;


alter index  QHUINV1O.ACC_AGENT_TOTFEE_IDX2  tablespace TS_ACC_BILL_10M_05 online;
alter index  QHUINV1O.ACC_AGENT_SUBFEE_IDX1 tablespace TS_ACC_BILL_10M_05 online;
alter index  QHUINV1O.ACC_AGENT_SUBFEE_IDX2  tablespace TS_ACC_BILL_10M_05 online;

alter table  QHUINV1O.HIGH_FEE_CONTROL  move  tablespace TS_ACC_BILL_10M_06 online;
alter table  QHUINV1O.ACC_CHARGE_201207 move partition  BPART tablespace TS_ACC_BILL_10M_05;
alter table  QHUINV1O.ACC_CHARGE_201101  move partition  BPART tablespace TS_ACC_BILL_10M_05;
alter table  QHUINV1O.ACC_CHARGE_201112  move partition  BPART tablespace TS_ACC_BILL_10M_05;
alter table  QHUINV1O.REAL_CHARGE_EVERYBAK  move partition  BPART tablespace TS_ACC_BILL_10M_05;
alter table  QHUINV1O  ACC_CHARGE_200810 move partition  APART tablespace TS_ACC_BILL_10M_06;
alter table  QHUINV1O  REAL_CHARGE_EVERYBAK move partition  FPART tablespace TS_ACC_BILL_10M_06;

alter index IDX_DR_SCPG_201311_BEGIN_DATE rebuild tablespace TS_OSS_BMS_LOG_1M_IDX_02;--重建索引
alter table qhupar1o.DR_GPRS_201309 move partition D1 compress;--压缩表
alter table DR_GPRS_201306 move partition A1  tablespace TS_BILL_SCPGPRS_BILL_10M_01;--分区索引
