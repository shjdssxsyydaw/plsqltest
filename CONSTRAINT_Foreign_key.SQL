start sqlbegin.sql

set lines 150

PROMPT ======================================================================================================
PROMPT T A B L E S
PROMPT ------------------------------------------------------------------------------------------------------

ACCEPT cFLTTAB PROMPT 'Selektion Tabelle...........? '

PROMPT ======================================================================================================
PROMPT

SELECT 	MAI.TABLE_NAME                    "Table",
         'Master von: '                    "Typ",
			DET.TABLE_NAME                    "Ref-Table",
			SUBSTR(DET.CONSTRAINT_NAME,1,25)  "Ref-Constraint"
FROM		SYS.ALL_CONSTRAINTS MAI, SYS.ALL_CONSTRAINTS DET
WHERE		DET.CONSTRAINT_TYPE   = 'R'                      AND 
			MAI.CONSTRAINT_TYPE  IN ('P','U')                AND
         DET.R_CONSTRAINT_NAME = MAI.CONSTRAINT_NAME      AND 
         MAI.TABLE_NAME LIKE  '%&cFLTTAB%'      			
UNION
SELECT 	DET.TABLE_NAME                   ,
         'Dateil von: '                   ,
			MAI.TABLE_NAME                   ,
			SUBSTR(DET.CONSTRAINT_NAME,1,25) 
FROM		SYS.ALL_CONSTRAINTS MAI, SYS.ALL_CONSTRAINTS DET
WHERE    DET.CONSTRAINT_TYPE   = 'R'                      AND
         MAI.CONSTRAINT_TYPE  IN ('P','U')                AND    
			DET.R_CONSTRAINT_NAME = MAI.CONSTRAINT_NAME      AND 
         DET.TABLE_NAME  LIKE '%&cFLTTAB%'                
ORDER BY 1, 2 DESC, 3
;

PROMPT

start sqlend.sql

