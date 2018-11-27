############################################
Start Database
############################################

sqlplus / as sysdba

startup nomount
startup mount
startup

alter database mount;

alter database open;

##########################################
Create Tablespace
##########################################

create tablespace tbs1
datafile '/disk1/prod/data/data01.dbf'
size 50m
autoextend on
next 512k
maxsize 250M;

mkdir -p /disk1/dev/data/

create tablespace tbs1000
datafile '/disk1/dev/data/data01.dbf'
size 50m
autoextend on
next 512k
maxsize 250M;

########################################
Alter Tablespace (adding datafile)
########################################

alter tablespace tbs1000
add datafile '/disk1/dev/data/data02.dbf'
size 50m
autoextend on
next 512k
maxsize 250M;

alter tablespace tbs1000 add datafile '/disk1/dev/data/' size 50m;
alter tablespace tbs1000 add datafile '/disk1/dev/data/data02.dbf' size 50m;


#######################################
Resize Datafile
########################################

alter database
datafile '/disk1/dev/data/data02.dbf'
resize 100m;

#######################################
View available tablespaces and datafiles
#######################################

desc dba_data_files;

SET LINESIZE 150
COLUMN TABLESPACE_NAME FORMAT A30
COLUMN FILE_NAME FORMAT A50

select tablespace_name, file_name, bytes from dba_data_files;

select tablespace_name, file_name, bytes/1024/1024 from dba_data_files;

###########################################
create datafile
###########################################

create tablespace tbs2 datafile '/disk2/prod1/data/data01.dbf' size 1m;

############################################
run sql script
############################################

(@<location of script>)
@/disk2/test1.sql
@/disk2/test1a.sql

############################################
how much space a table takes on disk
############################################

select tablespace_name, bytes/1024/1024 from dba_free_space where tablespace_name = 'TBS2';
select tablespace_name, bytes from dba_free_space where tablespace_name = 'TBS2';

#############################################
drop tablespace and delete files
#############################################

drop tablespace tbs1 including contents and datafiles;

#############################################
Rename a tablespace
#############################################

alter tablespace tbs1 rename to tbs2;

#############################################
remove a datafile
#############################################

alter tablespace tbs2 drop datafile '/disk2/prod1/data/data02.dbf';

#############################################
move tablespace to offline mode
#############################################

alter tablespace tbs2 offline;

#############################################
rename a datafile
#############################################

cd /disk2/prod1/data/
mv data01.dbf data99.dbf
alter database rename file '/disk2/prod1/data/data01.dbf' to '/disk2/prod1/data/data99.dbf';

#############################################
move tablespace to online mode
#############################################

alter tablespace tbs2 online;

#############################################
check defalut block size
#############################################

show parameter db_block_size;

#############################################
create tablespace with different block size
#############################################

create tablespace tbs3 datafile '/disk2/prod1/data/data03.dbf' size 10m blocksize 16k;

#############################################
set block size to allow 16k blocksize
#############################################

alter system set db_16k_cache_size=60m scope=both;

#############################################
create missing spfile
#############################################

create spfile from pfile;
shutdown immediate;
startup;
show parameter spfile;

############################################
work with temp tablespace
############################################

desc dba_temp_files;
select tablespace_name, file_name, bytes/1024/1024, status from dba_temp_files;
alter database tempfile '/disk2/prod01/data/temp01.dbf' resize 30m;
create temporary tablespace temp1 tempfile '/disk2/prod1/data/temp02.dbf' size 10m;
select * from database_properties where property_name like '%TABLESPACE%';
alter database default temporary tablespace temp1;

############################################
work with temp tablespace groups
############################################

create temporary tablespace temp01
tempfile '/disk1/dev/data/temp01.dbf'
size 50m
tablespace group tempgroup1;

select * from dba_tablespace_groups;
create temporary tablespace temp2 tempfile '/disk2/prod1/data/temp03.dbf' size 10m tablespace group te_group;
select tablespace_name, file_name from dba_temp_files;
alter tablespace temp1 tablespace group te_group;
select * from database_properties where property_name like '%TABLESPACE%';
alter database default temporary tablespace te_group;

############################################
local vs dictionary managed tablespace
############################################

    -old method (oracle 10g and earlier)
create tablespace tbs1 datafile '/disk1/dev/data/data01.dbf'
size 50m
extent management dictionary
default storage (initial 50k next 50k minextents 2 maxextents 50);

create tablespace tbs3 datafile '/disk2/prod1/data/data05.dbf' size 10m extent management dictionary
default storage (initial 50k next 50k minextents 2 maxextents 50 pctincrease 0);

    -new method (oracle 11g and newer)
create tablespace tbs1 datafile '/disk1/dev/data/data01.dbf'
size 50m extent management local autoallocate;

create tablespace tbs1 datafile '/disk1/dev/data/data01.dbf'
size 50m extent management local uniform size 128k;

select tablespace_name, extent_management from dba_tablespaces;

############################################
Undo management
############################################

select tablespace_name, contents, status from dba_tablespaces;
select tablespace_name, file_name, bytes/1024/1024 from dba_data_files;
show parameter undo;
alter tablespace undotbs add datafile '/disk2/prod1/data/undotbs1b.dbf' size 10m autoextend on next 1m maxsize unlimited;
select tablespace_name, file_name, bytes/1024/1024 from dba_data_files order by tablespace_name;
create undo tablespace undotbs2 datafile '/disk2/prod1/data/undotbs2_01.dbf' size 5m reuse autoextend on;
select tablespace_name, contents, status from dba_tablespaces order by tablespace_name;
show parameter undo;
alter system set undo_tablespace=undotbs2;
show parameter undo;
select segment_name, owner, tablespace_name, status from dba_rollback_segs;
alter system set undo_tablespace=undotbs;
show parameter undo;
select segment_name, owner, tablespace_name, status from dba_rollback_segs;

show parameter undo;
alter system set undo_retention = 2400;
show parameter undo;

select tablespace_name, retention from dba_tablespaces order by tablespace_name;
show parameter undo;
alter tablespace undotbs retention guarantee;
select tablespace_name, retention from dba_tablespaces order by tablespace_name;
alter tablespace undotbs retention noguarantee;
select tablespace_name, retention from dba_tablespaces order by tablespace_name;

############################################
Redo Management
############################################

select * from v$logfile;
select * from v$log;
select group#, bytes/1024/1024, status from v$log;
alter database add logfile member '/disk2/prod1/log/redo01b.log' to group 1;
alter database add logfile member '/disk2/prod1/log/redo02b.log' to group 2;
alter database add logfile member '/disk2/prod1/log/redo03b.log' to group 3;
alter system switch logfile;

alter database drop logfile group 3;
alter database add logfile group 3 ('/disk2/prod1/log/redo3.log','/disk2/prod1/log/redo3b.log','/disk2/prod1/redo3c.log') size 10m;
select * from v$logfile order by group#;

archive log list
shutdown immediate
startup mount
alter database archivelog;
alter system set log_archive_dest_1 = 'LOCATION=/disk2/prod1/arch/' scope=both;
alter database open;
archive log list;

############################################
User Management
############################################

  - Default Administrative Accounts
SYS - all priviliges (only dba)
SYSTEM - like sys but can not do backup and recovery
DBSNMP - oracle enterprise manager, monitors the database
SYSMAN - perform admin tasks

create user john identified by john1234$;
create user john identified by john1234$ password expire; 'user must change password'

create user john
profile DEFAULT
identified by john1234$
default tablespace USERS
temporary tablespace TEMP
account UNLOCK;

GRANT CONNECT TO john;
GRANT RESOURCE TO john;

alter user john
identified by john345@7;

alter user john account lock;
alter user john account unlock;

select username, account_status from dba_users;
clear screen
create user john identified by john123;
conn john/jonh123
grant create session to john;
alter user system identified by password;
connect system/password
@ORACLE_HOME/sqlplus/admin/pupbld.sql
select * from tab;
select default_tablespace, temporary_tablespace from dba_users where username='JOHN';
select tablespace_name, status from dba_tablespaces;
alter user JOHN default tablespace tbs4;
select default_tablespace, temporary_tablespace from dba_users where username='JOHN';
alter user john quota 5m on tbs4;
select username, tablespace_name, bytes, max_bytes from dba_ts_quotas;
create user tom identified by tom123 password expire;
grant create session to tom;
conn tom/tom123
drop user tom cascade;
conn john/john123
drop user tom cascade;
alter user john identified by john567 password expire;
conn john/john567
alter user john account lock;
conn john/john345
alter user john account unlock;
conn john/john345

############################################
User Privileges
############################################

"Syntax: GRANT <system_privilege> TO <grantee clause> [WITH ADMIN OPTION]"
"Example: grant create table to john;
          grant create tabel to john with admin option;"
"ANY clause: means privilege crosses schema lines"
"Example: grant select any table to john; -- can select data from tables of all users"

  create user tom identified by tom123 password expire;
  grant create session to tom;
  alter user tom default tablespace tbs4;
  alter user tom quota 5m on tbs4;
conn john/john345
create table stud(sno number);
select * from session_privs;
  grant create table to john;
create table stud(sno number);
insert into stud values(1);
commit;
select * from stud;
grant create table to tom;
  grant create table to john with admin option;
grant create table to tom;
conn tom/tom123
create table sales (cno number);
insert into sales values(2);
commit;
select * from sales;
conn john/john345
select * from sales;
select * from tom.sales;
  grant select any table to john;
select * from tom.sales;
select * from session_privs;
conn tom/tom123
select * from session_privs;


show user
create table customer (cno number);
insert into customer values(1);
insert into customer values(2);
commit;
select from * customer;
  select * from sys.customer;
grant select on sys.customer to john;
  select * from sys.customer;
  delete from sys.customer where cno=1;
grant delete on sys.customer to john;
  delete from sys.customer where cno=1;
  commit;
  grant select, delete on sys.customer to tom;
grant select on sys.customer to john with grant option;
grant delete on sys.customer to john with grant option;
  grant select, delete on sys.customer to tom;
  conn tom/tom123
  select * from sys.customer;
  delete from sys.customer where cno=22;

  conn john/john345
  select * from session_privs;
revoke create table from john;
  select * from session_privs;
  create table abc(ee number);
  conn tom/tom123
  select * from session_privs;

select * from sys.customer;
revoke select, delete on sys.customer from john;
  conn john/john345
  select * from sys.customer;
  conn tom/tom123
  select * from sys.customer;

create user dw identified by dw;
grant create session to dw;
alter user dw quota 10m on user_data;
grant create table to dw;
  conn dw/dw
  create table sales (sno number);
  create table sales_history(sno number);
  create table product (pno number);
create user peter identified by peter;
grant create session to peter;
alter user peter quota 10m on user_data;

############################################
Role Management
############################################

create role manager_role;
grant insert, update, delete on dw.sales_history to manager_role;
grant create table to manager_role;
grant manager_role to peter;
create role operations_role;
grant insert, update on dw.sales to operations_role;
grant insert, update on dw.product to operations_role;
grant operations_role to manager_role;
grant operations_role to john;
grant operations_role to tom;
    conn tom/tom123
    insert into dw.product values(1);
    commit;

############################################
User Profiles
############################################

select username, profile from dba_users where username='JOHN';
select * from dba_profiles where profile='DEFAULT';
create profile dw_profile limit
SESSIONS_PER_USER 2
IDLE_TIME 5
CONNECT_TIME 10;
create user raj identified by raj profile dw_profile;
alter user john profile dw_profile;
select username, profile from dba_users;
select * from dba_profiles where profile='DW_PROFILE';
alter profile dw_profile limit SESSIONS_PER_USER 4;
select * from dba_profiles where profile='DW_PROFILE';

alter profile dw_profile limit
PASSWORD_LIFE_TIME 180
PASSWORD_GRACE_TIME 7
FAILED_LOGIN_ATTEMPTS 10
PASSWORD_LOCK_TIME 1;
select * from dba_profiles where profile='DW_PROFILE';

############################################
Networking
############################################

oracle net service
listiner service - host name, port number, protocol, name of service listiner is handling
listener.ora - contains server side network config - $ORACLE_HOME/network/admin/
lsnrctl - utility to start, stop, status, reinitialize, dynamically config, change password on listiner
<username>/<password>@<hostname>:<listiner port>/<service name>
"connect hr/hr@prod.tcs.com:1521/orcl"
tnsnames.ora - client side network config - $ORACLE_HOME/network/admin/
sqlnet.ora

##### Listiner Config #####

hostname
ifconfig (ip address)
as root: xhost +
netca - use defaults
cd $ORACLE_HOME/network/admin/
more listiner.ora
lsnrctl start
lsnrctl services
lsnrctl status
lsnrctl stop
lsnrctl status
lsnrctl start
lsnrctl status
lsnrctl services

##### TNSNAMES Config #####

lsnrctl status
from another pc: sqlplus john/john345@litseylinux:1521/prod1
select * from tab;
select * from stud;
netmgr
-- service naming -- create -- <name> myprod -- tcp/ip -- <hostname or ip> litseylinux -- <db instance name, service name> prod1
cd $ORACLE_HOME/network/admin/
ls -lrt
more tnsnames.ora
sqlplus john/john345@myprod -- i had to enter the username and password separately instead of in the command
select * from stud;

##### Database Links #####

-- Public --
    desc dba_db_links
    select * from dba_db_links;
    create public database link prod_link connect to john identified by john345 using 'myprod';
    select * from stud@prod_link;
conn john/john345
select * from stud;
insert into stud values(2);
commit;
select * from stud;
    select * from stud@prod_link;
    show user
    conn tom/tom123
    select * from stud@prod_link;

-- Private --

show user
conn / as sysdba
create database link prod_plink connect to john identified by john345 using 'myprod';
select * from stud@prod_plink;
select * from tab@prod_plink;
conn tom/tom123
select * from tab@prod_plink;

############################################
Data Dictionary
############################################

-- Static views --
  USER_ , ALL_ , DBA_

common DBA views (DBA_<variable>, dba_data_files)
  TABLES, TAB_COLUMNS, CONSTRAINTS, INDEXES, TABLESPACES, DATA_FILES, OBJECTS, SEGMENTS, EXTENTS, FREE_SPACE, VIEWS, SYNONYMS, SYS_PRIVS, TAB_PRIVS, TRIGGERS, TS_QUOTAS

-- Dynamic Performance Views --

common DPVs
  v$parameter, v$database, v$instance, v$session, v$lock, v$transaction, v$logfile, v$log, v$archived_log

-- Miscellaneous Views --

SESSION_PRIVS, DICTIONARY, DICT_COLUMNS, TABLE_PRIVILEGES


-- DEMO --
show user
conn tom/tom123
show user
desc user_tables
select table_name, tablespace_name from user_tables;
desc all_tables
select owner, table_name from all_tables where tablespace_name='USER_DATA';
select owner, table_name from dba_tables where tablespace_name='USER_DATA';
conn / as sysdba
show user
select owner, table_name from dba_tables where tablespace_name='USER_DATA';
desc dba_users
select username, account_status from dba_users where username like 'S%';
desc dba_tablespaces
select tablespace_name, block_size from dba_tablespaces;
desc dba_data_files
select file_name from dba_data_files;
desc v$archived_log
select name from v$archived_log;
desc v$session
select sid, username from v$session;

############################################
Diagnostic Data
############################################

Alert Logs, Trace files, Core Dump files, etc....

-- Automatic Diagnostic Repository (ADR)

show parameter diagnostic_dest

-- ADRCI (Automatic Diagnostic Repository Command Interpreter)

go to ADR base shown from above command.
type adrci
type help for commands
show Alert
1: diag/rdbms/prod1/prod1
:q
Q
show alert -tail 20
set home diag/rdbms/prod1/prod1
show alert -tail 20
show alert -p "message_text like '%ORA-%'"
:q
show alert -p "message_text like '%incident%'"
:q
show tracefile
show trace /u01/app/oracle/diag/rdbms/prod1/prod1/trace/prod1_m000_22214.trc
:q

-- create incident package for oracle support --

show problem
show incident
show incident -mode detail -p "incident_id=18153"
ips create package problem 1 correlate all
ips generate package 1 in "/u01"

############################################
Manual Backup and Recovery
############################################

-- manual cold backup --
1 - determine location of data files, control files, and ther files by querying database
2 - shutdown database in immediate, transactional, or normal mode
3 - perform backup of data files, control files, archive log files, and other files
4 - start the database

select file_name from dba_data_files;
select name from v$controlfile;
archive log list
shutdown transactional
    su - root
    cd /
    mkdir coldbackup
    cd disk2
    cp -r data /coldbackup/
    cp -r control /coldbackup/
    cp -r arch /coldbackup/
    cd /coldbackup
    ls
    cd data
    ls -lrt
    cd ../control
    ls -lrt
    cd ../arch
    ls -lrt
startup

-- manual hot backup --
1 - make sure database is in archivelog mode
2 - determine location of data files, control files, and ther files by querying database
3 - check the current maximum sequence number from online redo log files (ex. 41)
4 - put database in backup mode
5 - backup data files using os utility cp
6 - tack the database out of backup mode
7 - trigger a checkpoint (archive the current logfile)
8 - backup the control file
9 - find the current maximum sequence number from online redo log files (ex 46)
10 - take backup of archived logs generate during backup (ex. 41, 42, 43, 44, 45 but not current maximum)

archive log list
select file_name from dba_data_files;
select name from v$controlfile;
select group#, sequence#, status from v$log;
alter database begin backup;
select file#, status from v$backup;
    su - root
    cd /disk1
    mkdir hotbackup
    cd /disk2/prod1
    ls
    cp -r data /disk1/hotbackup/
    cd /disk1/hotbackup/data
    ls
alter database end backup;
select file#, status from v$backup;
alter system archive log current;
select group#, sequence#, status from v$log;
alter database backup controlfile to '/disk1/hotbackup/control.bk';
    cd /disk1
    ls -lrt
    chown oracle hotbackup
alter database backup controlfile to '/disk1/hotbackup/control.bk';
    cd /disk1/hotbackup/
    ls
    cd /disk2/prod1/arch/
    ls -lrt
    cp <archive files> /disk1/hotbackup/
    cd /disk1/hotbackup/
    ls -lrt

-- recover control file from media failure --
    su - root
    cd /disk2/prod1/control
    pwd
    ls -ltra
    rm *
    ls -ltra
    cd /disk1/hotbackup/
    ls -ltra
shutdown abort
    cp control.bk /disk2/prod1/control/
    cd /disk2/prod1/control/
    mv control.bk control01.ctl
    ls
    cp control01.ctl control02.ctl
    ls
    chown oracle:oinstall control*
startup mount
recover database using backup controlfile until cancel;
    cd /disK2/prod1/log/
/disk2/prod1/log/redo01.log  -- try all until log is applied
alter database open resetlogs;

-- recover system data file from media failure --

select name from v$datafile;
  -- /disk1/prod/data/system.dbf
  new terminal
  cd /disk1/prod/data/
  rm system.dbf
shutdown abort;
  cd /misc/hotbackup/data/
  cp system.dbf /disk1/prod/data/
  cd /disk1/prod/data/
  ls -ltra
  chown oracle:oinstall system.dbf
  ls -ltra
startup mount;
recover tablespace system;
AUTO
alter database open;

-- recover a non system datafile from media failure --

drop table customer;
create table customer (customer_id number) tablespace user_data;
insert into customer values (1);
insert into customer values (2);
commit;
select * from customer;
select file_name from dba_data_files where tablespace_name='USER_DATA';
  cd /disk1/prod/data/
  ls -ltra
  cp /disk1/prod/data/user01.dbf /disk1/prod/data/old.user01.dbf.save
  rm user01.dbf
  ls -ltra
  cd /misc/hotbackup/data/
  cp user01.dbf /disk1/prod/data/
alter tablespace user_data offline;
recover tablespace user_data;
AUTO
select * from customer;
alter tablespace user_data online;
select * from customer;


############################################
RMAN backup and recovery
############################################

-- RMAN Commands --
RMAN>
    SHOW ALL;
    CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;
    CONFIGURE CONTROLFILE AUTOBACKUP ON;
    BACKUP DATABASE;
    BACKUP AS COPY DATABASE;
    BACKUP CURRENT CONTROLFILE;
    BACKUP AS BACKUPSET DATAFILE
      'ORACLE_HOME/oradata/users01.dbf',
      'ORACLE_HOME/oradata/tbs101.dbf';
    BACKUP ARCHIVELOG COMPLETION TIME BETWEEN 'SYSDATE-30' AND 'SYSDATE';
    BACKUP TABLESPACE system, users, tbs1;
    BACKUP SPFILE;
    LIST BACKUP OF DATABASE;
    BACKUP INCREMENTAL LEVEL 0 DATABASE;
    BACKUP INCREMENTAL LEVEL 1 DATABASE;
    BACKUP INCREMENTAL LEVEL 1 CUMULATIVE DATABASE;
    BACKUP INCREMENTAL LEVEL 1 TABLESPACE SYSTEM DATAFILE
      'ora_home/oradata/trgt/tbs01.dbf';
    BACKUP INCREMENTAL LEVEL = 1 CUMULATIVE TABLESPACE users;

############################################
Materialized Views
############################################

-- Materialized views with ON COMMIT --
"
CREATE MATERIALIZED VIEW sales_c_mv
BUILD IMMEDIATE
REFRESH FORCE
ON COMMIT
AS
select s.sales_date, s.order_id, s.product_id,
s.cutomer_id, s.salesperson_id, s.quantity,
s.unit_price, s.sales_amount, s.tax_amount, s.total_amount,
p.product_name
from sales@remote_db s, product@remote_db p
where s.product_id = p.product_id;
"

-- Materialized views with ON DEMAND --
"
CREATE MATERIALIZED VIEW sales_d_mv
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
select s.sales_date, s.order_id, s.product_id,
s.cutomer_id, s.salesperson_id, s.quantity,
s.unit_price, s.sales_amount, s.tax_amount, s.total_amount,
p.product_name
from sales@remote_db s, product@remote_db p
where s.product_id = p.product_id;
"
      -- Refresh the Materialized View --
      EXEC DBMS_MVIEW.refresh('SALES_D_MV');

-- Materialized views with REFRESH FAST --

Materialized Views with REFRESH FAST
Based on the availability of materialized view logs, an incremental refresh happens.
• Fast refreshable materialized views can be created based on master tables and master materialized views only.
• Materialized views based on a synonym or a view must be complete refreshed.
• Materialized views are not eligible for fast refresh if the defined subquery contains an analytic function.

-- Step 1: First create a Materialized view Log.
CREATE MATERIALIZED VIEW LOG ON SALES
WITH PRIMARY KEY
INCLUDING NEW VALUES;

If you do not have a primary key on the table, then you can go with the ROWID option.

CREATE MATERIALIZED VIEW LOG ON SALES
WITH ROWID
INCLUDING NEW VALUES;

-- Step 2: Now create the materialized view for fast refresh.
CREATE MATERIALIZED VIEW SALES_F_MV
BUILD IMMEDIATE
REFRESH FAST
ON DEMAND
AS
SELECT s.ROWID as S_ROWID, P.ROWID as P_ROWID, S.SALES_DATE, S.ORDER_ID, S.PRODUCT_ID,
 S.CUSTOMER_ID, S.SALESPERSON_ID, S.QUANTITY
 S.UNIT_PRICE, S.SALES_AMOUNT, S.TAX_AMOUNT, S.TOTAL_AMOUNT,
 P.PRODUCT_NAME
FROM SALES S, PRODUCT P
WHERE S.PRODUCT_ID = P.PRODUCT_ID;

-- Timing the refresh
The START WITH clause tells the database when to perform the first replication from the master
table to the local base table. The NEXT clause specifies the interval between refreshes.
Below refresh executes every 7 days.

CREATE MATERIALIZED VIEW SALES_F_MV
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
START WITH SYSDATE NEXT SYSDATE + 7
AS
SELECT S.SALES_DATE, S.ORDER_ID, S.PRODUCT_ID,
 S.CUSTOMER_ID, S.SALESPERSON_ID, S.QUANTITY
 S.UNIT_PRICE, S.SALES_AMOUNT, S.TAX_AMOUNT, S.TOTAL_AMOUNT,
 P.PRODUCT_NAME
FROM SALES S, PRODUCT P
WHERE S.PRODUCT_ID = P.PRODUCT_ID;

Below refresh executes every 30 minutes.

CREATE MATERIALIZED VIEW SALES_F_MV
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
START WITH SYSDATE NEXT SYSDATE + 30/(24*60)
AS
SELECT S.SALES_DATE, S.ORDER_ID, S.PRODUCT_ID,
 S.CUSTOMER_ID, S.SALESPERSON_ID, S.QUANTITY
 S.UNIT_PRICE, S.SALES_AMOUNT, S.TAX_AMOUNT, S.TOTAL_AMOUNT,
 P.PRODUCT_NAME
FROM SALES S, PRODUCT P
WHERE S.PRODUCT_ID = P.PRODUCT_ID;


-- Enable Query Rewrite
Materialized views stored in the same database as their base tables can improve query
performance through query rewrites. When QUERY REWRITE is enabled, database will try to
query the MV where ever possible, instead of base tables.

CREATE MATERIALIZED VIEW SALES_SUM_MV
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
ENABLE QUERY REWRITE
AS
SELECT TRUNC(S.SALES_DATE,'MON') AS SALES_MONTH,
 P.PRODUCT_NAME,
 SUM(S.QUANTITY) AS QUANTITY,
 SUM(S.UNIT_PRICE) AS UNIT_PRICE,
 SUM(S.SALES_AMOUNT) AS SALES_AMOUNT,
 SUM(S.TAX_AMOUNT) AS TAX_AMOUNT,
 SUM(S.TOTAL_AMOUNT) AS TOTAL_AMOUNT
FROM SALES S, PRODUCT P
WHERE S.PRODUCT_ID = P.PRODUCT_ID
GROUP BY TRUNC(S.SALES_DATE,'MON') , P.PRODUCT_NAME;

############################################
Table Partitioning
############################################

-- Range Partitioning

CREATE TABLE SALES1
(
customer_id number,
sales_date date,
order_amount number,
Region varchar2(10)
)
PARTITION BY RANGE (sales_date)
(
PARTITION sales_p1501 VALUES LESS THAN (TO_DATE('2015-02-01', 'YYYY-MM-DD')),
PARTITION sales_p1502 VALUES LESS THAN (TO_DATE('2015-03-01', 'YYYY-MM-DD')),
PARTITION sales_p1503 VALUES LESS THAN (TO_DATE('2015-04-01', 'YYYY-MM-DD')),
PARTITION sales_p1504 VALUES LESS THAN (TO_DATE('2015-05-01', 'YYYY-MM-DD')),
PARTITION sales_p1505 VALUES LESS THAN (TO_DATE('2015-06-01', 'YYYY-MM-DD')),
PARTITION sales_p1506 VALUES LESS THAN (TO_DATE('2015-07-01', 'YYYY-MM-DD')),
PARTITION sales_p1507 VALUES LESS THAN (TO_DATE('2015-08-01', 'YYYY-MM-DD')),
PARTITION sales_p1508 VALUES LESS THAN (TO_DATE('2015-09-01', 'YYYY-MM-DD')),
PARTITION sales_p1509 VALUES LESS THAN (TO_DATE('2015-10-01', 'YYYY-MM-DD')),
PARTITION sales_p1510 VALUES LESS THAN (TO_DATE('2015-11-01', 'YYYY-MM-DD')),
PARTITION sales_p1511 VALUES LESS THAN (TO_DATE('2015-12-01', 'YYYY-MM-DD')),
PARTITION sales_p1512 VALUES LESS THAN (MAXVALUE)
);

insert into sales1 values(1, TO_DATE('2015-01-12','YYYY-MM-DD'), 10, 'east');
commit;
insert into sales1 values(2, TO_DATE('2015-02-12','YYYY-MM-DD'), 11, 'east');
commit;
select * from sales1;
select * from sales1 partition (sales_p1501);
select * from sales1 partition (sales_p1502);
select * from sales1 where sales_date='12-JAN-15';
LOOK AT THE EXPLAIN PLAN TO SEE WHERE DATA WAS PULLED FROM, SHOULD SEE PARTITION RANGE


-- List Partitioning

CREATE TABLE SALES2
(
  customer_id NUMBER,
  order_date DATE,
  order_amount NUMBER,
  Region varchar2(10)
)
PARTITION BY LIST (Region)
(
PARTITION pe VALUES ('east'),
PARTITION pw VALUES('west'),
PARTITION pns VALUES ('north','south')
);

insert into sales2 values(1,'12-jan-2015',10,'east');
insert into sales2 values(2,'12-jan-2015',100,'east');
insert into sales2 values(3,'12-jan-2015',10,'west');
insert into sales2 values(4,'12-jan-2015',10,'north');
insert into sales2 values(5,'12-jan-2015',10,'south');
commit;

select * from sales2;
select * from sales2 partition (pns);
select * from sales2 partition (pe);

-- Hash Partitioning

CREATE TABLE SALES3
(
  customer_id NUMBER,
  order_date DATE,
  order_amount NUMBER,
  Region varchar2(10)
)
PARTITION BY hash (customer_id)
(
partition c1,
partition c2,
partition c3,
partition c4
);


insert into sales3 values(1,'12-jan-2015',20,'east');
insert into sales3 values(2,'12-jan-2015',100,'east');
insert into sales3 values(3,'12-jan-2015',10,'west');
insert into sales3 values(4,'12-jan-2015',10,'north');
insert into sales3 values(5,'12-jan-2015',10,'south');
commit;

select * from sales3;
select * from sales3 partition (c1);
select * from sales3 partition (c2);
select * from sales3 partition (c3);
select * from sales3 partition (c4);


-- Composite Partitioning

CREATE TABLE SALES4
(
customer_id number,
order_date date,
order_amount number,
Region varchar2(10)
)
PARTITION BY RANGE (order_date)
SUBPARTITION BY HASH( customer_id) SUBPARTITIONS 4
(
PARTITION sales_p1501 VALUES LESS THAN (TO_DATE('2015-02-01', 'YYYY-MM-DD')),
PARTITION sales_p1502 VALUES LESS THAN (TO_DATE('2015-03-01', 'YYYY-MM-DD')),
PARTITION sales_p1503 VALUES LESS THAN (TO_DATE('2015-04-01', 'YYYY-MM-DD')),
PARTITION sales_p1504 VALUES LESS THAN (TO_DATE('2015-05-01', 'YYYY-MM-DD')),
PARTITION sales_p1505 VALUES LESS THAN (TO_DATE('2015-06-01', 'YYYY-MM-DD')),
PARTITION sales_p1506 VALUES LESS THAN (TO_DATE('2015-07-01', 'YYYY-MM-DD')),
PARTITION sales_p1507 VALUES LESS THAN (TO_DATE('2015-08-01', 'YYYY-MM-DD')),
PARTITION sales_p1508 VALUES LESS THAN (TO_DATE('2015-09-01', 'YYYY-MM-DD')),
PARTITION sales_p1509 VALUES LESS THAN (TO_DATE('2015-10-01', 'YYYY-MM-DD')),
PARTITION sales_p1510 VALUES LESS THAN (TO_DATE('2015-11-01', 'YYYY-MM-DD')),
PARTITION sales_p1511 VALUES LESS THAN (TO_DATE('2015-12-01', 'YYYY-MM-DD')),
PARTITION sales_p1512 VALUES LESS THAN (MAXVALUE)
);

insert into sales4 values(1,'12-jan-2015',20,'east');
insert into sales4 values(2,'12-feb-2015',100,'east');
insert into sales4 values(3,'12-mar-2015',10,'west');
insert into sales4 values(4,'12-apr-2015',10,'north');
insert into sales4 values(5,'12-may-2015',10,'south');
insert into sales4 values(6,'19-jan-2015',200,'east');
insert into sales4 values(7,'09-feb-2015',210,'east');
insert into sales4 values(8,'31-mar-2015',320,'east');
insert into sales4 values(9,'26-sep-2015',420,'east');
commit;

select * from sales4;
select * from sales4 partition (sales_p1501);

check EXPLAIN PLAN for more information on SUBPARTITIONS

-- Interval Partitioning

CREATE TABLE SALES5
(
customer_id number,
order_date date,
order_amount number,
Region varchar2(10)
)
PARTITION BY RANGE (order_date)
(
PARTITION sales_p1506 VALUES LESS THAN (TO_DATE('2015-07-01', 'YYYY-MM-DD')),
PARTITION sales_p1507 VALUES LESS THAN (TO_DATE('2015-08-01', 'YYYY-MM-DD')),
PARTITION sales_p1508 VALUES LESS THAN (TO_DATE('2015-09-01', 'YYYY-MM-DD'))
);

insert into sales5 values(1,'12-oct-2015',20,'east');

drop table sales5;

CREATE TABLE SALES5
(
customer_id number,
order_date date,
order_amount number,
Region varchar2(10)
)
PARTITION BY RANGE (order_date)
INTERVAL (NUMTOYMINTERVAL(1, 'MONTH'))
(
PARTITION sales_p1506 VALUES LESS THAN (TO_DATE('2015-07-01', 'YYYY-MM-DD')),
PARTITION sales_p1507 VALUES LESS THAN (TO_DATE('2015-08-01', 'YYYY-MM-DD')),
PARTITION sales_p1508 VALUES LESS THAN (TO_DATE('2015-09-01', 'YYYY-MM-DD'))
);

select * from ALL_TAB_PARTITIONS;
select * from ALL_TAB_PARTITIONS where table_name='SALES5';
select TABLE_NAME, PARTITION_NAME from ALL_TAB_PARTITIONS where table_name='SALES5';

insert into sales5 values(1,'12-oct-2015',20,'east');
select * from ALL_TAB_PARTITIONS where table_name='SALES5';
select TABLE_NAME, PARTITION_NAME from ALL_TAB_PARTITIONS where table_name='SALES5';

-- Adding / Dropping Partitions

'Adding a partition'
Once you have created a partitioned table, you can add more partitions using the ALTER TABLE
command.
ALTER TABLE SALES1 ADD PARTITION
(PARTITION 'P1550' VALUES LESS THAN TO_DATE ('2016-01-01', 'YYYY-MM-DD'));

'Droping a partition'
If you want to drop a partition, you can use the below command
ALTER TABLE SALES1 DROP PARTITION P1550;


--
