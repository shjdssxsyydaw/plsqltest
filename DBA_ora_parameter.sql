start sqlbegin.sql

PROMPT ======================================================================================================
PROMPT P A R A M E T E R
PROMPT ------------------------------------------------------------------------------------------------------

ACCEPT cFLTPAR PROMPT 'Parameter..........? '

PROMPT ======================================================================================================
PROMPT


--- TABELLEN-FELDER ----


SELECT SUBSTR(NAME,1,30)        "Name",
       SUBSTR(VALUE,1,40)       "Value",
       ISDEFAULT                "Default",
       SUBSTR(DESCRIPTION,1,60) "Beschreibung"
  FROM V$PARAMETER
 WHERE UPPER(NAME) LIKE '%&cFLTPAR%'
 ORDER BY NAME;


PROMPT

start sqlend.sql

