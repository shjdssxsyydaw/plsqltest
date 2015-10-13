start sqlbegin.sql

PROMPT ====================================================================================================
PROMPT D B - I N F O 
PROMPT ====================================================================================================

-- VERSION

SELECT RPAD(BANNER,100) "VERSION" FROM V$VERSION;

SELECT SUBSTR(NAME,1,20) "ALG-PARAMETER",
       RPAD(VALUE,79) "VALUE"
  FROM V$PARAMETER
  WHERE NAME LIKE '%db_name%'        OR 
        NAME LIKE '%_dump_dest%'     OR 
        NAME LIKE '%control_files%'  OR 
        NAME LIKE '%_archive_dest%'  OR
        NAME LIKE '%_archive_start%' OR
        NAME LIKE '%ifile%'          OR
        NAME LIKE 'timed_statistics' OR
        NAME LIKE 'nls_lang%'        OR
        NAME LIKE 'nls_terr%'        OR
        NAME LIKE 'rollback_%';

-- NLS

SELECT SUBSTR(PARAMETER,1,20) "NLS-PARAMETER",
       RPAD(VALUE,79) "VALUE"
  FROM V$NLS_PARAMETERS;

-- TABLE-SPACE

COLUMN SIZE   FORMAT 999999.9
COLUMN FREE-T FORMAT 999999.9
COLUMN FREE-M FORMAT 999999.9
COLUMN BLK    FORMAT 99999

BREAK ON TS-NAME ON TS-FILE

SELECT SUBSTR(DBA_DATA_FILES.TABLESPACE_NAME,1,10) "TS-NAME",
       SUBSTR(DBA_DATA_FILES.FILE_NAME,1,38) "TS-FILE",
    SUM(DBA_FREE_SPACE.BYTES/1024/1024) "FREE-T",
    MAX(DBA_FREE_SPACE.BYTES/1024/1024) "FREE-M"
   FROM DBA_DATA_FILES, DBA_FREE_SPACE
  WHERE DBA_DATA_FILES.FILE_ID   = DBA_FREE_SPACE.FILE_ID
   GROUP BY DBA_DATA_FILES.FILE_NAME,
            DBA_DATA_FILES.TABLESPACE_NAME
            order by 1;
            
-- ROLLBACKSEGMENT

SELECT  SUBSTR(DBA_ROLLBACK_SEGS.TABLESPACE_NAME,1,15) "TS-NAME",
        DBA_ROLLBACK_SEGS.SEGMENT_NAME||'          ' "ROLLBACK-SEGMENT",
        SUBSTR(DBA_ROLLBACK_SEGS.STATUS,1,7) "STATUS",
        V$ROLLSTAT.RSSIZE/1024/1024 "      SIZE MB",
        V$ROLLSTAT.EXTENTS "EXTENTS"
  FROM  DBA_ROLLBACK_SEGS, V$ROLLSTAT, V$ROLLNAME
  WHERE DBA_ROLLBACK_SEGS.SEGMENT_NAME = V$ROLLNAME.NAME AND
        V$ROLLNAME.USN = V$ROLLSTAT.USN
  ORDER BY 1,2;  

-- REDO LOGS

SELECT GROUP# "REDO  GRP", 
       SUBSTR(MEMBER,1,46) "FILES (2 Memb/Grp = Spieglung)",
       STATUS "STATUS"
FROM V$LOGFILE
ORDER BY 1

-- PROZESSE

SELECT SUBSTR(USERNAME,1,9) "USER", 
       SID,
       SERIAL#,
       SUBSTR(PROGRAM,1,30) "PROZESS",
       TERMINAL||'  ' "TERMINAL",
       SUBSTR(MACHINE,1,20) "MACHINE"
FROM V$SESSION, V$TRANSACTION
WHERE ADDR(+)=TADDR
ORDER BY 1

-- USERS

SELECT SUBSTR(USERNAME,1,9) "USER",
       SUBSTR(DEFAULT_TABLESPACE,1,19) "DEFAULT TS",
       SUBSTR(TEMPORARY_TABLESPACE,1,19) "TEMP TS",
       SUBSTR(PROFILE,1,10) "PROFILE"
  FROM DBA_USERS


-- OBJECTE

SELECT   object_type "Object",
         status      "Status",
	 count(*)    "Count"
FROM     all_objects
GROUP BY object_type, status

PROMPT

start sqlend.sql
