-- D B M S _ S T A T 
--https://docs.oracle.com/cd/B19306_01/appdev.102/b14258/d_stats.htm#i1048060


select * from user_stat_col_statistic;
select * from dictionary where table_name like '%STAT%';
select * from USER_TAB_COL_STATISTICS;


begin
dbms_stats.gather_table_stats(
   ownname => user, 
   tabname => upper('fremdmatch_ant_227820' ), 
   estimate_percent => 100, 
   method_opt => 'for all columns size auto',
   degree => 4 ,
   cascade => null );
   
end;

select * from USER_TAB_COL_STATISTICS where upper('fremdmatch_ant_227820' ) =table_name ;


------------
--dbms stat impact following dict tables;
select * from   dba_object_tables;
select * from   dba_tab_col_statistics;
select * from   dba_tab_partitions;
select * from   dba_subpartition;
select * from   dba_part_col_statistics;
select * from   dba_tables;
select * from   dba_tab_cols;
select * from   dba_tab_columns;
select * from   dba_all_tables;
select * from   dba_indexes;
select * from   dba_ind_partitions;
select * from   dba_ind_subpartitions;

