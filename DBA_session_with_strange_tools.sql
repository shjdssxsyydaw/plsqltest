-- All Sessions in the database orderer by logon-time
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
 where (    program not like 'vvserver.exe'
        and program not like 'browser.exe'
        and program not like 'rsbrowser.exe'
        and program not like 'rvserver.exe'
        and program not like 'vertriag.exe'
        and program not like 'gvadmin.exe'
        and program not like 'vertrieb.exe'
        and program not like 'partner.exe'
        and program not like 'adlohn.exe'
        and program not like 'vertrags.exe'
        and program not like 'archclnt.exe'
        and program not like 'angebovw.exe'
        and program not like 'invbrows.exe'
        and program not like 'fondsvw.exe'
        and program not like 'apprif.exe'
        and program not like 'invest.exe'
        and program not like 'JDBC Thin Client'
        and program not like 'dt_srv__GPVV_@gena%'
        and program not like 'fi_zfg__GPVV_@gena%'
        and program not like 'be_prz__GPVV_@gena%'
        and program not like 'imgfodoksvr@gena%'
        and program not like 'AngebotDaemon_10__0_GPVV_@gena%'
       )
 order by logon_time, osuser
/

