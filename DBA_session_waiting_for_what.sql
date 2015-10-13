-- List all waiting sessions (left side) and the responsible
-- session (right side)
-- Who (wusername, wosuser, wsid_serial)
-- waits since (wseconds)
-- to get a lock (wlocktype)
-- using statment (wsql_id)
-- but does not get it because
-- Locker (lusername, losuser, lsid_serial)
-- prevents this with (llocktype)
-- with (kill_locker), the blocker could be killed.

select /*+ rule */
       substr(wsession.username,1,10)                   wusername,
       substr(wsession.osuser,1,9)                      wosuser,
       substr(wlocks.sid||','||wsession.serial#,1,12)   wsid_serial,
       substr(
          decode(wlocks.request,0,'None',
                     1, 'Null',           /* N */
                     2, 'Row-S (SS)',     /* L */
                     3, 'Row-X (SX)',     /* R */
                     4, 'Share',          /* S */
                     5, 'S/Row-X (SSX)',  /* C */
                     6, 'Exclusive',      /* X */
                     to_char(wlocks.request)
                ),1,20)                                 wlocktype,
       wlocks.ctime                                     wseconds,
       wsession.sql_id                                  wsql_id,
       substr(lsession.username,1,10)                   lusername,
       substr(lsession.osuser,1,9)                      losuser,
       substr(llocks.sid||','||lsession.serial#,1,12)   lsid_serial,
       substr(
          decode(llocks.lmode,  0, 'None',
                     1, 'Null',           /* N */
                     2, 'Row-S (SS)',     /* L */
                     3, 'Row-X (SX)',     /* R */
                     4, 'Share',          /* S */
                     5, 'S/Row-X (SSX)',  /* C */
                     6, 'Exclusive',      /* X */
                     to_char(llocks.lmode)
                ),1,20)                                  llocktype,
       'select * from ' || wobject.owner || '.' || wobject.object_name || ' where rowid = ''' ||
          dbms_rowid.rowid_create ( 1, wobject.data_object_id, wsession.row_wait_file#, wsession.row_wait_block#, wsession.row_wait_row# ) ||
          ''';'                                          select_this
  from v$lock wlocks,
       v$lock llocks,
       v$session wsession,
       v$session lsession,
       dba_objects wobject
where  wsession.sid   = wlocks.sid
and    lsession.sid   = llocks.sid
and    llocks.id1     = wlocks.id1
and    wlocks.request > 0
and    llocks.lmode   > 0
and    wlocks.addr   != llocks.addr
and    wsession.row_wait_obj# = wobject.object_id
order by wlocks.ctime asc
/

