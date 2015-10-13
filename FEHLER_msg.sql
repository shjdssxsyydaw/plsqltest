start sqlbegin.sql

PROMPT ======================================================================================================
PROMPT F E H L E R
PROMPT ------------------------------------------------------------------------------------------------------

ACCEPT cERRID     PROMPT 'Fehler ID ................? ( Default=Alle ) '
ACCEPT cERRDSC    PROMPT 'Fehler Description .......? ( Default=Alle ) '

PROMPT ======================================================================================================
PROMPT

SET LINES 350

SELECT  ERR_FEHLER_ID                  "ID",
	SUBSTR(ERR_BEZEICHNUNG||' / '||
	ERR_ZUSATZBESCHREIBUNG ,1,200)      "Bezeichnung",
 	ERR_FEHLER_TYP                      "Typ",
	SUBSTR(ERR_APPLIKATION,1,5)         "Appl",
 	SUBSTR(ERR_HILFEDATEI,1,15)         "Help",
 	SUBSTR(ERR_SUCHTEXT,1,10)           "Such",
 	SUBSTR(ERR_ZUSATZBESCHREIBUNG,1,200) "ZUSATZ"
FROM 	FEHLER
WHERE 	ERR_FEHLER_ID    LIKE '%&cERRID%' AND
	UPPER(ERR_BEZEICHNUNG)  LIKE '%&cERRDSC%'
ORDER BY 1
;

PROMPT

start sqlend.sql
