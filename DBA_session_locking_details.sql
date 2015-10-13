-- What does a Session lock
-- who   (username, osuser, sid_serial)
-- what  (status, sql_id, prev_sql_id)
-- from  (machine, process_id)
-- what  (program)
-- since (logon)
define sid=&sid

select oracle_username username,
       owner object_owner,
       substr(object_name,1,40) object_name,
       object_type,
       s.osuser,
       decode(l.block,
          0, 'Not Blocking',
          1, 'Blocking',
          2, 'Global') status,
       decode(v.locked_mode,
          0, 'None',
          1, 'Null',
          2, 'Row-S (SS)',
          3, 'Row-X (SX)',
          4, 'Share',
          5, 'S/Row-X (SSX)',
          6, 'Exclusive', to_char(lmode)
        ) mode_held
  from gv$locked_object v,
       dba_objects d,
       gv$lock l,
       gv$session s
 where v.object_id = d.object_id
   and (v.object_id = l.id1)
   and v.session_id = s.sid
   and v.session_id = &sid
   and s.sid        = &sid
 order by oracle_username, session_id
/

undefine sid

