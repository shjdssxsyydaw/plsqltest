select to_char(min(sample_time))                          sample_time_from,
       to_char(max(sample_time))                          sample_time_to,
       session_id || ',' || session_serial#               sid_serial,
       substr(username,1,20)                              user_name,
       substr(machine,1,24)                               machine,
       program                                            program
  from v$active_session_history ash,
       dba_users                usr
 where ash.user_id     = usr.user_id
 group by session_id,
          session_serial#,
          username,
          machine,
          program
order by min(sample_time)
/   


