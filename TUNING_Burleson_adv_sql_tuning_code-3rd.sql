Advanced Oracle SQL Tuning 
The Definitive Reference 

By Donald K. Burleson 

Copyright © 2014 by Rampant TechPress. All rights reserved. 

Code Depot 

ISBN-13: 978-0-9916386-0-4 
Library of Congress: 2014904248 

Contents 


convoluted.sql ....................................................................................... 7 
optimizer_index_cost_adj.sql ............................................................... 9 
disk_read_waits.sql ............................................................................. 10 
explain.sql ............................................................................................ 11 
display_system_stats.sql ..................................................................... 12 
awr_sql_index_freq.sql ....................................................................... 13 
awr_top_tables_phyrd.sql ................................................................... 14 
awr_sql_object_freq.sql ...................................................................... 15 
plan9i.sql ............................................................................................. 16 
plan10g.sql .......................................................................................... 20 
find_merge_joins.sql .......................................................................... 25 
awr_nested_join_alert.sql ................................................................... 26 
hash_area.sql....................................................................................... 27 
hash_join_alert.sql .............................................................................. 28 
buf_keep_pool.sql ............................................................................... 29 
buf_keep_pool_5_tch_20_blks.sql ...................................................... 31 
size_keep_pool.sql .............................................................................. 32 
find_bif.sql .......................................................................................... 33 
awr_sql_index_access.sql ................................................................... 34 
awr_count_index_details.sql .............................................................. 36 
index_range_scans.sql ........................................................................ 37 
busy_table_io.sql ................................................................................ 38 
count_table_access.sql ....................................................................... 39 
index_usage_hr.sql ............................................................................. 40 
awr_sql_index_freq.sql ....................................................................... 41 


3 


awr_access_counts.sql ........................................................................ 42 
awr_sql_index_access.sql ................................................................... 43 
awr_sql_full_scans.sql ........................................................................ 45 
find_full_scans.sql ............................................................................... 46 
get_sql.sql............................................................................................ 50 
get_sub_optimal_cached_sql.sql ........................................................ 51 
awr_expensive_sql.sql ......................................................................... 52 
statspack_unused_indexes.sql ............................................................ 53 
awr_unused_indexes.sql ..................................................................... 55 
awr_infrequent_indexes.sql ................................................................ 56 
Find_duplicate_index_columns.sql ................................................... 57 
find_sparse_indexes.sql ...................................................................... 58 
show_ram_plan.sql ............................................................................. 59 
monitor_hash_join_ful_ram.sql .......................................................... 60 
show_pga_ram_details.sql .................................................................. 61 
track_hash_joins.sql ............................................................................ 62 
remote_sql_execution_plan.sql .......................................................... 63 
parallel_tq_stats.sql ............................................................................. 64 
statspack_opq.sql ................................................................................ 65 
parallel_plan.sql .................................................................................. 66 
tsfree.sql .............................................................................................. 67 
statspack_find_chained_rows.sql ....................................................... 68 
chained_row.sql .................................................................................. 69 
index_range_scans.sql ........................................................................ 70 
busy_table_io.sql ................................................................................. 71 
count_table_access.sql ........................................................................ 72 


4 


statspack_plot_sorts_dow.sql ............................................................. 73 
statspack_plot_sorts_hod.sql ............................................................. 74 
statspack_sorts_alert.sql ..................................................................... 75 
statspack_avg_sorts_hod.sql .............................................................. 76 
display_optimizer_features_by_release.sql ........................................ 77 
top_20_sessions.sql ............................................................................. 78 
high_scan_sql.sql ................................................................................ 80 
find_cartesian_joins.sql ...................................................................... 81 
high_resource_sql.sql ......................................................................... 82 
cartesian_sum.sql ............................................................................... 83 
sql_cartesian.sql .................................................................................. 84 
large_scan_count.sql .......................................................................... 85 
tabscan.sql .......................................................................................... 86 
display_top_sql_disk_reads.sql .......................................................... 87 
display_top_sql_elspsed_time.sql ...................................................... 88 
fullsql.sql ............................................................................................. 89 
planstats.sql ........................................................................................ 90 
awr_dba_hist_sql_plan.sql ................................................................. 91 
unused_indx.sql .................................................................................. 92 
display_parent_n_child_cursors.sql ................................................... 94 
sql_shared_cursor.sql ......................................................................... 95 
rpt_lib.sql ............................................................................................ 98 
library_cache_miss.sql ........................................................................ 99 
library_cache_hit_ratio.sql ............................................................... 100 
hwm_open_cursors.sql ..................................................................... 102 
monitor_open_cursors.sql ................................................................ 103 


5 


user_open_cursors.sql ....................................................................... 104 
monitor_session_cached_cursors.sql ............................................... 105 
check_bind_sensitive_sql.sql ........................................................... 106 
sqlstat_deltas.sql ............................................................................... 107 
sqlstat_deltas_detail.sql .................................................................... 108 
high_cost_sql.sql ............................................................................... 109 
sql_object_char.sql ............................................................................ 110 
sql_object_char_detail.sql .................................................................. 111 
nested_join_alert.sql ......................................................................... 112 
sql_index.sql ...................................................................................... 113 
sql_index_access.sql ......................................................................... 114 
sql_object_avg_dy.sql ....................................................................... 116 
sql_details.sql .................................................................................... 117 
sql_full_scans.sql .............................................................................. 118 
full_table_scans.sql ........................................................................... 119 
sql_access_hr.sql ............................................................................... 120 
sql_access_day.sql ............................................................................ 121 
sql_scan_sums.sql ............................................................................. 122 
sql_full_scans_avg_dy.sql ................................................................. 124 
index_usage_hr.sql ........................................................................... 125 
access_counts.sql .............................................................................. 126 
delete_forall.sql ................................................................................. 127 
update_forall.sql ................................................................................ 128 
addm_rpt.sql ..................................................................................... 129 


6 



convoluted.sql 
SELECT ART.DEMO_MEMBER DEMO_MEMBER,
(SELECT PARAMETER_VALUEFROM PPM_CIA_PREMIUM_VAL CIA_VAL 
WHERE CIA_VAL.PRD_DEMO_CHRSTC_MEMBER = ART.DEMO_MEMBER 
AND CIA_NAME IN ('Baseline')
AND PRMA_MKT_MEMBER = ? 
AND INVOICE_TYPE_NAME IN ('Weekly')
AND GROUP_TYPE_CODE = 'C' 
) WEEKLY_VALS,
(SELECT PARAMETER_VALUEFROM PPM_CIA_PREMIUM_VAL CIA_VAL 
WHERE CIA_VAL.PRD_DEMO_CHRSTC_MEMBER = ART.DEMO_MEMBER 
AND CIA_NAME IN ('Baseline')
AND PRMA_MKT_MEMBER = ? 
AND INVOICE_TYPE_NAME IN ('Monthly')
AND GROUP_TYPE_CODE = 'C' 
) MONTHLY_VALS,
(SELECT PARAMETER_VALUEFROM PPM_CIA_PREMIUM_VAL CIA_VAL 
WHERE CIA_VAL.PRD_DEMO_CHRSTC_MEMBER = ART.DEMO_MEMBER 
AND CIA_NAME IN ('Baseline')
AND PRMA_MKT_MEMBER = ? 
AND INVOICE_TYPE_NAME IN ('90Day')
AND GROUP_TYPE_CODE = 'C' 
) NINETYDAY_VALS,
(SELECT PARAMETER_VALUEFROM PPM_CIA_PREMIUM_VAL CIA_VAL 
WHERE CIA_VAL.PRD_DEMO_CHRSTC_MEMBER = ART.DEMO_MEMBER 
AND CIA_NAME IN ('Baseline')
AND PRMA_MKT_MEMBER = ? 
AND INVOICE_TYPE_NAME IN ('Annual')
AND GROUP_TYPE_CODE = 'C' 
) ANNUAL_VALS,
'C' AS GROUP_TYPE_CODE 
FROM 
(SELECT DISTINCT PRD_DEMO_CHRSTC_MEMBER DEMO_MEMBERFROM PPM_CIA_PREMIUM_VAL 
WHERE CIA_NAME IN ('Baseline')
AND PRMA_MKT_MEMBER = ? 
AND INVOICE_TYPE_NAME IN ('Weekly' ,
'Monthly',
'Annual' ,
'90Day')
AND GROUP_TYPE_CODE = 'C' 
GROUP BY PRD_DEMO_CHRSTC_MEMBER 
) ART 
UNION ALL 
SELECT ART.DEMO_MEMBER DEMO_MEMBER,
(SELECT PARAMETER_VALUEFROM PPM_CIA_PREMIUM_VAL CIA_VAL 
WHERE CIA_VAL.PRD_DEMO_CHRSTC_MEMBER = ART.DEMO_MEMBER 
AND CIA_NAME IN ('Baseline')
AND PRMA_MKT_MEMBER = ? 
AND INVOICE_TYPE_NAME IN ('Weekly')
AND GROUP_TYPE_CODE = 'T' 
) WEEKLY_VALS,
(SELECT PARAMETER_VALUEFROM PPM_CIA_PREMIUM_VAL CIA_VAL 
WHERE CIA_VAL.PRD_DEMO_CHRSTC_MEMBER = ART.DEMO_MEMBER 
AND CIA_NAME IN ('Baseline')
AND PRMA_MKT_MEMBER = ? 
AND INVOICE_TYPE_NAME IN ('Monthly')
AND GROUP_TYPE_CODE = 'T' 
) MONTHLY_VALS,
(SELECT PARAMETER_VALUEFROM PPM_CIA_PREMIUM_VAL CIA_VAL 
WHERE CIA_VAL.PRD_DEMO_CHRSTC_MEMBER = ART.DEMO_MEMBER 
AND CIA_NAME IN ('Baseline')
AND PRMA_MKT_MEMBER = ? 
AND INVOICE_TYPE_NAME IN ('90Day') 
7 



 AND GROUP_TYPE_CODE = 'T' 
) NINETYDAY_VALS,
(SELECT PARAMETER_VALUEFROM PPM_CIA_PREMIUM_VAL CIA_VAL 
WHERE CIA_VAL.PRD_DEMO_CHRSTC_MEMBER = ART.DEMO_MEMBER 
AND CIA_NAME IN ('Baseline')
AND PRMA_MKT_MEMBER = ? 
AND INVOICE_TYPE_NAME IN ('Annual')
AND GROUP_TYPE_CODE = 'T' 
) ANNUAL_VALS,
'T' AS GROUP_TYPE_CODE 
FROM 
(SELECT DISTINCT PRD_DEMO_CHRSTC_MEMBER DEMO_MEMBERFROM PPM_CIA_PREMIUM_VAL 
WHERE CIA_NAME IN ('Baseline')
AND PRMA_MKT_MEMBER = ? 
AND INVOICE_TYPE_NAME IN ('Weekly' ,
'Monthly',
'Annual' ,
'90Day')
AND GROUP_TYPE_CODE = 'T' 
GROUP BY PRD_DEMO_CHRSTC_MEMBER 
) ARTORDER BY GROUP_TYPE_CODE 
AND GROUP_TYPE_CODE = 'T' 
) NINETYDAY_VALS,
(SELECT PARAMETER_VALUEFROM PPM_CIA_PREMIUM_VAL CIA_VAL 
WHERE CIA_VAL.PRD_DEMO_CHRSTC_MEMBER = ART.DEMO_MEMBER 
AND CIA_NAME IN ('Baseline')
AND PRMA_MKT_MEMBER = ? 
AND INVOICE_TYPE_NAME IN ('Annual')
AND GROUP_TYPE_CODE = 'T' 
) ANNUAL_VALS,
'T' AS GROUP_TYPE_CODE 
FROM 
(SELECT DISTINCT PRD_DEMO_CHRSTC_MEMBER DEMO_MEMBERFROM PPM_CIA_PREMIUM_VAL 
WHERE CIA_NAME IN ('Baseline')
AND PRMA_MKT_MEMBER = ? 
AND INVOICE_TYPE_NAME IN ('Weekly' ,
'Monthly',
'Annual' ,
'90Day')
AND GROUP_TYPE_CODE = 'T' 
GROUP BY PRD_DEMO_CHRSTC_MEMBER 
) ARTORDER BY GROUP_TYPE_CODE 
8 



• 
optimizer_index_cost_adj.sql 

col c1 heading 'Average Waits|forFull| Scan Read I/O' format 9999.999 
col c2 heading 'Average Waits|for Index|Read I/O' format 9999.999 
col c3 heading 'Percent of| I/O Waits|for Full Scans' format 9.99 
col c4 heading 'Percent of| I/O Waits|for Index Scans' format 9.99 
col c5 heading 'Starting|Value|for|optimizer|index|cost|adj' format 999 
select 
a.average_wait c1,
b.average_wait c2,
a.total_waits /(a.total_waits + b.total_waits) c3,
b.total_waits /(a.total_waits + b.total_waits) c4,
(b.average_wait / a.average_wait)*100 c5 
from 
v$system_event a,
v$system_event bwhere 
a.event = 'db file scattered read' 
and 
b.event = 'db file sequential read'

; 

9 



• 
disk_read_waits.sql 
select 

sum(a.time_waited_micro)/sum(a.total_waits)/1000000 c1,
sum(b.time_waited_micro)/sum(b.total_waits)/1000000 c2,
( 
sum(a.total_waits) /
sum(a.total_waits + b.total_waits)
) * 100 c3,
( 
sum(b.total_waits) /
sum(a.total_waits + b.total_waits)
) * 100 c4,
( 
sum(b.time_waited_micro) /
sum(b.total_waits)) /
(sum(a.time_waited_micro)/sum(a.total_waits)
) * 100 c5from 
dba_hist_system_event a,
dba_hist_system_event b
where 
and 
a.event_name = 'db file scattered read' 

a.snap_id = b.snap_id 
and 

b.event_name = 'db file sequential read'; 
10 



• 
explain.sql 
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
select LPAD(' ', 2 * (level - 1)) ||
DECODE (level,1,NULL,level-1 || '.' || pt.position || ' ') ||
INITCAP(pt.operation) ||
DECODE(pt.options,NULL,'',' (' || INITCAP(pt.options) || ')') plan,
pt.object_name,
pt.object_type,
pt.bytes,
pt.cost,
pt.partition_start,
pt.partition_stopfrom plan_table ptstart with pt.id = 0and pt.statement_id = '&1'
connect by prior pt.id = pt.parent_idand pt.statement_id = '&1'; 
11 



• 
display_system_stats.sql 
select ¶
pname,
pval1from 
sys.aux_stats$
where 
pname IN (’SREADTIM’, ‘MREADTIM’, ‘MBRC’, ‘CPUSPEED’); 
12 



• 
awr_sql_index_freq.sql 
col c1 heading ‘Object|Name’ format a30 
col c2 heading ‘Option’ format a15 
col c3 heading ‘Index|Usage|Count’ format 999,999 
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
p.operation like ‘%INDEX%’
and 
p.sql_id = s.sql_idgroup byp.object_name,
p.operation,
p.optionsorder by1,2,3; 
13 



• 
awr_top_tables_phyrd.sql 
col c0 heading ‘Begin|Interval|time’ format a8col c1 heading ‘Table|Name’ format a20 
col c2 heading ‘Disk|Reads’ format 99,999,999col c3 heading ‘Rows|Processed’ format 99,999,999 
select 
* 

from (
select 
to_char(s.begin_interval_time,'mm-dd hh24') c0,
p.object_name c1,
sum(t.disk_reads_total) c2,
sum(t.rows_processed_total) c3,
DENSE_RANK() OVER (PARTITION BY to_char(s.begin_interval_time,'mm-ddhh24') ORDER BY SUM(t.disk_reads_total) desc) AS rnkfrom 
dba_hist_sql_plan p,
dba_hist_sqlstat t,
dba_hist_snapshot swhere 
p.sql_id = t.sql_idand 
t.snap_id = s.snap_idand 
p.object_type like '%TABLE%'
group byto_char(s.begin_interval_time,'mm-dd hh24'),
p.object_nameorder byc0 desc, rnk)
where rnk <= 5; 
14 



• 
awr_sql_object_freq.sql 
col c1 heading ‘Object|Name’ format a30 
col c2 heading ‘Operation’ format a15 
col c3 heading ‘Option’ format a15 
col c4 heading ‘Object|Count’ format 999,999 
break on c1 skip 2break on c2 skip 2 
select 

p.object_name c1,
p.operation c2,
p.options c3,
count(1) c4 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s 
where 
p.object_owner <> 'SYS'and 
p.sql_id = s.sql_idgroup byp.object_name,
p.operation,
p.optionsorder by1,2,3; 
15 



• 
plan9i.sql 
set echo off;
set feedback on 

set pages 999;
column nbr_FTS format 999,999column num_rows format 999,999,999column blocks format 999,999column owner format a14;
column name format a24;
column ch format a1; 
column object_owner heading "Owner" format a12;
column ct heading "# of SQL selects" format 999,999; 
select 

from 
where 

object_owner,
count(*) ct 
v$sql_plan 
ct desc 

object_owner is not nullgroup byobject_ownerorder by 
;
--spool access.lst; 
set heading off;
set feedback off; 
set heading on;
set feedback on;
ttitle 'full table scans and counts| |The "K" indicates that the table isin the KEEP Pool (Oracle8).'
select 

from 

p.owner,
p.name,
t.num_rows, 
--ltrim(t.cache) ch,
decode(t.buffer_pool,'KEEP','Y','DEFAULT','N') K,
s.blocks blocks,
sum(a.executions) nbr_FTS 
dba_tables t,
dba_segments s,
v$sqlarea a,
(select distinctaddress,
object_owner owner,
object_name name
from 
where

v$sql_plan 
operation = 'TABLE ACCESS' 
16 



 options = 'FULL') pwhere 
and 
options = 'FULL') pwhere 
and 
and 

a.address = p.address 

t.owner = s.owner 
and 
and 
and 
and 


t.table_name = s.segment_name 
t.table_name = p.name 
t.owner = p.owner 
t.owner not in ('SYS','SYSTEM')
havingsum(a.executions) > 9group byp.owner, p.name, t.num_rows, t.cache, t.buffer_pool, s.blocksorder bysum(a.executions) desc; 
column nbr_RID format 999,999,999column num_rows format 999,999,999column owner format a15;
column name format a25; 
ttitle 'Table access by ROWID and counts'
select 

p.owner,
p.name,
t.num_rows,
sum(s.executions) nbr_RID
from 

dba_tables t,
v$sqlarea s,
(select distinctaddress,
object_owner owner,
object_name name
from 
where 
and 


v$sql_plan 
operation = 'TABLE ACCESS' 
where 
and 
and 

options = 'BY ROWID') p 
s.address = p.address 
t.table_name = p.name 
t.owner = p.ownerhavingsum(s.executions) > 9group byp.owner, p.name, t.num_rowsorder bysum(s.executions) desc; 
--************************************************* 

17 



--Index Report Section--Index Report Section
--************************************************* 

column nbr_scans format 999,999,999column num_rows format 999,999,999column tbl_blocks format 999,999,999column owner format a9;
column table_name format a20;
column index_name format a20; 
ttitle 'Index full scans and counts' 
select 

p.owner,
d.table_name,
p.name index_name,
seg.blocks tbl_blocks,
sum(s.executions) nbr_scans
from 

dba_segments seg,
v$sqlarea s,
dba_indexes d,
(select distinctaddress,
object_owner owner,
object_name name
from 
where 
and 


v$sql_plan 
operation = 'INDEX' 
where 
and 
and 
and 

options = 'FULL SCAN') p 
d.index_name = p.name 
s.address = p.address 
d.table_name = seg.segment_name 
seg.owner = p.ownerhavingsum(s.executions) > 9group byp.owner, d.table_name, p.name, seg.blocksorder bysum(s.executions) desc; 
ttitle 'Index range scans and counts'
select 

p.owner,
d.table_name,
p.name index_name,
seg.blocks tbl_blocks,
sum(s.executions) nbr_scans
from 

dba_segments seg,
v$sqlarea s,
dba_indexes d,
(select distinct 
18 



 address,
object_owner owner,
object_name namefrom 
v$sql_planwhere 
operation = 'INDEX'and 
options = 'RANGE SCAN') pwhere 
d.index_name = p.nameand 
s.address = p.addressand 
d.table_name = seg.segment_nameand 
seg.owner = p.ownerhavingsum(s.executions) > 9group byp.owner, d.table_name, p.name, seg.blocksorder bysum(s.executions) desc; 
ttitle 'Index unique scans and counts'select 
p.owner,
d.table_name,
p.name index_name,
sum(s.executions) nbr_scansfrom 
v$sqlarean s,
dba_indexes d,
(select distinctaddress,
object_owner owner,
object_name namefrom 
v$sql_planwhere 
operation = 'INDEX'and 
options = 'UNIQUE SCAN') pwhere 
d.index_name = p.nameand 
s.address = p.addresshavingsum(s.executions) > 9group byp.owner, d.table_name, p.nameorder bysum(s.executions) desc; 
address,
object_owner owner,
object_name namefrom 
v$sql_planwhere 
operation = 'INDEX'and 
options = 'RANGE SCAN') pwhere 
d.index_name = p.nameand 
s.address = p.addressand 
d.table_name = seg.segment_nameand 
seg.owner = p.ownerhavingsum(s.executions) > 9group byp.owner, d.table_name, p.name, seg.blocksorder bysum(s.executions) desc; 
ttitle 'Index unique scans and counts'select 
p.owner,
d.table_name,
p.name index_name,
sum(s.executions) nbr_scansfrom 
v$sqlarean s,
dba_indexes d,
(select distinctaddress,
object_owner owner,
object_name namefrom 
v$sql_planwhere 
operation = 'INDEX'and 
options = 'UNIQUE SCAN') pwhere 
d.index_name = p.nameand 
s.address = p.addresshavingsum(s.executions) > 9group byp.owner, d.table_name, p.nameorder bysum(s.executions) desc; 
19 



• 
plan10g.sql 
spool plan.lst 
set echo off 
set feedback on 

set pages 999;
column nbr_FTS format 99,999column num_rows format 999,999column blocks format 9,999column owner format a10;
column name format a30;
column ch format a1;
column time heading "Snapshot Time" format a15 
column object_owner heading "Owner" format a12;
column ct heading "# of SQL selects" format 999,999; 
break on time 


select 

from 
where 

object_owner,
count(*) ct 
dba_hist_sql_plan 
ct desc 

object_owner is not nullgroup byobject_ownerorder by 
select 

; 
--spool access.lst; 
set heading on;
set feedback on; 
ttitle 'full table scans and counts| |The "K" indicates that the table isin the KEEP Pool (Oracle8).' 
from 

to_char(sn.end_interval_time,'mm/dd/rr hh24') time,
p.owner,
p.name,
t.num_rows, 
--ltrim(t.cache) ch,
decode(t.buffer_pool,'KEEP','Y','DEFAULT','N') K,
s.blocks blocks,
sum(a.executions_delta) nbr_FTS 
dba_tables t,
dba_segments s,
dba_hist_sqlstat a,
dba_hist_snapshot sn,
(select distinct 
20 



 pl.sql_id,
object_owner owner,
object_name namefrom 
dba_hist_sql_plan plwhere 
operation = 'TABLE ACCESS'and 
options = 'FULL') pwhere 
a.snap_id = sn.snap_idand 
a.sql_id = p.sql_idand 
pl.sql_id,
object_owner owner,
object_name namefrom 
dba_hist_sql_plan plwhere 
operation = 'TABLE ACCESS'and 
options = 'FULL') pwhere 
a.snap_id = sn.snap_idand 
a.sql_id = p.sql_idand 
t.owner = s.owner 
and 
and 
and 
and 

t.table_name = s.segment_name 
t.table_name = p.name 
t.owner = p.owner 
t.owner not in ('SYS','SYSTEM')
havingsum(a.executions_delta) > 1group byto_char(sn.end_interval_time,'mm/dd/rr hh24'),p.owner, p.name,
t.num_rows, t.cache, t.buffer_pool, s.blocksorder by1 asc; 
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



• 
find_merge_joins.sql 
col c1 heading ‘Date’ format a20 
col c2 heading ‘Hash|Join|Count’ format 99,999,999col c3 heading ‘Rows|Processed’ format 99,999,999col c4 heading ‘Disk|Reads’ format 99,999,999col c5 heading ‘CPU|Time’ format 99,999,999 
ttitle ‘Merge Joins over time’ 
select

 to_char(
sn.begin_interval_time,
'yy-mm-dd hh24'
) snap_time,
count(*) ct,
sum(st.rows_processed_delta) row_ct,
sum(st.disk_reads_delta) disk,
sum(st.cpu_time_delta) cpu
from

where 
and 
st.dbid = sn.dbid 

dba_hist_snapshot sn,
dba_hist_sqlstat st,
dba_hist_sql_plan sp 
-- Additional cost licenses are required to access the dba_hist tables.
st.snap_id = sn.snap_id 
and 

st.instance_number = sn.instance_number 

and 

sp.sql_id = st.sql_idand 
sp.dbid = st.dbidand 
sp.plan_hash_value = st.plan_hash_valueand 
sp.operation = 'MERGE JOIN’group byto_char(sn.begin_interval_time,'yy-mm-dd hh24'); 
25 



• 
awr_nested_join_alert.sql 
col c1 heading ‘Date’ format a20 
col c2 heading ‘Nested|Loops|Count’ format 99,999,999col c3 heading ‘Rows|Processed’ format 99,999,999col c4 heading ‘Disk|Reads’ format 99,999,999col c5 heading ‘CPU|Time’ format 99,999,999 
accept nested_thr char prompt ‘Enter Nested Join Threshold: ‘ 
ttitle ‘Nested Join Threshold|&nested_thr’ 
select 

to_char(
sn.begin_interval_time,
'yy-mm-dd hh24'
) snap_time,
count(*) ct,
sum(st.rows_processed_delta) row_ct,
sum(st.disk_reads_delta) disk,
sum(st.cpu_time_delta) cpu
from 

dba_hist_snapshot sn,
dba_hist_sqlstat st,
dba_hist_sql_plan sp-- make sure that you are licensed to read the AWR tables
where 
and 
st.dbid = sn.dbid 

st.snap_id = sn.snap_id 
and 

st.instance_number = sn.instance_number 

and 

sp.sql_id = st.sql_idand 
sp.dbid = st.dbidand 
sp.plan_hash_value = st.plan_hash_valueand 
sp.operation = 'NESTED LOOPS'group byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
having 
count(*) > &nested_thr; 
26 



• 
hash_area.sql 
set heading off;
set feedback off;
set verify off;
set pages 999; 
spool run_hash.sql 
select 
'alter session set hash_area_size='||trunc(sum(bytes)*1.6)||';'
from 
dba_segmentswhere 
segment_name = upper('&1'); 
spool off; 
@run_hash 
27 



• 
hash_join_alert.sql 
col c1 heading ‘Date’ format a20 
col c2 heading ‘Hash|Join|Count’ format 99,999,999col c3 heading ‘Rows|Processed’ format 99,999,999col c4 heading ‘Disk|Reads’ format 99,999,999col c5 heading ‘CPU|Time’ format 99,999,999 
accept hash_thr char prompt ‘Enter Hash Join Threshold: ‘ 
ttitle ‘Hash Join Threshold|&hash_thr’ 
from 
dba_hist_snapshot sn,
dba_hist_sql_plan p,
dba_hist_sqlstat st 
where 
st.sql_id = p.sql_idand 
sn.snap_id = st.snap_idand 

select 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,


count(*) c2,
c3,
c4,
c5 
p.operation = 'HASH JOIN'havingcount(*) > &hash_thrgroup bybegin_interval_time; 
28 



 o.data_object_id = bh.objdand 
and 
o.data_object_id = bh.objdand 
and 
'alter '||s.segment_type||' '||t1.owner||'.'||s.segment_name||' storage(buffer_pool keep);'
from 
where 
and 
• 
buf_keep_pool.sql 
set pages 999 
set lines 92 

spool keep_syn.lst 
drop table t1; 
create table t1 as 
o.owner owner,
o.object_name object_name,
o.subobject_name subobject_name,
o.object_type object_type,
count(distinct file# || block#) num_blocks 
from 
dba_objects o,
v$bh bh 
select 

where 

o.owner not in ('SYS','SYSTEM') 
bh.status != 'free' 

group byo.owner,
o.object_name,
o.subobject_name,
o.object_typeorder bycount(distinct file# || block#) desc; 
select 

t1,
dba_segments s 

s.segment_name = t1.object_name 

s.owner = t1.owner 
and 

s.segment_type = t1.object_typeand 
nvl(s.partition_name,'-') = nvl(t1.subobject_name,'-')
and 
buffer_pool <> 'KEEP'and 
object_type in ('TABLE','INDEX')
group bys.segment_type,
t1.owner, 
29 



 s.segment_namehaving(sum(num_blocks)/greatest(sum(blocks), .001))*100 > 80; 

spool off; 

30 



• 
buf_keep_pool_5_tch_20_blks.sql 
-- ********************************************** 
-- **********************************************

-- You MUST connect as SYS to run this script 
connect sys/manager; 
set lines 80;
set pages 999; 
column avg_touches format 999 
column myname heading 'Name' format a30column mytype heading 'Type' format a10column buffers format 999,999 
SELECT 

object_type mytype,
object_name myname,
blocks,
COUNT(1) buffers,
AVG(tch) avg_touches
FROM 

WHERE 
and 
and 
GROUP BY 

sys.x$bh a,
dba_objects b,
dba_segments s 
a.obj = b.object_id 
b.object_name = s.segment_name 
b.owner not in ('SYS','SYSTEM') 
object_name,
object_type,
blocks,
objhavingavg(tch) > 5
and 

count(1) > 20; 
31 



• 
size_keep_pool.sql 
prompt The following will size your init.ora KEEP POOL,
prompt based on Oracle8 KEEP Pool assignment valuesprompt 
select 
'BUFFER_POOL_KEEP = ('||trunc(sum(s.blocks)*1.2)||',2)'
from 
dba_segments swhere 
s.buffer_pool = 'KEEP'; 
32 



• 
find_bif.sql 
set lines 2000; 
select 

sql_text,
disk_reads,
executions,
parse_callsfrom 
v$sqlareawhere 
lower(sql_text) like '% substr%'
or 
lower(sql_text) like '% to_char%'
or 
lower(sql_text) like '% decode%'
order bydisk_reads desc 
; 
33 



• 
awr_sql_index_access.sql 
col c1 heading ‘Begin|Interval|Time’ format a20 
col c2 heading ‘Index|Range|Scans’ format 999,999col c3 heading ‘Index|Unique|Scans’ format 999,999col c4 heading ‘Index|Full|Scans’ format 999,999 
select 
r.c1 c1,
r.c2 c2,
u.c2 c3,
f.c2 c4 
from 
select 
from 

( 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
where 
and 
and 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
p.object_owner <> 'SYS' 
p.operation like '%INDEX%' 
p.options like '%RANGE%' 
p.sql_id = s.sql_id 
select 

s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) r,
( 
from 

to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
where 
and 
and 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
p.object_owner <> 'SYS' 
p.operation like '%INDEX%' 
p.options like '%UNIQUE%' 
p.sql_id = s.sql_id 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) u, 
34 



(
select 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot snwhere 
p.object_owner <> 'SYS'and 
p.operation like '%INDEX%'
and 
p.options like '%FULL%'
and 
p.sql_id = s.sql_idand 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) fwhere 
(
select 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot snwhere 
p.object_owner <> 'SYS'and 
p.operation like '%INDEX%'
and 
p.options like '%FULL%'
and 
p.sql_id = s.sql_idand 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) fwhere 
r.c1 = u.c1 

and 
r.c1 = f.c1; 
35 



• 
awr_count_index_details.sql 
col c1 heading ‘Begin|Interval|time’ format a20col c2 heading ‘Search Columns’ format 999 
col c3 heading ‘Invocation|Count’ format 99,999,999 
break on c1 skip 2 
accept idxname char prompt ‘Enter Index Name: ‘ 
ttitle ‘Invocation Counts for index|&idxname’ 
from 
dba_hist_snapshotdba_hist_sql_plandba_hist_sqlstatwhere 
sn, 
p,
st 
st.sql_id = p.sql_idand 
sn.snap_id = st.snap_idand 

select 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,


p.search_columns c2,
c3 
p.object_name = ‘&idxname'group bybegin_interval_time,search_columns; 
36 



• 
index_range_scans.sql 
col c1 heading ‘Object|Name’ format a30 
col c2 heading ‘Option’ format a15 
col c3 heading ‘Index|Usage|Count’ format 999,999 
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
p.operation like ‘%INDEX%’
and 
p.sql_id = s.sql_idgroup byp.object_name,
p.operation,
p.optionsorder by1,2,3; 
37 



• 
busy_table_io.sql 
col c0 heading ‘Begin|Interval|time’ format a8col c1 heading ‘Table|Name’ format a20 
col c2 heading ‘Disk|Reads’ format 99,999,999col c3 heading ‘Rows|Processed’ format 99,999,999 
select 
* 

from (
select 
to_char(s.begin_interval_time,'mm-dd hh24') c0,
p.object_name c1,
sum(t.disk_reads_total) c2,
sum(t.rows_processed_total) c3,
DENSE_RANK() OVER (PARTITION BY to_char(s.begin_interval_time,'mm-ddhh24') ORDER BY SUM(t.disk_reads_total) desc) AS rnkfrom 
dba_hist_sql_plan p,
dba_hist_sqlstat t,
dba_hist_snapshot swhere 
p.sql_id = t.sql_idand 
t.snap_id = s.snap_idand 
p.object_type like '%TABLE%'
group byto_char(s.begin_interval_time,'mm-dd hh24'),
p.object_nameorder byc0 desc, rnk)
where rnk <= 5; 
38 



• 
count_table_access.sql 
col c1 heading ‘Object|Name’ format a30 
col c2 heading ‘Operation’ format a15 
col c3 heading ‘Option’ format a15 
col c4 heading ‘Object|Count’ format 999,999 
break on c1 skip 2break on c2 skip 2 
select 

p.object_name c1,
p.operation c2,
p.options c3,
count(1) c4 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s 
where 
p.object_owner <> 'SYS'and 
p.sql_id = s.sql_idgroup byp.object_name,
p.operation,
p.optionsorder by1,2,3; 
39 



• 
index_usage_hr.sql 
col c1 heading ‘Begin|Interval|time’ format a20col c2 heading ‘Search Columns’ format 999 
col c3 heading ‘Invocation|Count’ format 99,999,999 
break on c1 skip 2 
accept idxname char prompt ‘Enter Index Name: ‘ 
ttitle ‘Invocation Counts for index|&idxname’ 
from 
dba_hist_snapshotdba_hist_sql_plandba_hist_sqlstatwhere 
sn, 
p,
st 
st.sql_id = p.sql_idand 
sn.snap_id = st.snap_idand 

select 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,


p.search_columns c2,
c3 
p.object_name = ‘&idxname'group bybegin_interval_time,search_columns; 
40 



• 
awr_sql_index_freq.sql 
col c1 heading ‘Object|Name’ format a30 
col c2 heading ‘Operation’ format a15 
col c3 heading ‘Option’ format a15 
col c4 heading ‘Index|Usage|Count’ format 999,999 
break on c1 skip 2break on c2 skip 2 
select 

p.object_name c1,
p.operation c2,
p.options c3,
count(1) c4 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s 
where 
p.object_owner <> 'SYS'and 
p.operation like ‘%INDEX%’
and 
p.sql_id = s.sql_idgroup byp.object_name,
p.operation,
p.optionsorder by1,2,3; 
41 



• 
awr_access_counts.sql 
ttitle ‘Table Access|Operation Counts|Per Snapshot Period’ 
col c1 heading ‘Begin|Interval|time’ format a20col c2 heading ‘Operation’ format a15 
col c3 heading ‘Option’ format a15 
col c4 heading ‘Object|Count’ format 999,999 
break on c1 skip 2break on c2 skip 2 
select 

from 

to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
p.operation c2,
p.options c3,
count(1) c4 
where 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
p.object_owner <> 'SYS' 
p.sql_id = s.sql_id 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24'),
p.operation,
p.optionsorder by1,2,3; 
42 



• 
awr_sql_index_access.sql 
col c1 heading ‘Begin|Interval|Time’ format a20 
col c2 heading ‘Index|Range|Scans’ format 999,999col c3 heading ‘Index|Unique|Scans’ format 999,999col c4 heading ‘Index|Full|Scans’ format 999,999 
select 
r.c1 c1,
r.c2 c2,
u.c2 c3,
f.c2 c4 
from 
select 
from 

( 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
where 
and 
and 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
p.object_owner <> 'SYS' 
p.operation like '%INDEX%' 
p.options like '%RANGE%' 
p.sql_id = s.sql_id 
select 

s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) r,
( 
from 

to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
where 
and 
and 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
p.object_owner <> 'SYS' 
p.operation like '%INDEX%' 
p.options like '%UNIQUE%' 
p.sql_id = s.sql_id 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) u, 
43 



(
select 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot snwhere 
p.object_owner <> 'SYS'and 
p.operation like '%INDEX%'
and 
p.options like '%FULL%'
and 
p.sql_id = s.sql_idand 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) fwhere 
(
select 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot snwhere 
p.object_owner <> 'SYS'and 
p.operation like '%INDEX%'
and 
p.options like '%FULL%'
and 
p.sql_id = s.sql_idand 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) fwhere 
r.c1 = u.c1 

and 
r.c1 = f.c1; 
44 



• 
awr_sql_full_scans.sql 
col c1 heading ‘Begin|Interval|Time’ format a20 
col c2 heading ‘Index|Table|Scans’ format 999,999col c3 heading ‘Full|Table|Scans’ format 999,999 
select 
i.c1 c1,
i.c2 c2,
f.c2 c3 
from 
select 
from 

( 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
where 
and 
and 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
p.object_owner <> 'SYS' 
p.operation like '%TABLE ACCESS%' 
p.options like '%INDEX%' 
p.sql_id = s.sql_id 
select 

s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) i,
( 
from 

to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
where 
and 
and 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
p.object_owner <> 'SYS' 
p.operation like '%TABLE ACCESS%' 
p.options = 'FULL' 
p.sql_id = s.sql_id 
where 

s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) f 
i.c1 = f.c1; 
45 



• 
find_full_scans.sql 
set echo off;
set feedback on 
set pages 999;
column nbr_FTS format 999,999column num_rows format 999,999,999column blocks format 999,999column owner format a14;
column name format a24;
column ch format a1; 
column object_owner heading "Owner" format a12;
column ct heading "# of SQL selects" format 999,999; 
select 

from 
where 

object_owner,
count(*) ct 
v$sql_plan 
ct desc 

object_owner is not nullgroup byobject_ownerorder by 
;
--spool access.lst; 
set heading off;
set feedback off; 
set heading on;
set feedback on;
ttitle 'full table scans and counts| |The "K" indicates that the table isin the KEEP Pool (Oracle8).'
select 

from 

p.owner,
p.name,
t.num_rows, 
--ltrim(t.cache) ch,
decode(t.buffer_pool,'KEEP','Y','DEFAULT','N') K,
s.blocks blocks,
sum(a.executions) nbr_FTS 
dba_tables t,
dba_segments s,
v$sqlarea a,
(select distinctaddress,
object_owner owner,
object_name name
from 
where

v$sql_plan 
46 



 operation = 'TABLE ACCESS'and 
options = 'FULL') pwhere 
a.address = p.addressand 
operation = 'TABLE ACCESS'and 
options = 'FULL') pwhere 
a.address = p.addressand 
t.owner = s.owner 
and 
and 
and 
and 

t.table_name = s.segment_name 
t.table_name = p.name 
t.owner = p.owner 
t.owner not in ('SYS','SYSTEM')
havingsum(a.executions) > 9group byp.owner, p.name, t.num_rows, t.cache, t.buffer_pool, s.blocksorder bysum(a.executions) desc; 
column nbr_RID format 999,999,999column num_rows format 999,999,999column owner format a15;
column name format a25; 
ttitle 'Table access by ROWID and counts'
select 

from 

p.owner,
p.name,
t.num_rows,
sum(s.executions) nbr_RID 
from 
where 
and 


dba_tables t,
v$sqlarea s,
(select distinctaddress,
object_owner owner,
object_name name 
v$sql_plan 
operation = 'TABLE ACCESS' 
where 
and 
and 

options = 'BY ROWID') p 
s.address = p.address 
t.table_name = p.name 
t.owner = p.ownerhavingsum(s.executions) > 9group byp.owner, p.name, t.num_rowsorder bysum(s.executions) desc; 
47 



--************************************************* 
--************************************************* 

--Index Report Section 
column nbr_scans format 999,999,999column num_rows format 999,999,999column tbl_blocks format 999,999,999column owner format a9;
column table_name format a20;
column index_name format a20; 
ttitle 'Index full scans and counts' 
select 

p.owner,
d.table_name,
p.name index_name,
seg.blocks tbl_blocks,
sum(s.executions) nbr_scans
from 

dba_segments seg,
v$sqlarea s,
dba_indexes d,
(select distinctaddress,
object_owner owner,
object_name name
from 
where 
and 


v$sql_plan 
operation = 'INDEX' 
where 
and 
and 
and 

options = 'FULL SCAN') p 
d.index_name = p.name 
s.address = p.address 
d.table_name = seg.segment_name 
seg.owner = p.ownerhavingsum(s.executions) > 9group byp.owner, d.table_name, p.name, seg.blocksorder bysum(s.executions) desc; 
ttitle 'Index range scans and counts'
select 

p.owner,
d.table_name,
p.name index_name,
seg.blocks tbl_blocks,
sum(s.executions) nbr_scans
from 

dba_segments seg,
v$sqlarea s,
dba_indexes d, 
48 



 (select distinctaddress,
object_owner owner,
object_name namefrom 
v$sql_planwhere 
operation = 'INDEX'and 
options = 'RANGE SCAN') pwhere 
d.index_name = p.nameand 
s.address = p.addressand 
d.table_name = seg.segment_nameand 
seg.owner = p.ownerhavingsum(s.executions) > 9group byp.owner, d.table_name, p.name, seg.blocksorder bysum(s.executions) desc; 
ttitle 'Index unique scans and counts'select 
p.owner,
d.table_name,
p.name index_name,
sum(s.executions) nbr_scansfrom 
v$sqlarean s,
dba_indexes d,
(select distinctaddress,
object_owner owner,
object_name namefrom 
v$sql_planwhere 
operation = 'INDEX'and 
options = 'UNIQUE SCAN') pwhere 
d.index_name = p.nameand 
s.address = p.addresshavingsum(s.executions) > 9group byp.owner, d.table_name, p.nameorder bysum(s.executions) desc; 
(select distinctaddress,
object_owner owner,
object_name namefrom 
v$sql_planwhere 
operation = 'INDEX'and 
options = 'RANGE SCAN') pwhere 
d.index_name = p.nameand 
s.address = p.addressand 
d.table_name = seg.segment_nameand 
seg.owner = p.ownerhavingsum(s.executions) > 9group byp.owner, d.table_name, p.name, seg.blocksorder bysum(s.executions) desc; 
ttitle 'Index unique scans and counts'select 
p.owner,
d.table_name,
p.name index_name,
sum(s.executions) nbr_scansfrom 
v$sqlarean s,
dba_indexes d,
(select distinctaddress,
object_owner owner,
object_name namefrom 
v$sql_planwhere 
operation = 'INDEX'and 
options = 'UNIQUE SCAN') pwhere 
d.index_name = p.nameand 
s.address = p.addresshavingsum(s.executions) > 9group byp.owner, d.table_name, p.nameorder bysum(s.executions) desc; 
49 



• 
get_sql.sql 
set lines 2000; 
select 
sql_text,
disk_reads,
executions,
parse_callsfrom 
v$sqlareawhere 
lower(sql_text) like '% page %'
order bydisk_reads desc 
; 
50 



 (selectsq.sql_id,
round(sum(buffer_gets_delta) /
decode(sum(rows_processed_delta), 0, 1,
sum(rows_processed_delta))) c2,
sum(buffer_gets_delta) c3,
sum(rows_processed_delta) c4from 
where 
and 
and 
sn.instance_number = sq.instance_numberand 
(selectsq.sql_id,
round(sum(buffer_gets_delta) /
decode(sum(rows_processed_delta), 0, 1,
sum(rows_processed_delta))) c2,
sum(buffer_gets_delta) c3,
sum(rows_processed_delta) c4from 
where 
and 
and 
sn.instance_number = sq.instance_numberand 
• 
get_sub_optimal_cached_sql.sql 
set linesize 80 pagesize 80 trimspool on 
ttitle "Top 10 Expensive SQL | Consistent Gets per Rows Fetched" 
column sql_id heading "SQL ID"
column c2 heading "Avg Gets per Row"
column c3 heading "Total Gets"
column c4 heading "Total Rows" 
select 
* 

from 

dba_hist_snapshot sn,
dba_hist_sqlstat sq,
dba_hist_sqltext st 

sn.snap_id = sq.snap_id 

sn.dbid = sq.dbid 

sn.dbid = st.dbid 
and 

sq.sql_id = st.sql_idand 
lower(sql_text) not like '%sum(%'
and 
lower(sql_text) not like '%min(%'
and 
lower(sql_text) not like '%max(%'
and 
lower(sql_text) not like '%avg(%'
and 
lower(sql_text) not like '%count(%'
and 
sn.snap_id between &beginsnap and &endsnapand 
sq.parsing_schema_name not in ('SYS', 'SYSMAN', 'SYSTEM', 'MDSYS',
'WMSYS', 'TSMSYS', 'DBSNMP', 'OUTLN')
group bysq.sql_idorder by2 desc)
where 
rownum < 11;/ 
51 



• 
awr_expensive_sql.sql 
set linesize 80 pagesize 80 trimspool on 
ttitle "Top 10 Expensive SQL | Disk Reads per Rows Fetched" 
column sql_id heading "SQL ID"
column c2 heading "Avg Reads per Row"
column c3 heading "Total Reads"
column c4 heading "Total Rows" 
select 
* 
from 

(selectsq.sql_id,
round(sum(disk_reads_delta) /
decode(sum(rows_processed_delta),
0,1,
sum(rows_processed_delta))) c2,
sum(disk_reads_delta) c3,
sum(rows_processed_delta) c4from 
dba_hist_snapshot sn,
dba_hist_sqlstat sq,
dba_hist_sqltext st 
where 
sn.snap_id = sq.snap_idand 
sn.dbid = sq.dbidand 
sn.instance_number = sq.instance_numberand 
sn.dbid = st.dbid and sq.sql_id = st.sql_idand 
lower(sql_text) not like '%sum(%'
and 
lower(sql_text) not like '%min(%'
and 
lower(sql_text) not like '%max(%'
and 
lower(sql_text) not like '%avg(%'
and 
lower(sql_text) not like '%count(%'
and 
sn.snap_id between &beginsnap and &endsnapand 
sq.parsing_schema_name not in ('SYS', 'SYSMAN', 'SYSTEM', 'MDSYS',
'WMSYS', 'TSMSYS', 'DBSNMP', 'OUTLN')
group bysq.sql_idorder by2 desc)
where 
rownum < 11;
/ 
52 



• 
statspack_unused_indexes.sql 
ttitle "Unused Indexes by Time Period" 
col owner heading "Index Owner" format a30col index_name heading "Index Name" format a30 
set linesize 95 trimspool on pagesize 80 
select * 
from 
(selectowner,
index_name 
from 
dba_indexes di 
where 

di.index_type != 'LOB'and 
owner not in ('SYS', 'SYSMAN', 'SYSTEM', 'MDSYS', 'WMSYS', 'TSMSYS',
'DBSNMP', 'OUTLN')
minus 
select 
index_owner owner,
index_name 
from 
dba_constraints dc 
where 

minus 
select 

index_owner not in ('SYS', 'SYSMAN', 'SYSTEM', 'MDSYS', 'WMSYS',
'TSMSYS', 'DBSNMP', 'OUTLN') 
p.object_owner owner,
p.object_name index_name 
from 
stats$snapshot sn,
stats$sql_plan p,
stats$sql_summary st,
stats$sql_plan_usage spuwhere 
st.sql_id = spu.sql_idand 
spu.plan_hash_value = p.plan_hash_valueand 
st.hash_value = p.plan_hash_valueand 
sn.snap_id = st.snap_idand 
sn.dbid = st.dbid 

and 

sn.instance_number = st.instance_number 

and 

sn.snap_id = spu.snap_idand 
sn.dbid = spu.snap_idand 
sn.instance_number = spu.instance_numberand 
53 



 sn.snap_id between &begin_snap and &end_snap sn.snap_id between &begin_snap and &end_snap
and 

p.object_type = 'INDEX'
)
where owner not in ('SYS', 'SYSMAN', 'SYSTEM', 'MDSYS', 'WMSYS', 'TSMSYS',
'DBSNMP', 'OUTLN')
order by 1, 2;/ 
54 



• 
awr_unused_indexes.sql 
ttitle "Unused Indexes by Time Period" 
col owner heading "Index Owner" format a30col index_name heading "Index Name" format a30 
set linesize 95 trimspool on pagesize 80 
select * from 
(select owner, index_namefrom dba_indexes di 
where 
di.index_type != 'LOB'minus 
select index_owner owner, index_name
from dba_constraints dc 
minus 
select 

p.object_owner owner,
p.object_name index_namefrom 
dba_hist_snapshot sn,
dba_hist_sql_plan p,
dba_hist_sqlstat st 
where 
st.sql_id = p.sql_idand 
sn.snap_id = st.snap_id and sn.dbid = st.dbid and sn.instance_number =
st.instance_number 
and 
sn.snap_id between &begin_snap and &end_snapand 
p.object_type = 'INDEX'
)
where owner not in ('SYS', 'SYSMAN', 'SYSTEM', 'MDSYS', 'WMSYS', 'TSMSYS',
'DBSNMP', 'OUTLN')
order by 1, 2;
/ 
55 



• 
awr_infrequent_indexes.sql 
ttitle "Infrequently-used indexes by month" 
col c1 heading "Month" format a20 
col c2 heading "Index Owner" format a30 
col c3 heading "Index Name" format a30 
col c4 heading "Invocation|Count" format 99 
set linesize 95 trimspool on pagesize 80 
select 
to_char(sn.begin_interval_time,'Month') c1,
p.object_owner c2,
p.object_name c3,
sum(executions_delta) c4from 
dba_hist_snapshot sn,
dba_hist_sql_plan p,
dba_hist_sqlstat st 
where 
st.sql_id = p.sql_idand 
sn.snap_id = st.snap_idand 
sn.dbid = st.dbid 

and 

sn.instance_number = st.instance_number 

and 

p.object_type = 'INDEX'and 
p.object_owner not in ('SYS', 'SYSMAN', 'SYSTEM', 'MDSYS', 'WMSYS',
'TSMSYS', 'DBSNMP')
group byto_char(sn.begin_interval_time, 'Month'),
p.object_owner,
p.object_namehavingsum(executions_delta) < 50order by1, 4 desc, 2, 3;
/ 
56 



 y.index_name = b.index_nameand 
and 
and 
from 
dba_ind_columns b 
where 
a.index_owner not in ('SYS', 'SYSMAN', 'SYSTEM', 'MDSYS', 'WMSYS', 
and 
y.index_name = b.index_nameand 
and 
and 
from 
dba_ind_columns b 
where 
a.index_owner not in ('SYS', 'SYSMAN', 'SYSTEM', 'MDSYS', 'WMSYS', 
and 
• 
Find_duplicate_index_columns.sql 
set linesize 150 trimspool on pagesize 80 
column index_owner format a20 
column column_name format a30 

column position format 9column nextcol format a18 heading "Next Column Match?" 
select 
a.index_owner,
a.column_name,
a.index_name index_name1,
b.index_name index_name2,
a.column_position position,
(select'YES' 
from 
dba_ind_columns x,
dba_ind_columns ywhere 
x.index_owner = a.index_owner 

and 
and


y.index_owner = b.index_owner 
x.index_name = a.index_name 

and 

x.column_position = 2 
y.column_position = 2 
x.column_name = y.column_name) nextcol 

dba_ind_columns a, 

'TSMSYS', 'DBSNMP') 
a.index_owner = b.index_owner 

and 

a.column_name = b.column_name 

and 

a.table_name = b.table_name 

and 

a.index_name != b.index_name 

and 

a.column_position = 1and 
b.column_position = 1;
/ 
57 



• 
find_sparse_indexes.sql 
select 
‘exec analyzedb.reorg_a_table4(’||””||rtrim(t.table_owner)||””||’,'||””||
rtrim(t.table_name)||””||’);’,
t.table_owner||’.'||t.table_name name,
a.num_rows,
sum(t.inserts) ins,
sum(t.updates) upd,
sum(t.deletes) del,
sum(t.updates)+sum(t.inserts)+sum(t.deletes) tot_chgs,
to_char((sum(t.deletes)/(decode(a.num_rows,0,1,a.num_rows)))*100.0,’999999.99') per_del,
round(((sum(t.updates)+sum(t.inserts)+sum(t.deletes))/(decode(a.num_rows,0,1,a.num_rows)) *100.0),2) per_chgfrom 
analyzedb.table_modifications t,
all_tables a 
where 
and 
t.table_name=a.table_name 

t.timestamp >= to_date(’&from_date’,'dd-mon-yyyy’) 
t.table_owner = a.owner and t.table_owner not in (’SYS’,'SYSTEM’) and 
having(sum(t.deletes)/(decode(a.num_rows,0,1,a.num_rows)))*100.0 >=5group byt.table_owner, t.table_name, a.num_rowsorder bynum_rows desc, t.table_owner, t.table_name; 
58 



• 
show_ram_plan.sql 
select 

operation,
options,
object_name name,
trunc(bytes/1024/1024) "input(MB)",
trunc(last_memory_used/1024) last_mem,
trunc(estimated_optimal_size/1024) opt_mem,
trunc(estimated_onepass_size/1024) onepass_mem,
decode(optimal_executions, null, null,
optimal_executions||'/'||onepass_executions||'/'||
multipasses_exections) "O/1/M"
from 
v$sql_plan p,
v$sql_workarea w
where 
and 
and 
and 

p.address=w.address(+) 
p.hash_value=w.hash_value(+) 
p.id=w.operation_id(+) 
p.address='88BB460C'; 
59 



• 
monitor_hash_join_ful_ram.sql 
select 

tempseg_sizefrom 
v$sql_workarea_active; 
60 



• 
show_pga_ram_details.sql 
select 

to_number(decode(SID, 65535, NULL, SID)) sid,
operation_type OPERATION,
trunc(WORK_AREA_SIZE/1024) WSIZE,
trunc(EXPECTED_SIZE/1024) ESIZE,
trunc(ACTUAL_MEM_USED/1024) MEM,
trunc(MAX_MEM_USED/1024) "MAX MEM",
number_passes PASS 
from 

v$sql_workarea_activeorder by 1,2; 
61 



• 
track_hash_joins.sql 
select 
to_char(
sn.begin_interval_time,
'yy-mm-dd hh24'
) snap_time,
count(*) ct,
sum(st.rows_processed_delta) row_ct,
sum(st.disk_reads_delta) disk,
sum(st.cpu_time_delta) cpufrom 
dba_hist_snapshot sn,
dba_hist_sqlstat st,
dba_hist_sql_plan spwhere 
st.snap_id = sn.snap_idand 
st.dbid = sn.dbid 

and 

st.instance_number = sn.instance_number 

and 

sp.sql_id = st.sql_idand 
sp.dbid = st.dbidand 
sp.plan_hash_value = st.plan_hash_valueand 
sp.operation = 'HASH JOIN'group byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
having 
count(*) > &hash_thr; 
62 



• 
remote_sql_execution_plan.sql 
set long 2000set arraysize 1 
col operation format a22col options format a8col object_name format a10col object_node format a5col other format a20 
col position format 99999col optimizer format a10 
select 
lpad(' ',2*(level-1))||operation operation,
options,
object_name,
optimizer,
object_node,
other 
from 
start with id=0

plan_table 
connect by prior id=parent_id; 
63 



• 
parallel_tq_stats.sql 
select 
tq_id,
server_type,
process,
num_rows 
from 
v$pq_tqstatwhere 
dfo_number = 
from

(select max(dfo_number) 
v$pq_tqstat)
order bytq_id,
decode (substr(server_type,1,4),
'Prod', 0, 'Cons', 1, 3)
; 
64 



 to_char(snap_time,'yyyy-mm-dd HH24') mydate,
new.value nbr_pqfrom 
old, 
new, 
sn 
where 
to_char(snap_time,'yyyy-mm-dd HH24') mydate,
new.value nbr_pqfrom 
old, 
new, 
sn 
where 
new.name = 'queries parallelized'and 
and 
and 
• 
statspack_opq.sql 
set pages 9999; 
column nbr_pq format 999,999,999column mydate heading 'yr. mo dy Hr.' 
select 

perfstat.stats$sysstatperfstat.stats$sysstatperfstat.stats$snapshot 

new.name = old.name 
and 

new.snap_id = sn.snap_id 
old.snap_id = sn.snap_id-1 
new.value > 1 

order byto_char(snap_time,'yyyy-mm-dd HH24')
; 
65 



• 
parallel_plan.sql 
set echo off 
set long 2000set pagesize 10000 
column query heading "Query Plan" format a80column other heading "PQO/Remote Query" format a60 word_wrapcolumn x heading " " format a18 
select distinct 

object_node "TQs / Remote DBs"
from 
plan_tablewhere 
object_node is not nullorder byobject_node; 
select lpad(' ',2*(level-1))||operation||' '||options||' '
||object_name||' '
||decode(optimizer,'','','['||optimizer||'] ')
||decode(other_tag,'',decode(object_node,'','','['||object_node||']')
,'['||other_tag||' -> '||object_node||']')
||decode(id,0,'Cost = '||position) query,null x 
,otherfrom 
plan_tablestart with id = 0 
connect by prior id = parent_id; 
66 



• 
tsfree.sql 
column "Tablespace" format a13column "Used MB" format 99,999,999column "Free MB" format 99,999,999colimn "Total MB" format 99,999,999 
select 
fs.tablespace_name "Tablespace",
(df.totalspace - fs.freespace) "Used MB",
fs.freespace "Free MB",
df.totalspace "Total MB",
round(100 * (fs.freespace / df.totalspace)) "Pct. Free"
from 
(selecttablespace_name,
round(sum(bytes) / 1048576) TotalSpacefrom 
dba_data_files 

from 

group bytablespace_name) df,
(selecttablespace_name,
round(sum(bytes) / 1048576) FreeSpace 
where 

dba_free_spacegroup bytablespace_name) fs 
df.tablespace_name = fs.tablespace_name; 
67 



• 
statspack_find_chained_rows.sql 
column table_fetch_continued_row format 999,999,999 
select 

to_char(snap_time,'yyyy-mm-dd HH24'),
avg(newmem.value-oldmem.value)table_fetch_continued_rowfrom 
perfstat.stats$sysstat oldmem,
perfstat.stats$sysstat newmem,
perfstat.stats$snapshot sn 
where 
snap_time > sysdate-&1and 
newmem.snap_id = sn.snap_idand 
oldmem.snap_id = sn.snap_id-1and 
oldmem.name = 'table fetch continued row' 

and

 newmem.name = 'table fetch continued row' 

and

 newmem.value-oldmem.value > 0 

havingavg(newmem.value-oldmem.value) > 10000group byto_char(snap_time,'yyyy-mm-dd HH24'); 
68 



 (select table_name from dba_tab_columnswhere 
data_type in ('RAW','LONG RAW', 'BLOB', 'CLOB') 
and 
(select table_name from dba_tab_columnswhere 
data_type in ('RAW','LONG RAW', 'BLOB', 'CLOB') 
and 
• 
chained_row.sql 
-- ******************************************************* 
-- WARNING: This script relies on current CBO statistics-- ******************************************************* 
spool chain.lst;
set pages 9999; 
column c1 heading "Owner" format a9;
column c2 heading "Table" format a12;
column c3 heading "PCTFREE" format 99;
column c4 heading "PCTUSED" format 99;
column c5 heading "avg row" format 99,999;
column c6 heading "Rows" format 999,999,999;
column c7 heading "Chains" format 999,999,999;
column c8 heading "Pct" format .99; 
set heading off;
select 'Tables with migrated/chained rows and no BLOB columns.' from dual;
set heading on; 
select 

owner c1,
table_name c2,
pct_free c3,
pct_used c4,
avg_row_len c5, 
num_rows c6,
chain_cnt c7,
chain_cnt/num_rows c8
from dba_tables 
where 

and 
table_name not in 

owner not in ('SYS','SYSTEM') 
) 
chain_cnt > 0 

order by chain_cnt desc; 
69 



• 
index_range_scans.sql 
col c1 heading ‘Object|Name’ format a30 
col c2 heading ‘Option’ format a15 
col c3 heading ‘Index|Usage|Count’ format 999,999 
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
p.operation like ‘%INDEX%’
and 
p.sql_id = s.sql_idgroup byp.object_name,
p.operation,
p.optionsorder by1,2,3; 
70 



• 
busy_table_io.sql 
col c0 heading ‘Begin|Interval|time’ format a8col c1 heading ‘Table|Name’ format a20 
col c2 heading ‘Disk|Reads’ format 99,999,999col c3 heading ‘Rows|Processed’ format 99,999,999 
select 
* 

from (
select 
to_char(s.begin_interval_time,'mm-dd hh24') c0,
p.object_name c1,
sum(t.disk_reads_total) c2,
sum(t.rows_processed_total) c3,
DENSE_RANK() OVER (PARTITION BY to_char(s.begin_interval_time,'mm-ddhh24') ORDER BY SUM(t.disk_reads_total) desc) AS rnkfrom 
dba_hist_sql_plan p,
dba_hist_sqlstat t,
dba_hist_snapshot swhere 
p.sql_id = t.sql_idand 
t.snap_id = s.snap_idand 
p.object_type like '%TABLE%'
group byto_char(s.begin_interval_time,'mm-dd hh24'),
p.object_nameorder byc0 desc, rnk)
where rnk <= 5; 
71 



• 
count_table_access.sql 
col c1 heading ‘Object|Name’ format a30 
col c2 heading ‘Operation’ format a15 
col c3 heading ‘Option’ format a15 
col c4 heading ‘Object|Count’ format 999,999 
break on c1 skip 2break on c2 skip 2 
select 

p.object_name c1,
p.operation c2,
p.options c3,
count(1) c4 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s 
where 
p.object_owner <> 'SYS'and 
p.sql_id = s.sql_idgroup byp.object_name,
p.operation,
p.optionsorder by1,2,3; 
72 



• 
statspack_plot_sorts_dow.sql 
set pages 9999; 
column sorts_memory format 999,999,999column sorts_disk format 999,999,999column ratio format .99999 
select 

to_char(snap_time,'day') DAY,
avg(newmem.value-oldmem.value) sorts_memory,
avg(newdsk.value-olddsk.value) sorts_diskfrom 
perfstat.stats$sysstat oldmem,
perfstat.stats$sysstat newmem,
perfstat.stats$sysstat newdsk,
perfstat.stats$sysstat olddsk,
perfstat.stats$snapshot sn 
where 
newdsk.snap_id = sn.snap_idand 
olddsk.snap_id = sn.snap_id-1and 
newmem.snap_id = sn.snap_idand 
oldmem.snap_id = sn.snap_id-1and 
oldmem.name = 'sorts (memory)'
and 
newmem.name = 'sorts (memory)'
and 
olddsk.name = 'sorts (disk)'
and 
newdsk.name = 'sorts (disk)'
and 
newmem.value-oldmem.value > 0 
group byto_char(snap_time,'day'); 
73 



• 
statspack_plot_sorts_hod.sql 
set pages 9999; 
column sorts_memory format 999,999,999column sorts_disk format 999,999,999column ratio format .99999 
select 

to_char(snap_time,'HH24'),
avg(newmem.value-oldmem.value) sorts_memory,
avg(newdsk.value-olddsk.value) sorts_diskfrom 
perfstat.stats$sysstat oldmem,
perfstat.stats$sysstat newmem,
perfstat.stats$sysstat newdsk,
perfstat.stats$sysstat olddsk,
perfstat.stats$snapshot sn 
where 
newdsk.snap_id = sn.snap_idand 
olddsk.snap_id = sn.snap_id-1and 
newmem.snap_id = sn.snap_idand 
oldmem.snap_id = sn.snap_id-1and 
oldmem.name = 'sorts (memory)'
and 
newmem.name = 'sorts (memory)'
and 
olddsk.name = 'sorts (disk)'
and 
newdsk.name = 'sorts (disk)'
and 
newmem.value-oldmem.value > 0 
group byto_char(snap_time,'HH24')
; 
74 



 to_char(snap_time,'yyyy-mm-dd HH24') mydate,
newmem.value-oldmem.value sorts_memory,
newdsk.value-olddsk.value sorts_disk,
((newdsk.value-olddsk.value)/(newmem.value-oldmem.value)) ratiofrom 
where 
and 
and 
and 
and 
and 
and 
and 
and 
to_char(snap_time,'yyyy-mm-dd HH24') mydate,
newmem.value-oldmem.value sorts_memory,
newdsk.value-olddsk.value sorts_disk,
((newdsk.value-olddsk.value)/(newmem.value-oldmem.value)) ratiofrom 
where 
and 
and 
and 
and 
and 
and 
and 
and 
• 
statspack_sorts_alert.sql 
set pages 9999; 
column mydate heading 'Yr. Mo Dy Hr.' format a16 
column sorts_memory format 999,999,999column sorts_disk format 999,999,999column ratio format .99999 
select 

perfstat.stats$sysstat oldmem,
perfstat.stats$sysstat newmem,
perfstat.stats$sysstat newdsk,
perfstat.stats$sysstat olddsk,
perfstat.stats$snapshot sn 

newdsk.snap_id = sn.snap_id 
olddsk.snap_id = sn.snap_id-1 
newmem.snap_id = sn.snap_id 
oldmem.snap_id = sn.snap_id-1 
oldmem.name = 'sorts (memory)' 
newmem.name = 'sorts (memory)' 
olddsk.name = 'sorts (disk)' 
newdsk.name = 'sorts (disk)' 
newmem.value-oldmem.value > 0 

and 

newdsk.value-olddsk.value > 100 
; 
75 



• 
statspack_avg_sorts_hod.sql 
set pages 9999; 
column sorts_memory format 999,999,999column sorts_disk format 999,999,999column ratio format .99999 
select 

to_char(snap_time,'HH24'),
avg(newmem.value-oldmem.value) sorts_memory,
avg(newdsk.value-olddsk.value) sorts_diskfrom 
perfstat.stats$sysstat oldmem,
perfstat.stats$sysstat newmem,
perfstat.stats$sysstat newdsk,
perfstat.stats$sysstat olddsk,
perfstat.stats$snapshot sn 
where 
newdsk.snap_id = sn.snap_idand 
olddsk.snap_id = sn.snap_id-1and 
newmem.snap_id = sn.snap_idand 
oldmem.snap_id = sn.snap_id-1and 
oldmem.name = 'sorts (memory)'
and 
newmem.name = 'sorts (memory)'
and 
olddsk.name = 'sorts (disk)'
and 
newdsk.name = 'sorts (disk)'
and 
newmem.value-oldmem.value > 0 
group byto_char(snap_time,'HH24'); 
76 



• 
display_optimizer_features_by_release.sql 
set trimspool on 
col c1 heading “Release” format a8 
col c2 heading “Feature|Description” format a50 
select 
optimizer_feature_enable,
descriptionfrom 
v$system_fix_controlwhere 
substr(optimizer_feature_enable,1,2) = '11'
order byto_number(optimizer_feature_enable),
description; 
77 



• 
top_20_sessions.sql 
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
sum(decode(c.name,'execute count',value,0)) executionsfrom sys.v_$sesstat a,
sys.v_$session b,
sys.v_$statname c,
sys.v_$process d,
sys.v_$bgprocess ewhere a.statistic#=c.statistic# and 
b.sid=a.sid and 
d.addr = b.paddr ande.paddr (+) = b.paddr andc.NAME in ('physical reads',
'physical writes',
'physical writes direct',
'physical reads direct',
'physical writes direct (lob)',
'physical reads direct (lob)',
'db block gets',
'db block changes',
'consistent changes', 
78 



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
79 



• 
high_scan_sql.sql 
select 
c.username username,
count(a.hash_value) scan_countfrom 
sys.v_$sql_plan a,
sys.dba_segments b,
sys.dba_users c,
sys.v_$sql d 
where 
a.object_owner (+) = b.ownerand 
a.object_name (+) = b.segment_nameand 
b.segment_type IN ('TABLE', 'TABLE PARTITION')
and 
a.operation like '%TABLE%'
and 
a.options = 'FULL'and 
c.user_id = d.parsing_user_idand 
d.hash_value = a.hash_value 

and 

b.bytes / 1024 > 1024group byc.username 
order by2 desc; 
80 



• 
find_cartesian_joins.sql 
select 
username,
count(distinct c.hash_value) nbr_stmtsfrom 
sys.v_$sql a,
sys.dba_users b,
sys.v_$sql_plan cwhere 
a.parsing_user_id = b.user_idand 
options = 'CARTESIAN'and 
operation like '%JOIN%'
and 
a.hash_value = c.hash_value 

group byusername 
order by2 desc; 
81 



• 
high_resource_sql.sql 
select sql_text,
username,
disk_reads_per_exec,
buffer_gets,
disk_reads,
parse_calls,
sorts,
executions,
rows_processed,
hit_ratio,
first_load_time,
sharable_mem,
persistent_mem,
runtime_mem,
cpu_time,
elapsed_time,
address,
hash_value 
from 

(select sql_text ,
b.username ,
round((a.disk_reads/decode(a.executions,0,1,
a.executions)),2)
disk_reads_per_exec,
a.disk_reads ,
a.buffer_gets ,
a.parse_calls ,
a.sorts ,
a.executions ,
a.rows_processed ,100 - round(100 *
a.disk_reads/greatest(a.buffer_gets,1),2) hit_ratio,
a.first_load_time ,
sharable_mem ,
persistent_mem ,
runtime_mem,
cpu_time,
elapsed_time,
address,
hash_value 
from 
sys.v_$sqlarea a,
sys.all_users b 
where 
a.parsing_user_id=b.user_id andb.username not in ('sys','system')
order by 3 desc)
where rownum < 21; 
82 



• 
cartesian_sum.sql 
select 
count(distinct hash_value) carteisan_statements,
count(*) total_cartesian_joinsfrom 
sys.v_$sql_planwhere 
options = 'CARTESIAN'and 
operation like '%JOIN%' 
83 



• 
sql_cartesian.sql 
select * 
from 
sys.v_$sqlwhere 
hash_value in 
(select hash_valuefrom 
sys.v_$sql_planwhere 
options = 'CARTESIAN'and 
operation LIKE '%JOIN%' )
order byhash_value; 
84 



 sql_text,
total_large_scans,
executions,
executions * total_large_scans sum_large_scansfrom 
executions 
sql_text,
total_large_scans,
executions,
executions * total_large_scans sum_large_scansfrom 
executions 
sys.v_$sql_plan a,
sys.dba_segments b,
sys.v_$sql c 
where 
and 
and 
and 
and 
and 
• 
large_scan_count.sql 
select 

(selectsql_text,
count(*) total_large_scans, 

from 

a.object_owner (+) = b.owner 
a.object_name (+) = b.segment_name 
b.segment_type IN ('TABLE', 'TABLE PARTITION') 
a.operation LIKE '%TABLE%' 
a.options = 'FULL' 
c.hash_value = a.hash_value 


and 

b.bytes / 1024 > 1024group bysql_text, executions)
order by4 desc; 
85 



• 
tabscan.sql 
select 
table_owner,
table_name,
table_type,
size_kb, 
statement_count,
reference_count,
executions,
executions * reference_count total_scans 
from 

(selecta.object_owner table_owner,
a.object_name table_name,
b.segment_type table_type,
b.bytes / 1024 size_kb,
sum(c.executions ) executions,
count( distinct a.hash_value ) statement_count,
count( * ) reference_count
from 

where 

sys.v_$sql_plan a,
sys.dba_segments b,
sys.v_$sql c 
a.object_owner (+) = b.ownerand a.object_name (+) = b.segment_nameand b.segment_type in ('TABLE', 'TABLE PARTITION')
and a.operation like '%TABLE%'
and a.options = 'FULL'
and a.hash_value = c.hash_value 

and b.bytes / 1024 > 1024group bya.object_owner, a.object_name, a.operation,
b.bytes / 1024, b.segment_typeorder by4 desc, 1, 2 ); 
86 



• 
display_top_sql_disk_reads.sql 
select 
sql_id,
child_number,
sql_text,
disk_reads 
from 

(selectsql_id_child_number,
sql_text,
elaped_time,
cpu_time,
disk_reads,
rank () over(order by disk_reads desc)
as 
sql_rankfrom 
v$sql)
where 
sql_rank < 10; 
87 



• 
display_top_sql_elspsed_time.sql 
select 
sql_id,
child_number,
sql_text,
elapsed_timefrom 
(selectsql_id_child_number,
sql_text,
elaped_time,
cpu_time,
disk_reads,
rank ()
over 
(order by elapsed_time desc)
as 
sql_rankfrom 
v$sql)
where 
sql_rank < 10; 
88 



• 
fullsql.sql 
select 
sql_textfrom 
sys.v_$sqltextwhere 
hash_value = <enter hash value for sql statement>
order bypiece; 
89 



• 
planstats.sql 
select 

operation,
options,
object_owner,
object_name,
executions,
last_output_rows,
last_cr_buffer_gets,
last_cu_buffer_gets,
last_disk_reads,
last_disk_writes,
last_elapsed_timefrom 
sys.v_$sql_plan a,
sys.v_$sql_plan_statistics b
where 

a.hash_value = b.hash_value and 

a.id = b.operation_id anda.hash_value = <enter hash value> 
order by a.id; 
90 



• 
awr_dba_hist_sql_plan.sql 
select 

from 

p.object_owner c1,
p.object_type c2,
p.object_name c3,
avg(p.cpu_cost) c4,
avg(p.io_cost) c5 
dba_hist_sql_plan pgroup byp.object_owner,
p.object_type,
p.object_nameorder by 1,2,4 desc; 
91 



• 
unused_indx.sql 
order by1, 2; 
select distinct 

d.index_name index_name 

a.object_owner table_owner,
a.object_name table_name,
b.segment_type table_type,
b.bytes / 1024 size_kb, 
from 

where 

sys.v_$sql_plan a,
sys.dba_segments b,
sys.dba_indexes d 
and b.owner = d.table_owner 

a.object_owner (+) = b.ownerand a.object_name (+) = b.segment_nameand b.segment_type in ('TABLE', 'TABLE PARTITION')
and a.operation like '%TABLE%'
and a.options = 'FULL'and b.bytes / 1024 > 1024and b.segment_name = d.table_name 
v$sqlarea cursor details: 

select 
sql_id,
address,
hash_value,
sharable_mem,
persistent_mem,
runtime_mem,
version_count,
loaded_versions,
open_versions,
invalidations,
parse_calls,
kept_versions,
last_active_child_address,
bind_data 
from 
v$sqlarea; 
v$sql cursor details: 

select 
sql_id,
loaded_versions,
open_versions, 
92 



 parse_calls,
kept_versions,
plan_hash_value,
child_number,
child_address,
literal_hash_value 
from 
v$sql; 
parse_calls,
kept_versions,
plan_hash_value,
child_number,
child_address,
literal_hash_value 
from 
v$sql; 
v$open_cursor details: 

select 
sql_id,
sql_text,
saddr,
address,
hash_value,
sql_exec_idfrom 
v$open_cursor; 
93 



• 
display_parent_n_child_cursors.sql 
select 
address parent_cursor,
child_address child_cursor,
sql_textfrom 
v$sqlwhere 
lower(sql_text) like 'insert_start_of_your_sql_statement_here%'; 
94 



• 
sql_shared_cursor.sql 
select version_count,address,hash_value,parsing_schema_name,reason,sql_textfrom (
select 

address,''
||decode(max( UNBOUND_CURSOR),'Y', ' 
UNBOUND_CURSOR')
||decode(max( SQL_TYPE_MISMATCH),'Y', ' 
SQL_TYPE_MISMATCH')
||decode(max( OPTIMIZER_MISMATCH),'Y', ' 
OPTIMIZER_MISMATCH')
||decode(max( OUTLINE_MISMATCH),'Y', ' 
OUTLINE_MISMATCH')
||decode(max( STATS_ROW_MISMATCH),'Y', ' 
STATS_ROW_MISMATCH')
||decode(max( LITERAL_MISMATCH),'Y', ' 
LITERAL_MISMATCH')
||decode(max( SEC_DEPTH_MISMATCH),'Y', ' 
SEC_DEPTH_MISMATCH')
||decode(max( EXPLAIN_PLAN_CURSOR),'Y', ' 
EXPLAIN_PLAN_CURSOR')
||decode(max( BUFFERED_DML_MISMATCH),'Y', ' 
BUFFERED_DML_MISMATCH')
||decode(max( PDML_ENV_MISMATCH),'Y', ' 
PDML_ENV_MISMATCH')
||decode(max( INST_DRTLD_MISMATCH),'Y', ' 
INST_DRTLD_MISMATCH')
||decode(max( SLAVE_QC_MISMATCH),'Y', ' 
SLAVE_QC_MISMATCH')
||decode(max( TYPECHECK_MISMATCH),'Y', ' 
TYPECHECK_MISMATCH')
||decode(max( AUTH_CHECK_MISMATCH),'Y', ' 
AUTH_CHECK_MISMATCH')
||decode(max( BIND_MISMATCH),'Y', ' 
BIND_MISMATCH')
||decode(max( DESCRIBE_MISMATCH),'Y', ' 
DESCRIBE_MISMATCH')
||decode(max( LANGUAGE_MISMATCH),'Y', ' 
LANGUAGE_MISMATCH')
||decode(max( TRANSLATION_MISMATCH),'Y', ' 
TRANSLATION_MISMATCH')
||decode(max( ROW_LEVEL_SEC_MISMATCH),'Y', ' 
ROW_LEVEL_SEC_MISMATCH')
||decode(max( INSUFF_PRIVS),'Y', ' 
INSUFF_PRIVS')
||decode(max( INSUFF_PRIVS_REM),'Y', ' 
INSUFF_PRIVS_REM')
||decode(max( REMOTE_TRANS_MISMATCH),'Y', ' 
REMOTE_TRANS_MISMATCH')
||decode(max( LOGMINER_SESSION_MISMATCH),'Y', ' 
LOGMINER_SESSION_MISMATCH')
||decode(max( INCOMP_LTRL_MISMATCH),'Y', ' 
INCOMP_LTRL_MISMATCH')
||decode(max( OVERLAP_TIME_MISMATCH),'Y', ' 
OVERLAP_TIME_MISMATCH') 
95 



 ||decode(max( SQL_REDIRECT_MISMATCH),'Y', ' 
SQL_REDIRECT_MISMATCH')
||decode(max( MV_QUERY_GEN_MISMATCH),'Y', ' 
MV_QUERY_GEN_MISMATCH')
||decode(max( USER_BIND_PEEK_MISMATCH),'Y', ' 
USER_BIND_PEEK_MISMATCH')
||decode(max( TYPCHK_DEP_MISMATCH),'Y', ' 
TYPCHK_DEP_MISMATCH')
||decode(max( NO_TRIGGER_MISMATCH),'Y', ' 
NO_TRIGGER_MISMATCH')
||decode(max( FLASHBACK_CURSOR),'Y', ' 
FLASHBACK_CURSOR')
||decode(max( ANYDATA_TRANSFORMATION),'Y', ' 
ANYDATA_TRANSFORMATION')
||decode(max( INCOMPLETE_CURSOR),'Y', ' 
INCOMPLETE_CURSOR')
||decode(max( TOP_LEVEL_RPI_CURSOR),'Y', ' 
TOP_LEVEL_RPI_CURSOR')
||decode(max( DIFFERENT_LONG_LENGTH),'Y', ' 
DIFFERENT_LONG_LENGTH')
||decode(max( LOGICAL_STANDBY_APPLY),'Y', ' 
LOGICAL_STANDBY_APPLY')
||decode(max( DIFF_CALL_DURN),'Y', ' 
DIFF_CALL_DURN')
||decode(max( BIND_UACS_DIFF),'Y', ' 
BIND_UACS_DIFF')
||decode(max( PLSQL_CMP_SWITCHS_DIFF),'Y', ' 
PLSQL_CMP_SWITCHS_DIFF')
||decode(max( CURSOR_PARTS_MISMATCH),'Y', ' 
CURSOR_PARTS_MISMATCH')
||decode(max( STB_OBJECT_MISMATCH),'Y', ' 
STB_OBJECT_MISMATCH')
||decode(max( ROW_SHIP_MISMATCH),'Y', ' 
ROW_SHIP_MISMATCH')
||decode(max( PQ_SLAVE_MISMATCH),'Y', ' 
PQ_SLAVE_MISMATCH')
||decode(max( TOP_LEVEL_DDL_MISMATCH),'Y', ' 
TOP_LEVEL_DDL_MISMATCH')
||decode(max( MULTI_PX_MISMATCH),'Y', ' 
MULTI_PX_MISMATCH')
||decode(max( BIND_PEEKED_PQ_MISMATCH),'Y', ' 
BIND_PEEKED_PQ_MISMATCH')
||decode(max( MV_REWRITE_MISMATCH),'Y', ' 
MV_REWRITE_MISMATCH')
||decode(max( ROLL_INVALID_MISMATCH),'Y', ' 
ROLL_INVALID_MISMATCH')
||decode(max( OPTIMIZER_MODE_MISMATCH),'Y', ' 
OPTIMIZER_MODE_MISMATCH')
||decode(max( PX_MISMATCH),'Y', ' 
PX_MISMATCH')
||decode(max( MV_STALEOBJ_MISMATCH),'Y', ' 
MV_STALEOBJ_MISMATCH')
||decode(max( FLASHBACK_TABLE_MISMATCH),'Y', ' 
FLASHBACK_TABLE_MISMATCH')
||decode(max( LITREP_COMP_MISMATCH),'Y', ' 
LITREP_COMP_MISMATCH') 
||decode(max( SQL_REDIRECT_MISMATCH),'Y', ' 
SQL_REDIRECT_MISMATCH')
||decode(max( MV_QUERY_GEN_MISMATCH),'Y', ' 
MV_QUERY_GEN_MISMATCH')
||decode(max( USER_BIND_PEEK_MISMATCH),'Y', ' 
USER_BIND_PEEK_MISMATCH')
||decode(max( TYPCHK_DEP_MISMATCH),'Y', ' 
TYPCHK_DEP_MISMATCH')
||decode(max( NO_TRIGGER_MISMATCH),'Y', ' 
NO_TRIGGER_MISMATCH')
||decode(max( FLASHBACK_CURSOR),'Y', ' 
FLASHBACK_CURSOR')
||decode(max( ANYDATA_TRANSFORMATION),'Y', ' 
ANYDATA_TRANSFORMATION')
||decode(max( INCOMPLETE_CURSOR),'Y', ' 
INCOMPLETE_CURSOR')
||decode(max( TOP_LEVEL_RPI_CURSOR),'Y', ' 
TOP_LEVEL_RPI_CURSOR')
||decode(max( DIFFERENT_LONG_LENGTH),'Y', ' 
DIFFERENT_LONG_LENGTH')
||decode(max( LOGICAL_STANDBY_APPLY),'Y', ' 
LOGICAL_STANDBY_APPLY')
||decode(max( DIFF_CALL_DURN),'Y', ' 
DIFF_CALL_DURN')
||decode(max( BIND_UACS_DIFF),'Y', ' 
BIND_UACS_DIFF')
||decode(max( PLSQL_CMP_SWITCHS_DIFF),'Y', ' 
PLSQL_CMP_SWITCHS_DIFF')
||decode(max( CURSOR_PARTS_MISMATCH),'Y', ' 
CURSOR_PARTS_MISMATCH')
||decode(max( STB_OBJECT_MISMATCH),'Y', ' 
STB_OBJECT_MISMATCH')
||decode(max( ROW_SHIP_MISMATCH),'Y', ' 
ROW_SHIP_MISMATCH')
||decode(max( PQ_SLAVE_MISMATCH),'Y', ' 
PQ_SLAVE_MISMATCH')
||decode(max( TOP_LEVEL_DDL_MISMATCH),'Y', ' 
TOP_LEVEL_DDL_MISMATCH')
||decode(max( MULTI_PX_MISMATCH),'Y', ' 
MULTI_PX_MISMATCH')
||decode(max( BIND_PEEKED_PQ_MISMATCH),'Y', ' 
BIND_PEEKED_PQ_MISMATCH')
||decode(max( MV_REWRITE_MISMATCH),'Y', ' 
MV_REWRITE_MISMATCH')
||decode(max( ROLL_INVALID_MISMATCH),'Y', ' 
ROLL_INVALID_MISMATCH')
||decode(max( OPTIMIZER_MODE_MISMATCH),'Y', ' 
OPTIMIZER_MODE_MISMATCH')
||decode(max( PX_MISMATCH),'Y', ' 
PX_MISMATCH')
||decode(max( MV_STALEOBJ_MISMATCH),'Y', ' 
MV_STALEOBJ_MISMATCH')
||decode(max( FLASHBACK_TABLE_MISMATCH),'Y', ' 
FLASHBACK_TABLE_MISMATCH')
||decode(max( LITREP_COMP_MISMATCH),'Y', ' 
LITREP_COMP_MISMATCH')
reason 
from 

v$sql_shared_cursor 
96 


group byaddress 
) join v$sqlarea using(address) where version_count>&versionsorder by version_count desc,address; 
group byaddress 
) join v$sqlarea using(address) where version_count>&versionsorder by version_count desc,address; 
97 



• 
rpt_lib.sql 
set lines 80;
set pages 999; 
column mydate heading 'Yr. Mo Dy Hr.' format a16 
column reloads format 999,999,999column hit_ratio format 999.99 
column pin_hit_ratio format 999.99 
break on mydate skip 2;
select 
to_char(snap_time,'yyyy-mm-dd HH24') mydate,
new.namespace,
(new.gethits-old.gethits)/(new.gets-old.gets) hit_ratio,
(new.pinhits-old.pinhits)/(new.pins-old.pins) pin_hit_ratio,
new.reloads 
from 

stats$librarycache old,
stats$librarycache new,
stats$snapshot sn 
where 
new.snap_id = sn.snap_idand 
old.snap_id = new.snap_id-1and 
old.namespace = new.namespaceand 
new.gets-old.gets > 0and 
new.pins-old.pins > 0; 
98 



• 
library_cache_miss.sql 
set lines 80;
set pages 999; 
column mydate heading 'Yr. Mo Dy Hr.' format a16 
column c1 heading "execs" format 9,999,999column c2 heading "Cache Misses|While Executing" format 9,999,999column c3 heading "Library Cache|Miss Ratio" format 999.99999 
break on mydate skip 2; 
select 

to_char(snap_time,'yyyy-mm-dd HH24') mydate,
sum(new.pins-old.pins) c1,
sum(new.reloads-old.reloads) c2,
sum(new.reloads-old.reloads)/
sum(new.pins-old.pins) c3 
from 
stats$librarycache old,
stats$librarycache new,
stats$snapshot sn 
where 
new.snap_id = sn.snap_idand 
old.snap_id = new.snap_id-1and 
old.namespace = new.namespacegroup byto_char(snap_time,'yyyy-mm-dd HH24'); 
99 



• 
library_cache_hit_ratio.sql 
select 
'Buffer Cache' name,
round ( (congets.value + dbgets.value - physreads.value) * 100/ (congets.value + dbgets.value), 2) valuefrom 
v$sysstat congets,
v$sysstat dbgets,
v$sysstat physreadswhere 
congets.name = 'consistent gets'and 
dbgets.name = 'db block gets'and 
physreads.name = 'physical reads'union all 
select 
'execute/noparse',
decode (sign (round ( (ec.value - pc.value)
* 100 
/ decode (ec.value, 0, 1, ec.value), 2)), -1, 0, round ( (ec.value -
pc.value) * 100 / decode (ec.value, 0, 1, ec.value), 2))
from 
v$sysstat ec,
v$sysstat pcwhere 
and 
pc.name in ('parse count', 'parse count (total)')
union all 
ec.name = 'execute count' 

select 

'Memory Sort',
round ( ms.value / decode ((ds.value + ms.value), 0, 1, (ds.value +
ms.value)) * 100, 2)
from 

where 
and 
union all 

v$sysstat ds,
v$sysstat ms 
ms.name = 'sorts (memory)' 
ds.name = 'sorts (disk)' 
select 

select 
'sql area get hitrate', round (gethitratio * 100, 2)
from 
v$librarycachewhere 
namespace = 'SQL AREA'union all 
'avg latch hit (no miss)',
round ((sum (gets) - sum (misses)) * 100 / sum (gets), 2)
from 
v$latch 

100 



union all 
select 

'avg latch hit (no sleep)',
round ((sum (gets) - sum (sleeps)) * 100 / sum (gets), 2)
from 
v$latch; 
101 



• 
hwm_open_cursors.sql 
set trimspool onset linesize 180 
col hwm_open_cur format 99,999col max_open_cur format 99,999 
select 
max(a.value) as hwm_open_cur,
p.value as max_open_curfrom 
v$sesstat a,
v$statname b,
v$parameter pwhere 
a.statistic# = b.statistic# 

and 
b.name = 'opened cursors current'and 
p.name= 'open_cursors'group by p.value; 
102 



• 
monitor_open_cursors.sql 
select 
stat.value, 
sess.username,
sess.sid,
sess.serial# 
from 

v$sesstat stat,
v$statname b,
v$session sess 
where 

stat.statistic# = b.statistic# 
and 

sess.sid=stat.sid 
and 

b.name = 'opened cursors current'; 
103 



• 
user_open_cursors.sql 
select 

sum(stat.value)
total_cur,
avg(stat.value) avg_cur,
max(stat.value) max_cur,
sess.username,
sess.machine 
from 

v$sesstat stat,
v$statname b,
v$session sess 
where 

stat.statistic# = b.statistic# 
and 

sess.sid=stat.sid 
and 

b.name = 'opened cursors current'group bysess.username,
sess.machine 
order by 1 desc; 
104 



• 
monitor_session_cached_cursors.sql 
col c1 heading "SID"
col c2 heading "Cache|Hits"
col c3 heading "All Parsing"
col c4 heading "Un-used Session|Cached Cursors" 
select 
stat1.sid c1,
stat1.value c2,
stat2.value c3,
stat2.value c4 
from 
v$sesstat stat1,
v$sesstat stat2,
v$statname name1,
v$statname name2 
where 
stat1.statistic# = name1.statistic# 
and 
stat2.statistic#=name2.statistic# 
and 
name1.name = 'session cursor cache hits' 

and 
name2.name= 'parse count (total)'
and 
stat2.sid= stat1.sid; 
105 



• 
check_bind_sensitive_sql.sql 
select 
sql_id,
child_number,
is_bind_sensitive,
is_bind_aware 
from 
v$sqlwhere 
sql_text =
'select 
max(id)
from 
acs_test_tab 
where 

record_type = :l_record_type'; 
106 



• 
sqlstat_deltas.sql 
col c1 heading ‘Begin|Interval|time’ format a8 
col c2 heading ‘SQL|ID’ format a13 
col c3 heading ‘Exec|Delta’ format 9,999col c4 heading ‘Buffer|Gets|Delta’ format 9,999col c5 heading ‘Disk|Reads|Delta’ format 9,999col c6 heading ‘IO Wait|Delta’ format 9,999col c7 heading ‘Application|Wait|Delta’ format 9,999col c8 heading ‘Concurrency|Wait|Delta’ format 9,999 
break on c1 
select 
to_char(s.begin_interval_time,’mm-dd hh24’) c1,
sql.sql_id c2,
sql.executions_delta c3,
sql.buffer_gets_delta c4,
sql.disk_reads_delta c5,
sql.iowait_delta c6,
sql.apwait_delta c7,
sql.ccwait_delta c8 
from 
dba_hist_sqlstat sql,
dba_hist_snapshot s 
where 
s.snap_id = sql.snap_idorder byc1,
c2; 
107 



• 
sqlstat_deltas_detail.sql 
col c1 heading ‘Begin|Interval|time’ format a8 
col c2 heading ‘Exec|Delta’ format 999,999col c3 heading ‘Buffer|Gets|Delta’ format 999,999col c4 heading ‘Disk|Reads|Delta’ format 9,999col c5 heading ‘IO Wait|Delta’ format 9,999col c6 heading ‘App|Wait|Delta’ format 9,999col c7 heading ‘Cncr|Wait|Delta’ format 9,999col c8 heading ‘CPU|Time|Delta’ format 999,999col c9 heading ‘Elpsd|Time|Delta’ format 999,999 
accept sqlid prompt ‘Enter SQL ID: ‘ 
ttitle ‘time series execution for|&sqlid’ 
break on c1 
select 
to_char(s.begin_interval_time,’mm-dd hh24’) c1,
sql.executions_delta c2,
sql.buffer_gets_delta c3,
sql.disk_reads_delta c4,
sql.iowait_delta c5,
sql.apwait_delta c6,
sql.ccwait_delta c7,
sql.cpu_time_delta c8,
sql.elapsed_time_delta c9 
from 
dba_hist_sqlstat sql,
dba_hist_snapshot s 
where 
s.snap_id = sql.snap_idand 
sql_id = ‘&sqlid’order by c1; 
108 



• 
high_cost_sql.sql 
col c1 heading ‘SQL|ID’ format a13 
col c2 heading ‘Cost’ format 9,999,999col c3 heading ‘SQL Text’ format a200 
select 

p.sql_id c1, 
p.cost c2,
to_char(s.sql_text) c3from 
dba_hist_sql_plan p,
dba_hist_sqltext s 
where 
p.id = 0and 
p.sql_id = s.sql_idand 
p.cost is not nullorder byp.cost desc; 
109 



• 
sql_object_char.sql 
col c1 heading ‘Owner’ format a13 
col c2 heading ‘Object|Type’ format a15 
col c3 heading ‘Object|Name’ format a25 
col c4 heading ‘Average|CPU|Cost’ format 9,999,999col c5 heading ‘Average|IO|Cost’ format 9,999,999 
break on c1 skip 2break on c2 skip 2 
select 

p.object_owner c1,
p.object_type c2,
p.object_name c3,
avg(p.cpu_cost) c4,
avg(p.io_cost) c5 
from 
where 
and 

dba_hist_sql_plan p 
p.object_name is not null 
p.object_owner <> 'SYS'group byp.object_owner,
p.object_type,
p.object_nameorder by1,2,4 desc; 
110 



• 
sql_object_char_detail.sql 
accept tabname prompt ‘Enter Table Name:’ 
col c0 heading ‘Begin|Interval|time’ format a8col c1 heading ‘Owner’ format a10 
col c2 heading ‘Object|Type’ format a10 
col c3 heading ‘Object|Name’ format a15 
col c4 heading ‘Average|CPU|Cost’ format 9,999,999col c5 heading ‘Average|IO|Cost’ format 9,999,999 
break on c1 skip 2break on c2 skip 2 
select 

to_char(sn.begin_interval_time,'mm-dd hh24') c0,
p.object_owner c1,
p.object_type c2,
p.object_name c3,
avg(p.cpu_cost) c4,
avg(p.io_cost) c5 
from 

where 
and 
and 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat st,
dba_hist_snapshot sn 
p.object_name is not null 
p.object_owner <> 'SYS' 
p.object_name = 'CUSTOMER_DETS' 
p.sql_id = st.sql_id 
st.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'mm-dd hh24'),
p.object_owner,
p.object_type,
p.object_nameorder by1,2,3 desc; 
111 



• 
nested_join_alert.sql 
col c1 heading ‘Date’ format a20 
col c2 heading ‘Nested|Loops|Count’ format 99,999,999col c3 heading ‘Rows|Processed’ format 99,999,999col c4 heading ‘Disk|Reads’ format 99,999,999col c5 heading ‘CPU|Time’ format 99,999,999 
accept nested_thr char prompt ‘Enter Nested Join Threshold: ‘ 
ttitle ‘Nested Join Threshold|&nested_thr’ 
select 

to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(*) c2,
sum(st.rows_processed_delta) c3,
sum(st.disk_reads_delta) c4,
sum(st.cpu_time_delta) c5 
from 

where 
and 
and 

dba_hist_snapshot sn,
dba_hist_sql_plan p,
dba_hist_sqlstat st 
st.sql_id = p.sql_id 
sn.snap_id = st.snap_id 
p.operation = ‘NESTED LOOPS’havingcount(*) > &hash_thrgroup bybegin_interval_time; 
112 



• 
sql_index.sql 
col c0 heading ‘Begin|Interval|time’ format a8col c1 heading ‘Index|Name’ format a20 
col c2 heading ‘Disk|Reads’ format 99,999,999col c3 heading ‘Rows|Processed’ format 99,999,999 
select 

to_char(s.begin_interval_time,'mm-dd hh24') c0,
p.object_name c1,
sum(t.disk_reads_total) c2,
sum(t.rows_processed_total) c3
from 

where 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat t,
dba_hist_snapshot s 
p.sql_id = t.sql_id 
t.snap_id = s.snap_id 
p.object_type like '%INDEX%'
group byto_char(s.begin_interval_time,'mm-dd hh24'),
p.object_nameorder byc0,c1,c2 desc; 
113 



• 
sql_index_access.sql 
col c1 heading ‘Begin|Interval|Time’ format a20 
col c2 heading ‘Index|Range|Scans’ format 999,999col c3 heading ‘Index|Unique|Scans’ format 999,999col c4 heading ‘Index|Full|Scans’ format 999,999 
select 
r.c1 c1,
r.c2 c2,
u.c2 c3,
f.c2 c4 
from 
select 
from 

( 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
where 
and 
and 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
p.object_owner <> 'SYS' 
p.operation like '%INDEX%' 
p.options like '%RANGE%' 
p.sql_id = s.sql_id 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) r,
(
select 

from 

to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
where 
and 
and 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
p.object_owner <> 'SYS' 
p.operation like '%INDEX%' 
p.options like '%UNIQUE%' 
p.sql_id = s.sql_id 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) u, 
114 



(
select 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot snwhere 
p.object_owner <> 'SYS'and 
p.operation like '%INDEX%'
and 
p.options like '%FULL%'
and 
p.sql_id = s.sql_idand 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) fwhere 
(
select 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot snwhere 
p.object_owner <> 'SYS'and 
p.operation like '%INDEX%'
and 
p.options like '%FULL%'
and 
p.sql_id = s.sql_idand 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) fwhere 
r.c1 = u.c1 

and 
r.c1 = f.c1; 
115 



• 
sql_object_avg_dy.sql 
col c1 heading ‘Object|Name’ format a30 
col c2 heading ‘Week Day’ format a15 
col c3 heading ‘Invocation|Count’ format 99,999,999 
break on c1 skip 2break on c2 skip 2 
select 

decode(c2,1,'Monday',2,'Tuesday',3,'Wednesday',4,'Thursday',5,'Friday',6,'Saturday',7,'Sunday') c2,
c1,
c3 
from 

(
select 
p.object_name c1,
to_char(sn.end_interval_time,'d') c2,
count(1) c3 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
where 
p.object_owner <> 'SYS'and 
p.sql_id = s.sql_idand 
s.snap_id = sn.snap_idgroup byp.object_name,
to_char(sn.end_interval_time,'d')
order byc2,c1); 
116 



• 
sql_details.sql 
accept sqlid prompt ‘Please enter SQL ID: ‘ 
col c1 heading ‘Operation’ format a20 
col c2 heading ‘Options’ format a20 
col c3 heading ‘Object|Name’ format a25 
col c4 heading ‘Search Columns’ format 999,999col c5 heading ‘Cardinality’ format 999,999 
select 

operation c1,
options c2,
object_name c3,
search_columns c4,
cardinality c5 
from 
where

dba_hist_sql_plan p 
p.sql_id = '&sqlid'order byp.id; 
117 



• 
sql_full_scans.sql 
col c1 heading ‘Begin|Interval|Time’ format a20 
col c2 heading ‘Index|Table|Scans’ format 999,999col c3 heading ‘Full|Table|Scans’ format 999,999select 
i.c1 c1,
i.c2 c2,
f.c2 c3 
from 
select 
from 

( 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
where 
and 
and 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
p.object_owner <> 'SYS' 
p.operation like '%TABLE ACCESS%' 
p.options like '%INDEX%' 
p.sql_id = s.sql_id 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) i,
(
select 

from 

to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
where 
and 
and 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
p.object_owner <> 'SYS' 
p.operation like '%TABLE ACCESS%' 
p.options = 'FULL' 
p.sql_id = s.sql_id 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) f
where 

i.c1 = f.c1; 
118 



• 
full_table_scans.sql 
ttile ‘Large Full-table scans|Per Snapshot Period’ 
col c1 heading ‘Begin|Interval|time’ format a20col c4 heading ‘FTS|Count’ format 999,999 
break on c1 skip 2break on c2 skip 2 
select 

to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c4 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn,
dba_segments o 
where 
p.object_owner <> 'SYS'and 
p.object_owner = o.ownerand 
p.object_name = o.segment_nameand 
o.blocks > 1000 

and 

p.operation like '%TABLE ACCESS%'
and 
p.options like '%FULL%'
and 
p.sql_id = s.sql_idand 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1; 
119 



• 
sql_access_hr.sql 
ttitle ‘Large Table Full-table scans|Averages per Hour’ 
col c1 heading ‘Day|Hour’ format a20 
col c2 heading ‘FTS|Count’ format 999,999 
break on c1 skip 2break on c2 skip 2 
select 

to_char(sn.begin_interval_time,'hh24') c1,
count(1) c2 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn,
dba_segments o 
where 
p.object_owner <> 'SYS'and 
p.object_owner = o.ownerand 
p.object_name = o.segment_nameand 
o.blocks > 1000 

and 

p.operation like '%TABLE ACCESS%'
and 
p.options like '%FULL%'
and 
p.sql_id = s.sql_idand 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'hh24')
order by 1; 
120 



• 
sql_access_day.sql 
ttitle ‘Large Table Full-table scans|Averages per Week Day’ 
col c1 heading ‘Week|Day’ format a20 
col c2 heading ‘FTS|Count’ format 999,999 
break on c1 skip 2break on c2 skip 2 
select 

to_char(sn.begin_interval_time,'day') c1,
count(1) c2 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn,
dba_segments o 
where 
p.object_owner <> 'SYS'and 
p.object_owner = o.ownerand 
p.object_name = o.segment_nameand 
o.blocks > 1000 

and 

p.operation like '%TABLE ACCESS%'
and 
p.options like '%FULL%'
and 
p.sql_id = s.sql_idand 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'day')
order by1; 
121 



• 
sql_scan_sums.sql 
col c1 heading ‘Begin|Interval|Time’ format a20 
col c2 heading ‘Large|Table|Full Table|Scans’ format 999,999col c3 heading ‘Small|Table|Full Table|Scans’ format 999,999col c4 heading ‘Total|Index|Scans’ format 999,999 
select 

f.c1 c1,
f.c2 c2,
s.c2 c3,
i.c2 c4 
from 

(
select 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn,
dba_segments o 
where 
p.object_owner <> 'SYS'and 
p.object_owner = o.ownerand 
p.object_name = o.segment_nameand 
o.blocks > 1000 

and 

p.operation like '%TABLE ACCESS%'
and 
p.options like '%FULL%'
and 
p.sql_id = s.sql_idand 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) f,
(
select 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn,
dba_segments o 
where 
p.object_owner <> 'SYS'and 
p.object_owner = o.ownerand 
122 



 p.object_name = o.segment_name p.object_name = o.segment_name
and 

o.blocks < 1000 

and 

p.operation like '%INDEX%'
and 
p.sql_id = s.sql_idand 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) s,
(
select 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
count(1) c2 
from 
dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot snwhere 
p.object_owner <> 'SYS'and 
p.operation like '%INDEX%'
and 
p.sql_id = s.sql_idand 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24')
order by1 ) iwhere 
f.c1 = s.c1 

and 
f.c1 = i.c1; 
123 



• 
sql_full_scans_avg_dy.sql 
col c1 heading ‘Begin|Interval|Time’ format a20 
col c2 heading ‘Index|Table|Scans’ format 999,999col c3 heading ‘Full|Table|Scans’ format 999,999 
select 
i.c1 c1,
i.c2 c2,
f.c2 c3 
from 
select 
from 

( 
to_char(sn.begin_interval_time,'day') c1,
count(1) c2 
where 
and 
and 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
p.object_owner <> 'SYS' 
p.operation like '%TABLE ACCESS%' 
p.options like '%INDEX%' 
p.sql_id = s.sql_id 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'day')
order by1 ) i,
(
select 

from 

to_char(sn.begin_interval_time,'day') c1,
count(1) c2 
where 
and 
and 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
p.object_owner <> 'SYS' 
p.operation like '%TABLE ACCESS%' 
p.options = 'FULL' 
p.sql_id = s.sql_id 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'day')
order by1 ) f
where 

i.c1 = f.c1; 
124 



• 
index_usage_hr.sql 
col c1 heading ‘Begin|Interval|time’ format a20col c2 heading ‘Search Columns’ format 999 
col c3 heading ‘Invocation|Count’ format 99,999,999 
break on c1 skip 2 
accept idxname char prompt ‘Enter Index Name: ‘ 
ttitle ‘Invocation Counts for index|&idxname’ 
from 
dba_hist_snapshotdba_hist_sql_plandba_hist_sqlstatwhere 
sn, 
p,
st 
st.sql_id = p.sql_idand 
sn.snap_id = st.snap_idand 

select 
to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,


p.search_columns c2,
c3 
p.object_name = ‘&idxname'group bybegin_interval_time,search_columns; 
125 



• 
access_counts.sql 
ttile ‘Table Access|Operation Counts|Per Snapshot Period’ 
col c1 heading ‘Begin|Interval|time’ format a20col c2 heading ‘Operation’ format a15 
col c3 heading ‘Option’ format a15 
col c4 heading ‘Object|Count’ format 999,999 
break on c1 skip 2break on c2 skip 2 
select 

to_char(sn.begin_interval_time,'yy-mm-dd hh24') c1,
p.operation c2,
p.options c3,
count(1) c4 
from 

where 
and 
and 

dba_hist_sql_plan p,
dba_hist_sqlstat s,
dba_hist_snapshot sn 
p.object_owner <> 'SYS' 
p.sql_id = s.sql_id 
s.snap_id = sn.snap_idgroup byto_char(sn.begin_interval_time,'yy-mm-dd hh24'),
p.operation,
p.optionsorder by1,2,3; 
126 



• 
delete_forall.sql 
SET SERVEROUTPUT ON 

DECLARE 
TYPE t_id_tab IS TABLE OF forall_test.id%TYPE;
TYPE t_code_tab IS TABLE OF forall_test.code%TYPE;
l_id_tab t_id_tab := t_id_tab();
l_code_tab t_code_tab := t_code_tab();
l_start NUMBER;
l_size NUMBER := 10000;
BEGIN 
-- Populate collections.
FOR i IN 1 .. l_size LOOP 
l_id_tab.extend;
l_code_tab.extend;
l_id_tab(l_id_tab.last) := i;
l_code_tab(l_code_tab.last) := TO_CHAR(i);
END LOOP; 
-- Time regular updates.
l_start := DBMS_UTILITY.get_time;
FOR i IN l_id_tab.first .. l_id_tab.last LOOP 
DELETE FROM forall_test 

WHERE id = l_id_tab(i)
AND code = l_code_tab(i);
END LOOP; 
ROLLBACK;
DBMS_OUTPUT.put_line('Normal Deletes : ' ||
(DBMS_UTILITY.get_time - l_start));
l_start := DBMS_UTILITY.get_time;
-- Time bulk updates.
FORALL i IN l_id_tab.first .. l_id_tab.last 
DELETE FROM forall_test 

WHERE id = l_id_tab(i)
AND code = l_code_tab(i);
DBMS_OUTPUT.put_line('Bulk Deletes : ' ||
(DBMS_UTILITY.get_time - l_start));
ROLLBACK;
END;
/ 
127 



• 
update_forall.sql 
SET SERVEROUTPUT ON 
DECLARE 
TYPE t_id_tab IS TABLE OF forall_test.id%TYPE;
TYPE t_forall_test_tab IS TABLE OF forall_test%ROWTYPE;
l_id_tab t_id_tab := t_id_tab();
l_tab t_forall_test_tab := t_forall_test_tab ();
l_start NUMBER;
l_size NUMBER := 10000;
BEGIN 
-- Populate collections.
FOR i IN 1 .. l_size LOOP 
l_id_tab.extend;
l_tab.extend;
l_id_tab(l_id_tab.last) := i;
l_tab(l_tab.last).id := i;
l_tab(l_tab.last).code := TO_CHAR(i);
l_tab(l_tab.last).description := 'Description: ' || TO_CHAR(i);
END LOOP; 
-- Time regular updates.
l_start := DBMS_UTILITY.get_time;
FOR i IN l_tab.first .. l_tab.last LOOP 
UPDATE forall_test 

SET ROW = l_tab(i)
WHERE id = l_tab(i).id;
END LOOP; 
DBMS_OUTPUT.put_line('Normal Updates : ' ||
(DBMS_UTILITY.get_time - l_start));
l_start := DBMS_UTILITY.get_time;
-- Time bulk updates. 
-- **************************************************** 
-- *** Here is the forall 
-- **************************************************** 
FORALL i IN l_tab.first .. l_tab.last 

UPDATE forall_test 

SET ROW = l_tab(i)
WHERE id = l_id_tab(i); 
DBMS_OUTPUT.put_line('Bulk Updates : ' ||
(DBMS_UTILITY.get_time - l_start));
COMMIT;
END;/ 
128 



 task_id=(
select max(t.task_id)
from 
where 
task_id=(
select max(t.task_id)
from 
where 
• 
addm_rpt.sql 
set long 1000000set pagesize 50000 
column get_clob format a80 
select dbms_advisor.get_task_report(task_name, ‘TEXT’, ‘ALL’) asfirst_ADDM_report
from 

dba_advisor_tasks 
where 

dba_advisor_tasks t,
dba_advisor_log l 

t.task_id = l.task_id 
and 
t.advisor_name=‘ADDM’ 
and 
l.status= ‘COMPLETED’ 

); 
129 



