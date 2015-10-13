start sqlbegin.sql

set lines 200

PROMPT ======================================================================================================
PROMPT P R O C E S S   I N F O
PROMPT ======================================================================================================
PROMPT

BREAK ON Kontext ON User SKIP 1

select substr(SID,1,5)                     "Sess",
       TO_CHAR(TOTALWORK      ,9999999)    "Total",
       TO_CHAR(SOFAR          ,9999999)    "Erledigt",
       TO_CHAR(TOTALWORK-SOFAR,9999999)    "Muss noch",
       TO_CHAR(TIME_REMAINING/60 ,999999.99) "in min",
       TO_CHAR(100 - (100/TOTALWORK * (TOTALWORK-SOFAR)) ,'999.99')  "Proc %",
       SUBSTR(TO_CHAR(LAST_UPDATE_TIME,'DD.MM.YY HH24:MI:SS'),1,18)  "Update",
       SUBSTR(MESSAGE,1,30)              "Message",
       SUBSTR(OPNAME,1,30)               "Operation"
  from V$SESSION_LONGOPS
 where SOFAR < TOTALWORK
    OR TIME_REMAINING > 0
 order by 1,2,3;
 
PROMPT

start sqlend.sql

