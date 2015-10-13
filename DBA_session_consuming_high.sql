select substr(s.username,1,9)                                   username,
       substr(s.osuser,1,9)                                     osuser,
       substr(s.sid||','||s.serial#,1,12)                         sid_serial,
       t.used_ublk,
       t.used_urec,
       rs.segment_name,
       r.rssize,
       r.status
  from v$transaction t,
       v$session s,
       v$rollstat r,
       dba_rollback_segs rs
 where s.saddr = t.ses_addr
   and t.xidusn = r.usn
   and rs.segment_id = t.xidusn
   and t.used_ublk > 1
 order by t.used_ublk asc
/

