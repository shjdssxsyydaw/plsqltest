start sqlbegin.sql

PROMPT ======================================================================================================
PROMPT P R O T O K O L L - S E S S I O N 
PROMPT ------------------------------------------------------------------------------------------------------

ACCEPT cPROMIN    PROMPT 'Message nicht älter als X-Minuten ....? ( Muss Eingabe ) '
ACCEPT cPROUSR    PROMPT 'User .................................? ( Default=User ) '
ACCEPT cPROTYP    PROMPT 'Protokoll Typ ........................? ( Default=Alle ) '

PROMPT ======================================================================================================
PROMPT


SELECT SUBSTR(MP_SESSION_UID,1,15)                                             "Session ID",
       MIN(SUBSTR(TO_CHAR(MP_INSTANZIERUNG,'DD-HH24:MI:SS'),1,18))             "Start",
       MAX(SUBSTR(TO_CHAR(MP_INSTANZIERUNG,'DD-HH24:MI:SS'),1,18))             "Ende" ,
       TO_CHAR((MAX(MP_INSTANZIERUNG)-MIN(MP_INSTANZIERUNG))*24*60,'9999999')  "Laufzeit"       
  FROM MESSAGEPROZESSOR_ENTRIES
 WHERE MP_INSTANZIERUNG > SYSDATE-(1/24/60*&cPROMIN)
   AND MP_USER LIKE '&cPROUSR%'
   AND (MP_MESSAGE_TYPE <= &cPROTYP+0  OR  &cPROTYP+0 = 0 )      
 GROUP BY MP_SESSION_UID
ORDER BY MAX(SUBSTR(TO_CHAR(MP_INSTANZIERUNG,'DD-HH24:MI:SS'),1,18));


start sqlend.sql
