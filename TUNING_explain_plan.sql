--1 sqlplus set autotraceon


---2 explain plan

--creqate the plan
explain plan 
-- SET STATEMENT_ID = 'test' 
for 
   select * from ap_ad_organe,ap_ad_organzst 
   where orga_instanz=orgz_orga_instanz
   ;

--read it
select * from plan_table;


--explain.sql 
-- ***************************************************************** 
-- Parameters: 
--1) Statement ID-- ***************************************************************** 
SET PAGESIZE 100 
SET LINESIZE 200 
SET VERIFY OFF 

COLUMN plan FORMAT A50 
COLUMN object_name FORMAT A30 
COLUMN object_type FORMAT A15 
COLUMN bytes FORMAT 9999999999 
COLUMN cost FORMAT 9999999 

COLUMN partition_start FORMAT A20 
COLUMN partition_stop FORMAT A20 


select  LPAD(' ', 2 * (level - 1)) ||
DECODE (level,1,NULL,level-1 || '.' || pt.position || ' ') ||
INITCAP(pt.operation) ||
DECODE(pt.options,NULL,'',' (' || INITCAP(pt.options) || ')') plan,
pt.object_name,
pt.object_type,
pt.bytes,
pt.cost,
pt.partition_start,
pt.partition_stop
from plan_table pt
start with pt.id = 0
--and pt.statement_id = '&1'
connect by prior pt.id = pt.parent_id
--and pt.statement_id = '&1'
and plan_id = 5126
; 


--dbms_xplan

select * from table (dbms_xplan.display);


---------TKPROF
ALTER SESSION SET SQL_TRACE = TRUE;

SELECT COUNT(*)
FROM   dual;

ALTER SESSION SET SQL_TRACE = FALSE;


-----------------
--display_system_stats.sql 
select pname,pval1
from sys.aux_stats$
where 
pname IN ('SREADTIM', 'MREADTIM', 'MBRC', 'CPUSPEED'); 





--Interrogating sql explain plan
set pages 999;
column nbr_FTS format 99,999column num_rows format 999,999column blocks format 9,999column owner format a10;
column name format a30;
column ch format a1;
column time heading "Snapshot Time" format a15 
column object_owner heading "Owner" format a12;
column ct heading "# of SQL selects" format 999,999; 
break on time 


select 
object_owner, count(*) ct 
from dba_hist_sql_plan 
where  object_owner is not null
group by object_owner
order by ct desc 
; 

--spool access.lst; 
set heading on;
set feedback on; 
ttitle 'full table scans and counts| |The "K" indicates that the table isin the KEEP Pool (Oracle8).' 

select
to_char(sn.end_interval_time,'mm/dd/rr hh24') time,
p.owner,
p.name,
t.num_rows, 
--ltrim(t.cache) ch,
decode(t.buffer_pool,'KEEP','Y','DEFAULT','N') K,
s.blocks blocks,
sum(a.executions_delta) nbr_FTS 
from
dba_tables t,
dba_segments s,
dba_hist_sqlstat a,
dba_hist_snapshot sn,
   (select distinct 
    pl.sql_id,
   object_owner owner,
   object_name name
   from dba_hist_sql_plan pl
   where operation = 'TABLE ACCESS'and 
  options = 'FULL') p
  where a.snap_id = sn.snap_id and 
 a.sql_id = p.sql_id and 
pl.sql_id,object_owner owner,
object_name name
from 
dba_hist_sql_plan pl where 
operation = 'TABLE ACCESS'and 
options = 'FULL') p
where 
a.snap_id = sn.snap_id and 
a.sql_id = p.sql_id and 
t.owner = s.owner and
t.table_name = s.segment_name  and
t.table_name = p.name and
t.owner = p.owner and
t.owner not in ('SYS','SYSTEM')
having sum(a.executions_delta) > 1
group by to_char(sn.end_interval_time,'mm/dd/rr hh24'),p.owner, p.name,
t.num_rows, t.cache, t.buffer_pool, s.blocks
order by 1 asc;


 
column nbr_RID format 999,999,999column num_rows format 999,999,999column owner format a15;
column name format a25; 
ttitle 'Table access by ROWID and counts'
select 

from 

to_char(sn.end_interval_time,'mm/dd/rr hh24') time,
p.owner,
p.name,
t.num_rows,
sum(a.executions_delta) nbr_RID 
dba_tables t,
dba_hist_sqlstat a,
dba_hist_snapshot sn,
(select distinctpl.sql_id,
object_owner owner,
object_name name
from 
where 
and 
where 

dba_hist_sql_plan pl 
operation = 'TABLE ACCESS' 
options = 'BY USER ROWID') p 
21 



 a.snap_id = sn.snap_id a.snap_id = sn.snap_id
and 
and 
and 

a.sql_id = p.sql_id 
t.table_name = p.name 
t.owner = p.ownerhavingsum(a.executions_delta) > 9group byto_char(sn.end_interval_time,'mm/dd/rr hh24'),p.owner, p.name, t.num_rowsorder by1 asc; 
--************************************************* 
--************************************************* 

--Index Report Section 
column nbr_scans format 999,999,999column num_rows format 999,999,999column tbl_blocks format 999,999,999column owner format a9;
column table_name format a20;
column index_name format a20; 
ttitle 'Index full scans and counts' 
select 

to_char(sn.end_interval_time,'mm/dd/rr hh24') time,
p.owner,
d.table_name,
p.name index_name,
seg.blocks tbl_blocks,
sum(s.executions_delta) nbr_scans
from 

dba_segments seg,
dba_indexes d,
dba_hist_sqlstat s,
dba_hist_snapshot sn,
(select distinctpl.sql_id,
object_owner owner,
object_name name
from 
where 
and 


dba_hist_sql_plan pl 
operation = 'INDEX' 
where 
and 
and 
and 
and 

options = 'FULL SCAN') p 
d.index_name = p.name 
s.snap_id = sn.snap_id 
s.sql_id = p.sql_id 
d.table_name = seg.segment_name 
seg.owner = p.ownerhaving 
22 



 sum(s.executions_delta) > 9group byto_char(sn.end_interval_time,'mm/dd/rr hh24'),p.owner, d.table_name,
p.name, seg.blocksorder by1 asc; 
ttitle 'Index range scans and counts' 
sum(s.executions_delta) > 9group byto_char(sn.end_interval_time,'mm/dd/rr hh24'),p.owner, d.table_name,
p.name, seg.blocksorder by1 asc; 
ttitle 'Index range scans and counts'
select 

from 

to_char(sn.end_interval_time,'mm/dd/rr hh24') time,
p.owner,
d.table_name,
p.name index_name,
seg.blocks tbl_blocks,
sum(s.executions_delta) nbr_scans 
dba_segments seg,
dba_hist_sqlstat s,
dba_hist_snapshot sn,
dba_indexes d,
(select distinctpl.sql_id,
object_owner owner,
object_name name
from 
where 
and 


dba_hist_sql_plan pl 
operation = 'INDEX' 
where 
and 
and 
and 
and 

options = 'RANGE SCAN') p 
d.index_name = p.name 
s.snap_id = sn.snap_id 
s.sql_id = p.sql_id 
d.table_name = seg.segment_name 
seg.owner = p.ownerhavingsum(s.executions_delta) > 9group byto_char(sn.end_interval_time,'mm/dd/rr hh24'),p.owner, d.table_name,
p.name, seg.blocksorder by1 asc; 
ttitle 'Index unique scans and counts'
select 

to_char(sn.end_interval_time,'mm/dd/rr hh24') time,
p.owner,
d.table_name,
p.name index_name,
sum(s.executions_delta) nbr_scans
from 

dba_hist_sqlstat s,
dba_hist_snapshot sn, 
23 



 dba_indexes d,
(select distinctpl.sql_id,
object_owner owner,
object_name namefrom 
dba_hist_sql_plan plwhere 
operation = 'INDEX'and 
options = 'UNIQUE SCAN') pwhere 
d.index_name = p.nameand 
s.snap_id = sn.snap_idand 
s.sql_id = p.sql_idhavingsum(s.executions_delta) > 9group byto_char(sn.end_interval_time,'mm/dd/rr hh24'),p.owner, d.table_name,
p.nameorder by1 asc; 
spool off 
dba_indexes d,
(select distinctpl.sql_id,
object_owner owner,
object_name namefrom 
dba_hist_sql_plan plwhere 
operation = 'INDEX'and 
options = 'UNIQUE SCAN') pwhere 
d.index_name = p.nameand 
s.snap_id = sn.snap_idand 
s.sql_id = p.sql_idhavingsum(s.executions_delta) > 9group byto_char(sn.end_interval_time,'mm/dd/rr hh24'),p.owner, d.table_name,
p.nameorder by1 asc; 
spool off 
24 
;

-----------------------

create table t_exp1 (a number );
create table t_exp2(a number );
insert into  t_exp1  values(1);
insert into  t_exp1  values(2);
insert into  t_exp1  values(3);
insert into  t_exp2  values(1);
insert into  t_exp2  values(2);

explain plan  for 
select * from 
t_exp1 t1,t_exp2 t2
where t1.a=t2.a
 ;--hash join


explain plan  for 
select * from  t_exp1 t1, provisions_interface
where t1.a=prif_instanz
 ;

explain plan  for 
select * from  ap_provisionsarten,ap_provisionsartzst /*+ FIRST_ROWS(1) */
where prar_instanz=praz_prar_instanz
 ;


select * from table (dbms_xplan.display);

select 115000/22 from dual;


