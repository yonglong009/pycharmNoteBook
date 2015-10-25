 1、查看表空间的名称及大小

    select t.tablespace_name, round(sum(bytes/(1024*1024)),0) ts_size
    from dba_tablespaces t, dba_data_files d
    where t.tablespace_name = d.tablespace_name
    group by t.tablespace_name;

2、查看表空间物理文件的名称及大小

  select tablespace_name, file_id, file_name,
  round(bytes/(1024*1024),0) total_space
  from dba_data_files
  order by tablespace_name;

3、查看回滚段名称及大小

  select segment_name, tablespace_name, r.status,
  (initial_extent/1024) InitialExtent,(next_extent/1024) NextExtent,
  max_extents, v.curext CurExtent
  From dba_rollback_segs r, v$rollstat v
  Where r.segment_id = v.usn(+)
  order by segment_name ;

4、查看控制文件

  select name from v$controlfile;

5、查看日志文件

  select member from v$logfile;

6、查看表空间的使用情况

  select sum(bytes)/(1024*1024) as free_space,tablespace_name
  from dba_free_space
  group by tablespace_name;

  SELECT A.TABLESPACE_NAME,A.BYTES TOTAL,B.BYTES USED, C.BYTES FREE,
  (B.BYTES*100)/A.BYTES "% USED",(C.BYTES*100)/A.BYTES "% FREE"
  FROM SYS.SM$TS_AVAIL A,SYS.SM$TS_USED B,SYS.SM$TS_FREE C
  WHERE A.TABLESPACE_NAME=B.TABLESPACE_NAME AND A.TABLESPACE_NAME=C.TABLESPACE_NAME;

7、查看数据库库对象

  select owner, object_type, status, count(*) count# from all_objects group by owner, object_type, status;

8、查看数据库的版本　

  Select version FROM Product_component_version
  Where SUBSTR(PRODUCT,1,6)='Oracle';

9、查看数据库的创建日期和归档方式

  Select Created, Log_Mode, Log_Mode From V$Database;

10、查看当前所有对象

SQL> select * from tab;

11、建一个和a表结构一样的空表

SQL> create table b as select * from a where 1=2;

SQL> create table b(b1,b2,b3) as select a1,a2,a3 from a where 1=2;

12、察看数据库的大小，和空间使用情况

SQL> col tablespace format a20
SQL> select b.file_id　　文件ID,
　　b.tablespace_name　　表空间,
　　b.file_name　　　　　物理文件名,
　　b.bytes　　　　　　　总字节数,
　　(b.bytes-sum(nvl(a.bytes,0)))　　　已使用,
　　sum(nvl(a.bytes,0))　　　　　　　　剩余,
　　sum(nvl(a.bytes,0))/(b.bytes)*100　剩余百分比
　　from dba_free_space a,dba_data_files b
　　where a.file_id=b.file_id
　　group by b.tablespace_name,b.file_name,b.file_id,b.bytes
　　order by b.tablespace_name
　　/
　　dba_free_space --表空间剩余空间状况
　　dba_data_files --数据文件空间占用情况

13、查看现有回滚段及其状态

SQL> col segment format a30
SQL> SELECT SEGMENT_NAME,OWNER,TABLESPACE_NAME,SEGMENT_ID,FILE_ID,STATUS FROM DBA_ROLLBACK_SEGS;

14、查看数据文件放置的路径

SQL> col file_name format a50
SQL> select tablespace_name,file_id,bytes/1024/1024,file_name from dba_data_files order by file_id;

15、显示当前连接用户

SQL> show user

16、把SQL*Plus当计算器

SQL> select 100*20 from dual;

17、连接字符串

SQL> select 列1||列2 from 表1;
SQL> select concat(列1,列2) from 表1;

18、查询当前日期

SQL> select to_char(sysdate,'yyyy-mm-dd,hh24:mi:ss') from dual;

19、用户间复制数据

SQL> copy from user1 to user2 create table2 using select * from table1;

20、视图中不能使用order by，但可用group by代替来达到排序目的

SQL> create view a as select b1,b2 from b group by b1,b2;

21、通过授权的方式来创建用户

SQL> grant connect,resource to test identified by test;

SQL> conn test/test

----------------------------------------------------------------------------------
手工创建数据库的全部脚本及说明

系统环境：

1、操作系统：Windows 2000 Server，机器内存128M

2、数据库：　Oracle 8i R2 (8.1.6) for NT 企业版

3、安装路径：D:\ORACLE

建库步骤：

1、手工创建相关目录



D:\Oracle\admin\test
D:\Oracle\admin\test\adhoc
D:\Oracle\admin\test\bdump
D:\Oracle\admin\test\cdump
D:\Oracle\admin\test\create
D:\Oracle\admin\test\exp
D:\Oracle\admin\test\pfile
D:\Oracle\admin\test\udump

D:\Oracle\oradata\test
D:\Oracle\oradata\test\archive




2、手工创建初始化启动参数文件：D:\Oracle\admin\test\pfile\inittest.ora，内容：


db_name = "test"
instance_name = test
service_names = test
db_files = 1024
control_files = ("D:\Oracle\oradata\test\control01.ctl",
"D:\Oracle\oradata\test\control02.ctl", "D:\Oracle\oradata\test\control03.ctl")
open_cursors = 200
max_enabled_roles = 30
db_file_multiblock_read_count = 8
db_block_buffers = 4096
shared_pool_size = 52428800
large_pool_size = 78643200
java_pool_size = 20971520
log_checkpoint_interval = 10000
log_checkpoint_timeout = 1800
processes = 115
parallel_max_servers = 5
log_buffer = 32768
max_dump_file_size = 10240
global_names = true
oracle_trace_collection_name = ""
background_dump_dest = D:\Oracle\admin\test\bdump
user_dump_dest = D:\Oracle\admin\test\udump
db_block_size = 16384
remote_login_passwordfile = exclusive
os_authent_prefix = ""
job_queue_processes = 4
job_queue_interval = 60
open_links = 4
distributed_transactions = 10
mts_dispatchers = "(PROTOCOL=TCP)(PRE=oracle.aurora.server.SGiopServer)"
mts_dispatchers = "(protocol=TCP)"
compatible = 8.1.0
sort_area_size = 65536
sort_area_retained_size = 65536

# log_archive_start = true
# log_archive_dest_1 = "location=D:\Oracle\oradata\oradb\archive"
# log_archive_format = %%ORACLE_SID%%T%TS%S.ARC




3、手工创建D:\Oracle\Ora81\DATABASE\inittest.ora文件，

内容：IFILE=’D:\Oracle\admin\test\pfile\inittest.ora’

4、使用orapwd.exe命令，创建D:\Oracle\Ora81\DATABASE\PWDtest.ora

命令：D:\Oracle\Ora81\bin\orapwd file=D:\Oracle\Ora81\DATABASE\PWDtest.ora password=ORACLE entries=5

5、通过oradim.exe命令，在服务里生成一个新的实例管理服务，启动方式为手工

set ORACLE_SID=test

D:\Oracle\Ora81\bin\oradim -new -sid test -startmode manual -pfile "D:\Oracle\admin\test\pfile\inittest.ora"

6、生成各种数据库对象

D:\ >svrmgrl

--创建数据库


connect INTERNAL/oracle
startup nomount pfile="D:\Oracle\admin\test\pfile\inittest.ora"
CREATE DATABASE test
LOGFILE ’D:\Oracle\oradata\test\redo01.log’ SIZE 2048K,
’D:\Oracle\oradata\test\redo02.log’ SIZE 2048K,
’D:\Oracle\oradata\test\redo03.log’ SIZE 2048K
MAXLOGFILES 32
MAXLOGMEMBERS 2
MAXLOGHISTORY 1
DATAFILE ’D:\Oracle\oradata\test\system01.dbf’
SIZE 58M REUSE AUTOEXTEND ON NEXT 640K
MAXDATAFILES 254
MAXINSTANCES 1
CHARACTER SET ZHS16GBK
NATIONAL CHARACTER SET ZHS16GBK;



控制文件、日志文件在上面语句执行时生成

connect INTERNAL/oracle

--修改系统表空间

ALTER TABLESPACE SYSTEM DEFAULT STORAGE ( INITIAL 64K NEXT 64K MINEXTENTS 1 MAXEXTENTS UNLIMITED PCTINCREASE 50);

ALTER TABLESPACE SYSTEM MINIMUM EXTENT 64K;

--创建回滚表空间


CREATE TABLESPACE RBS DATAFILE ’D:\Oracle\oradata\test\rbs01.dbf’ SIZE 256M REUSE
AUTOEXTEND ON NEXT 5120K
MINIMUM EXTENT 512K
DEFAULT STORAGE ( INITIAL 512K NEXT 512K MINEXTENTS 8 MAXEXTENTS 4096);



--创建用户表空间


CREATE TABLESPACE USERS DATAFILE ’D:\Oracle\oradata\test\users01.dbf’ SIZE 128M REUSE
AUTOEXTEND ON NEXT 1280K
MINIMUM EXTENT 128K
DEFAULT STORAGE ( INITIAL 128K NEXT 128K MINEXTENTS 1 MAXEXTENTS 4096 PCTINCREASE 0);



--创建临时表空间


CREATE TABLESPACE TEMP DATAFILE ’D:\Oracle\oradata\test\temp01.dbf’ SIZE 32M REUSE
AUTOEXTEND ON NEXT 640K
MINIMUM EXTENT 64K
DEFAULT STORAGE ( INITIAL 64K NEXT 64K MINEXTENTS 1 MAXEXTENTS
UNLIMITED PCTINCREASE 0) TEMPORARY;



--创建工具表空间


CREATE TABLESPACE TOOLS DATAFILE ’D:\Oracle\oradata\test\tools01.dbf’ SIZE 64M REUSE
AUTOEXTEND ON NEXT 320K
MINIMUM EXTENT 32K
DEFAULT STORAGE ( INITIAL 32K NEXT 32K MINEXTENTS 1 MAXEXTENTS 4096 PCTINCREASE 0);



--创建索引表空间


CREATE TABLESPACE INDX DATAFILE ’D:\Oracle\oradata\test\indx01.dbf’ SIZE 32M REUSE
AUTOEXTEND ON NEXT 1280K
MINIMUM EXTENT 128K
DEFAULT STORAGE ( INITIAL 128K NEXT 128K MINEXTENTS 1 MAXEXTENTS 4096 PCTINCREASE 0);



--创建回滚段


CREATE PUBLIC ROLLBACK SEGMENT RBS0 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS1 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS2 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS3 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS4 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS5 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS6 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS7 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS8 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS9 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS10 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS11 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS12 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS13 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS14 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS15 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS16 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS17 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS18 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS19 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS20 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS21 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS22 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS23 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );
CREATE PUBLIC ROLLBACK SEGMENT RBS24 TABLESPACE RBS STORAGE ( OPTIMAL 4096K );



--使回滚段在线


ALTER ROLLBACK SEGMENT "RBS0" ONLINE;
ALTER ROLLBACK SEGMENT "RBS1" ONLINE;
ALTER ROLLBACK SEGMENT "RBS2" ONLINE;
ALTER ROLLBACK SEGMENT "RBS3" ONLINE;
ALTER ROLLBACK SEGMENT "RBS4" ONLINE;
ALTER ROLLBACK SEGMENT "RBS5" ONLINE;
ALTER ROLLBACK SEGMENT "RBS6" ONLINE;
ALTER ROLLBACK SEGMENT "RBS7" ONLINE;
ALTER ROLLBACK SEGMENT "RBS8" ONLINE;
ALTER ROLLBACK SEGMENT "RBS9" ONLINE;
ALTER ROLLBACK SEGMENT "RBS10" ONLINE;
ALTER ROLLBACK SEGMENT "RBS11" ONLINE;
ALTER ROLLBACK SEGMENT "RBS12" ONLINE;
ALTER ROLLBACK SEGMENT "RBS13" ONLINE;
ALTER ROLLBACK SEGMENT "RBS14" ONLINE;
ALTER ROLLBACK SEGMENT "RBS15" ONLINE;
ALTER ROLLBACK SEGMENT "RBS16" ONLINE;
ALTER ROLLBACK SEGMENT "RBS17" ONLINE;
ALTER ROLLBACK SEGMENT "RBS18" ONLINE;
ALTER ROLLBACK SEGMENT "RBS19" ONLINE;
ALTER ROLLBACK SEGMENT "RBS20" ONLINE;
ALTER ROLLBACK SEGMENT "RBS21" ONLINE;
ALTER ROLLBACK SEGMENT "RBS22" ONLINE;
ALTER ROLLBACK SEGMENT "RBS23" ONLINE;
ALTER ROLLBACK SEGMENT "RBS24" ONLINE;



--修改sys用户的临时表空间为TEMP

alter user sys temporary tablespace TEMP;

--创建数据字典表


@D:\Oracle\Ora81\Rdbms\admin\catalog.sql;
@D:\Oracle\Ora81\Rdbms\admin\catexp7.sql
@D:\Oracle\Ora81\Rdbms\admin\catproc.sql
@D:\Oracle\Ora81\Rdbms\admin\caths.sql

connect system/manager
@D:\Oracle\Ora81\sqlplus\admin\pupbld.sql

connect internal/oracle
@D:\Oracle\Ora81\Rdbms\admin\catrep.sql
exit




--生成SQL*Plus帮助系统

sqlplus SYSTEM/manager

@D:\Oracle\Ora81\sqlplus\admin\help\helpbld.sql helpus.sql

exit

--修改system用户默认表空间和临时表空间

svrmgrl

connect internal/oracle

alter user system default tablespace TOOLS;

alter user system temporary tablespace TEMP;

exit

7、将test实例启动服务设置成自动启动方式

D:\Oracle\Ora81\bin\oradim -edit -sid test -startmode auto