select substr(s.username,1,9)                                   username,
       substr(s.osuser,1,9)                                     osuser,
       substr(s.sid||','||s.serial#,1,12)                       sid_serial,
       s.status                                                 status,
       t.tablespace                                             tablespace,
       t.segfile#                                               segfile#,
       t.segblk#                                                segblk#,
       t.blocks                                                 blocks
  from v$session    s,
       v$sort_usage t
 where s.saddr = t.session_addr
 order by t.tablespace,
          t.segfile#,
          t.segblk#,
          t.blocks
/

