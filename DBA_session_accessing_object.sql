-- All Sessions in the database accessing a named object
-- who   (username, osuser, sid_serial)
-- what  (status, sql_id, prev_sql_id)
-- from  (machine, process_id)
-- what  (program)
-- type  (type of object)
-- object(owner and name)
-- since (logon)
define objectname=&objectname

select substr(lower(object_type),1,20)                    type,
       substr(lower(owner || '.' || object_name),1,37)    object,
       lower(status)                                      status,
       to_char(last_ddl_time, 'dd.mm.yyyy hh24:mi:ss')    last_ddl
  from dba_objects
 where object_name = upper('&objectname')
 order by object_type, owner, object_name
/

       

with acc as (
   select /*+ opt_param('_optimizer_cartesian_enabled','false') */
          sid        acc_sid,
          owner      acc_owner,
          object     acc_object,
          type       acc_type
     from v$access
    where object = upper('&objectname')
)
select substr(username,1,9)                                   username,
       substr(osuser,1,9)                                     osuser,
       substr(sid||','||serial#,1,12)                         sid_serial,
       status                                                 status,
       to_char(nvl(prev_exec_start, sql_exec_start),'dd.mm.yyyy hh24:mi:ss')
                                                              last_contact,
       substr(machine,1,24)                                   machine,
       program                                                program,
       substr(lower(acc_type),1,20)                           type,
       substr(lower(acc_owner || '.' || acc_object),1,37)     object,
       to_char(logon_time,'dd.mm.yyyy hh24:mi:ss')            logon
  from v$session ses,
       acc
 where ses.sid = acc.acc_sid
 order by nvl(prev_exec_start, sql_exec_start) asc, sid, acc_object, acc_owner, acc_type
/

undefine objectname
