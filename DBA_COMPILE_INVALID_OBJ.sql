
start sqlbegin.sql

VAR DB VARCHAR2(20)
===================================================================================

SET HEADING OFF
SET ECHO OFF
SPOOL OFF
SPOOL RUN.ASC

COLUMN owner NOPRINT 
COLUMN skey NOPRINT

BEGIN
   SELECT SID||'DS' INTO :DB FROM SID;
END;
/

SELECT rpad('alter '||object_type||' '||owner||'.'||object_name||' compile debug;',80) Objekt,
       owner                                        owner,
       '2'                                          skey
  FROM  DBA_OBJECTS
  WHERE STATUS = 'INVALID' AND
        OWNER not in('SYS','SYSTEM','SCOTT')  AND
        OBJECT_TYPE = 'PACKAGE' AND
        OWNER  LIKE '&cFLTOWN%'       AND
        LENGTH(OWNER) > 3
UNION
SELECT rpad('alter PACKAGE'||' '||owner||'.'||object_name||' compile debug BODY;',80) object,
       owner                                        owner,
       '3'                                          skey
  FROM  DBA_OBJECTS
  WHERE STATUS = 'INVALID' AND
        OWNER not in('SYS','SYSTEM','SCOTT') AND
        OBJECT_TYPE = 'PACKAGE BODY' AND
        OWNER  LIKE '&cFLTOWN%'      AND
        LENGTH(OWNER) > 3 
UNION
SELECT rpad('alter '||object_type||' '||owner||'.'||object_name||' compile;',80) Objekt,
       owner                                        owner,
       '4'                                          skey
  FROM  DBA_OBJECTS
  WHERE STATUS = 'INVALID' AND
        OWNER not in('SYS','SYSTEM','SCOTT')  AND
        OBJECT_TYPE not in ('PACKAGE','PACKAGE BODY') AND
        OWNER  LIKE '&cFLTOWN%'       AND
        LENGTH(OWNER) > 3
        and '[&cFLTALL]' = '[Y]'
UNION
SELECT rpad('connect '||owner||'/'||owner||'@'||:DB||';',80) object,
       owner                                       owner,
       '1'                                         skey
  FROM  DBA_OBJECTS
  WHERE STATUS = 'INVALID'           AND
        OWNER not in('SYS','SYSTEM','SCOTT') AND
        OWNER  LIKE '&cFLTOWN%'      AND
        LENGTH(OWNER) > 3 
  GROUP BY owner
UNION 
select rpad('connect '||user||'/'||user||'@'||:DB||';',80)  object,
       'XXXXXXXXX'                                owner,
       '1'                                        skey
  FROM DUAL
ORDER BY 2,3,1;

start sqlend

