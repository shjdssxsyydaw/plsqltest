select * from  v$sysstat  where name like '%this%' ; 

--PARSING
--parsed statement are in 
select * from v$sqlarea;

   --Each stmt is a cursor : max cursor open is 2000
   select b.sid, a.username, b.value open_cursors from v$session a,v$sesstat b,v$statname c where c.name in ('opened cursors current')and b.statistic# = c.statistic#
    and a.sid = b.sid and a.username is not null
   and b.value >0
   order by 3 desc;

   --check
   select a.sid,a.parse_cnt,b.cache_cnt,trunc(b.cache_cnt/a.parse_cnt*100,2) pct
   from (select a.sid,a.value parse_cnt from v$sesstat a, v$statname b where
      a.statistic#=b.statistic#
      and b.name = 'parse count (total)' and value >0) a
      ,(select a.sid,a.value cache_cnt from v$sesstat a, v$statname b where
      a.statistic#=b.statistic#
   and b.name ='session cursor cache hits') b where a.sid=b.sid order by 4,2;
   
   --sql text that are equal with minor diff
   select a.parsing_user_id,a.parse_calls,a.executions,b.sql_text||'<' from v$sqlarea a, v$sqltext b where a.parse_calls >= a.executions and a.executions > 10 and a.parsing_user_id > 0 and a.address = b.address  and a.hash_value = b.hash_value  order by 1,2,3,a.address,a.hash_value,b.piece;
   select count(1) cnt,substr(sql_text,1,instr(SQL_text,'(')) string from v$sqlarea group by substr(SQL_text,1,instr(SQL_text,'(')) order by 1;
   select a.address,a.hash_value,b.sql_text||'<' from v$sqltext b ,(select a.address,a.hash_value from v$sqlarea a where a.sql_text like 'SELECT oradba.fn_physician_name(%') a where a.address = b.address and a.hash_value = b.hash_value order by a.address,a.hash_value,b.piece;


-------------------OPTIMIZING cbo
--TIP to find candidate
select *  from v$sql where executions < 2;

--select * from dba_hist_sql;
   
--   dbms_stat

--select * from aux_stats$;
select * from dba_hist_system_event ;
select 
sum(a.time_waited_micro)/sum(a.total_waits)/1000000 c1,
sum(b.time_waited_micro)/sum(b.total_waits)/1000000 c2,
   (sum(a.total_waits) /sum(a.total_waits + b.total_waits)) * 100 c3,
   ( sum(b.total_waits) /sum(a.total_waits + b.total_waits)) * 100 c4,
   ( sum(b.time_waited_micro) /sum(b.total_waits)) /(sum(a.time_waited_micro)/sum(a.total_waits)) * 100 c5
from 
dba_hist_system_event a,
dba_hist_system_event b
where 
 a.event_name = 'db file scattered read' 
and a.snap_id = b.snap_id 
and b.event_name = 'db file sequential read'; 



select * from all_source where text like '%1=2%';



--------------------------------------------------
---
select * from v$sql_plan   order by  sql_id;
select * from v$sql_plan_statistics   order by  sql_id;


--tuning


1 Remove unnecessary large-table full table scans

   If query returns   less and 40 percent of the table rows in an ordered table
      or
      7 percent of the rows in an unordered table
   
   then query canbe tuned to use an index in lieu of the full table scan
   
2 Cache small-table full table scans In cases where a full table
 scan is the fastest access method, the tuning professional
 should ensure that a dedicated data buffer is available for
the rows. 

3 Verify optimal index usage This is especially important for
   improving the speed of queries. Oracle sometimes has a
   choice of indexes, and the tuning professional must examine
   each index and ensure that Oracle is using the proper index.
   This also includes the use of bitmapped and function-based
   indexes.
4  Verify optimal JOIN techniques Some queries will perform
   faster with NESTED LOOP joins, others with HASH
   joins, while other favor sort-merge joins.



 oracle trace
 
 ;
 
 
 -- CBO
  select * from v$parameter   where name ='optimizer_mode' ;
  select * from v$parameter   where name like 'optimizer%' ;
  /*optimizer_use_sql_plan_baselines         TRUE    
optimizer_use_pending_statistics         FALSE   
optimizer_use_invisible_indexes          FALSE   
optimizer_secure_view_merging            FALSE   
optimizer_mode                           ALL_ROWS
optimizer_index_cost_adj                 20      
optimizer_index_caching                  90      
optimizer_features_enable                11.2.0.3
optimizer_dynamic_sampling               2       
optimizer_capture_sql_plan_baselines     FALSE   
  */
  
  alter session set optimizer_mode ='first_row';
  /* opt_param(optimizer_mode ,'first_row')*/
  
--  optimizer_index_cost_adj.sql  : note change during the day
select a.average_wait c1,b.average_wait c2,a.total_waits /(a.total_waits + b.total_waits) c3,b.total_waits /(a.total_waits + b.total_waits) c4,(b.average_wait / a.average_wait)*100 start_val_fur_idx_adj
from  v$system_event a,v$system_event b where a.event = 'db file scattered read'  and b.event = 'db file sequential read'; 
      
  -- HINTS 
    /* opt_param(optimizer_mode ,'first_row')*/
    
---
col c1 heading 'Object|Name' format a30 
col c2 heading 'Option' format a15 
col c3 heading 'Index|Usage|Count' format 999,999 

select 
p.object_name c1,
p.options c2,
count(1) c3 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s 
where 
p.object_owner <> 'SYS'and 
p.options like '%RANGE SCAN%'
and 
p.operation like '%INDEX%'
and 
p.sql_id = s.sql_id
group by p.object_name,p.operation,p.options
order by 1,2,3; 


col c0 heading ‘Begin|Interval|time’ format a8col c1 heading ‘Table|Name’ format a20 
col c2 heading ‘Disk|Reads’ format 99,999,999col c3 heading ‘Rows|Processed’ format 99,999,999 


select * from (
   select 
   to_char(s.begin_interval_time,'mm-ddhh24') c0,
   p.object_name c1,
   sum(t.disk_reads_total) c2,
   sum(t.rows_processed_total) c3,
   DENSE_RANK() OVER (PARTITION BY to_char(s.begin_interval_time,'mm-ddhh24') ORDER BY SUM(t.disk_reads_total) desc) AS rnk
   from    dba_hist_sql_plan p,
   dba_hist_sqlstat t,
   dba_hist_snapshot s
   where    p.sql_id = t.sql_id
   and t.snap_id = s.snap_id
   and p.object_type like '%TABLE%'
group by to_char(s.begin_interval_time,'mm-ddhh24'),p.object_name
order by c0 desc, rnk
)
where rnk <= 5; 
        

---SORT MERGE JOIN
col c1 heading ‘Date’ format a20 
col c2 heading ‘Hash|Join|Count’ format 99,999,999col c3 heading ‘Rows|Processed’ format 99,999,999col c4 heading ‘Disk|Reads’ format 99,999,999col c5 heading ‘CPU|Time’ format 99,999,999 
ttitle ‘Merge Joins over time’ 
select
 to_char(sn.begin_interval_time,'yy-mm-dd hh24') snap_time,
count(*) ct,
sum(st.rows_processed_delta) row_ct,
sum(st.disk_reads_delta) disk,
sum(st.cpu_time_delta) cpu
from
dba_hist_snapshot sn,
dba_hist_sqlstat st,
dba_hist_sql_plan sp
where 
-- Additional cost licenses are required to access the dba_hist tables.
st.snap_id = sn.snap_id
and st.dbid = sn.dbid 
and st.snap_id = sn.snap_id 
and st.instance_number = sn.instance_number 
and sp.sql_id = st.sql_id
and sp.dbid = st.dbid
and sp.plan_hash_value = st.plan_hash_value
and
sp.operation = 'MERGE JOIN'
group by
to_char(sn.begin_interval_time,'yy-mm-dd hh24');

--hash join
select sql_text,wa.* from v$sql_workarea wa,v$sql s
where wa.sql_id=s.sql_id
;
select * from v$sql;


--index range

select
 t.blocks,i.num_rows,i.clustering_factor,t.table_name
from 
   dba_indexes i,
   dba_tables t
where i.owner ='ADPROV'
--and   clustering_factor,clustering_factor =
--and    clustering_factor > num_rows
and t.table_name=i.table_name
order by i.clustering_factor/decode(i.num_rows,0,1,i.num_rows) desc 
;



select * from dba_tables;

--Expensive SQL
select  * from
   (select
      sq.sql_id,
      round(sum(disk_reads_delta) /
      decode(sum(rows_processed_delta),
      0,1,sum(rows_processed_delta))) c2,
      sum(disk_reads_delta) c3,
      sum(rows_processed_delta) c4
   from
      dba_hist_snapshot sn,
      dba_hist_sqlstat sq,
      dba_hist_sqltext st
   where sn.snap_id = sq.snap_id and sn.dbid = sq.dbid and sn.instance_number = sq.instance_number and sn.dbid = st.dbid and sq.sql_id = st.sql_id
   and lower(sql_text) not like '%sum(%' and lower(sql_text) not like '%min(%' and lower(sql_text) not like '%max(%' and lower(sql_text) not like '%avg(%'
   and lower(sql_text) not like '%count(%' and sn.snap_id 
   --between &beginsnap and &endsnap  
   between  1 and 10000
   and sq.parsing_schema_name not in ('SYS', 'SYSMAN', 'SYSTEM', 'MDSYS','WMSYS', 'TSMSYS', 'DBSNMP', 'OUTLN')
group by
   sq.sql_id
   order by
   2 desc)
where rownum < 11
;



select * from v$sql 
where sql_id in ('2jp0bvykfatu3','fjxamx3g4341z','6f4ju1whwrsg8','gqhjpkuyhvn4c','bjpmjc4fgdk4m',
                  '33pdsg3jrvkdr','dzjgtxarmbpqu','1bgasjvg7u89d','977jgbf3vdq6g','53q1h0v9fgwx2')
;


----------------------------------
--6 RAM 
select * from v$parameter where name like 'memory%target';

select * from v$parameter where name like 'pga_aggregate_target';--2 GB

select * from v$process;

select * from v$pgastat;

--hash joins 
select to_char(sn.begin_interval_time,'yy-mm-dd hh24') snap_time,count(*) ct,sum(st.rows_processed_delta) row_ct,sum(st.disk_reads_delta) disk,sum(st.cpu_time_delta) cpu
from dba_hist_snapshot sn,dba_hist_sqlstat st,dba_hist_sql_plan sp
where st.snap_id = sn.snap_id and st.dbid = sn.dbid and st.instance_number = sn.instance_number and sp.sql_id = st.sql_id and sp.dbid = st.dbid and sp.plan_hash_value = st.plan_hash_value
and  sp.operation = 'HASH JOIN' group by  to_char(sn.begin_interval_time,'yy-mm-dd hh24') having count(*) > 0;--&hash_thr;


----------------------------------
--
select * from v$system_fix_control;

select * from v$session_fix_control;

select * from 
   (select b.sid sid,
   decode (b.username,null,e.name,b.username) user_name,
   d.spid os_id,
   b.machine machine_name,
   to_char(logon_time,'dd-mon-yy hh:mi:ss pm') logon_time,
   (sum(decode(c.name,'physical reads',value,0)) +
   sum(decode(c.name,'physical writes',value,0)) +
   sum(decode(c.name,'physical writes direct',value,0)) +
   sum(decode(c.name,'physical writes direct (lob)',value,0))+
   sum(decode(c.name,'physical reads direct (lob)',value,0)) +
   sum(decode(c.name,'physical reads direct',value,0)))
   total_physical_io,
   (sum(decode(c.name,'db block gets',value,0)) +
   sum(decode(c.name,'db block changes',value,0)) +
sum(decode(c.name,'consistent changes',value,0)) +
   sum(decode(c.name,'consistent gets',value,0)) )
   total_logical_io,
   (sum(decode(c.name,'session pga memory',value,0))+
sum(decode(c.name,'session uga memory',value,0)) )
total_memory_usage,
sum(decode(c.name,'parse count (total)',value,0)) parses,
sum(decode(c.name,'cpu used by this session',value,0))
total_cpu,
sum(decode(c.name,'parse time cpu',value,0)) parse_cpu,
sum(decode(c.name,'recursive cpu usage',value,0))
recursive_cpu,
sum(decode(c.name,'cpu used by this session',value,0)) -
sum(decode(c.name,'parse time cpu',value,0)) -
sum(decode(c.name,'recursive cpu usage',value,0))
other_cpu,
sum(decode(c.name,'sorts (disk)',value,0)) disk_sorts,
sum(decode(c.name,'sorts (memory)',value,0)) memory_sorts,
sum(decode(c.name,'sorts (rows)',value,0)) rows_sorted,
sum(decode(c.name,'user commits',value,0)) commits,
sum(decode(c.name,'user rollbacks',value,0)) rollbacks,
sum(decode(c.name,'execute count',value,0)) executions
from sys.v_$sesstat a,
sys.v_$session b,
sys.v_$statname c,
sys.v_$process d,
sys.v_$bgprocess e
where a.statistic#=c.statistic# and 
b.sid=a.sid and 
d.addr = b.paddr and
e.paddr (+) = b.paddr and
c.NAME in ('physical reads',
'physical writes',
'physical writes direct',
'physical reads direct',
'physical writes direct (lob)',
'physical reads direct (lob)',
'db block gets',
'db block changes',
'consistent changes', 
 'consistent gets',
'session pga memory',
'session uga memory',
'parse count (total)',
'CPU used by this session',
'parse time cpu',
'recursive cpu usage',
'sorts (disk)',
'sorts (memory)',
'sorts (rows)',
'user commits',
'user rollbacks', 
'consistent gets',
'session pga memory',
'session uga memory',
'parse count (total)',
'CPU used by this session',
'parse time cpu',
'recursive cpu usage',
'sorts (disk)',
'sorts (memory)',
'sorts (rows)',
'user commits',
'user rollbacks',
'execute count' 

)
group by b.sid,
d.spid,
decode (b.username,null,e.name,b.username),
b.machine,
to_char(logon_time,'dd-mon-yy hh:mi:ss pm')
order by 6 desc)
where rownum < 21; 

-----
select * from v$sql_plan;--pag 593 spiega

--find unused_index.sql

select distinct 
   d.index_name index_name ,
   a.object_owner table_owner,
   a.object_name table_name,
   b.segment_type table_type,
   b.bytes / 1024 size_kb
from 
   sys.v_$sql_plan a,
   sys.dba_segments b,
   sys.dba_indexes d 
where 


a.object_owner (+) = b.owner
and a.object_name (+) = b.segment_name
and b.segment_type in ('TABLE', 'TABLE PARTITION')
and b.owner = d.table_owner 
and a.operation like '%TABLE%'
and a.options = 'FULL'and b.bytes / 1024 > 1024and b.segment_name = d.table_name 

;

