-- All Sessions non inactive, ordered by sql_exec_start
-- who   (username, osuser, sid_serial)
-- what  (status, sql_id, prev_sql_id)
-- from  (machine, process_id)
-- what  (program)
-- since (logon)

select substr(username,1,9)                                   username,
       substr(osuser,1,9)                                     osuser,
       substr(sid||','||serial#,1,12)                         sid_serial,
       status                                                 status,
       sql_id                                                 sql_id,
       to_char(sql_exec_start,'dd.mm.yyyy hh24:mi:ss')        sstart,
       prev_sql_id                                            prev_sql_id,
       to_char(prev_exec_start,'dd.mm.yyyy hh24:mi:ss')       pstart,
       substr(machine,1,24)                                   machine,
       process                                                process_id,
       program                                                program,
       to_char(logon_time,'dd.mm.yyyy hh24:mi:ss')            logon
  from v$session
 where status         != 'INACTIVE'
   and sql_exec_start is not null
 order by sql_exec_start desc, osuser
/


