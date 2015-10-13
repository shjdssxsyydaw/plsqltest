start sqlbegin.sql

set lines 150

PROMPT ======================================================================================================
PROMPT T A B L E S
PROMPT ------------------------------------------------------------------------------------------------------

ACCEPT cFLTTAB PROMPT 'Selektion Tabelle...........? '

PROMPT ======================================================================================================
PROMPT


--- TABELLEN-FELDER ----

COLUMN LEN  FORMAT 9999
BREAK ON OWNER ON TABLE_NAME ON Typ SKIP 1
SET FEEDBACK OFF

PROMPT -- FIELDS
PROMPT -- -------

SELECT   SUBSTR(COL.OWNER,1,10)                  "Owner",
      	SUBSTR(COL.TABLE_NAME,1,35)             "Table_Name",
        DECODE(VIE.VIEW_NAME , NULL , 'TAB','VIE')  "Typ",
	SUBSTR(COL.COLUMN_NAME,1,25)                  "Field",
         ' '||COL.NULLABLE||'  '                 "Null",
         SUBSTR(COL.DATA_TYPE,1,10)              "Type",
			NVL(COL.DATA_PRECISION,COL.DATA_LENGTH) "Len",
			TO_CHAR(COL.DATA_SCALE,'999')           " Dec"
FROM     DBA_TAB_COLUMNS COL,
         DBA_VIEWS       VIE
WHERE    COL.TABLE_NAME = VIE.VIEW_NAME (+)
  AND    COL.OWNER      = VIE.OWNER(+)
  AND    COL.TABLE_NAME  LIKE '%&cFLTTAB%'
ORDER BY COL.OWNER           ASC,
         COL.TABLE_NAME      ASC,
         COL.COLUMN_ID	     ASC
;

PROMPT

PROMPT -- LOB'S / TAB-PARTITIONEN / INDEX-ONLY TABLES
PROMPT -- --------------------------------------------

SELECT SUBSTR(OWNER,1,10)              "Owner",
       SUBSTR(TABLE_NAME,1,35)         "Table_Name",
       'Lob '                          "Typ",
       SUBSTR(COLUMN_NAME,1,25)        "Field",
       SUBSTR(SEGMENT_NAME,1,25)       "Seg-Name" ,
       SUBSTR(INDEX_NAME,1,25)         "Seg-Index" 
  from ALL_LOBS
 where TABLE_NAME  LIKE '%&cFLTTAB%';

SELECT SUBSTR(TAB.OWNER,1,10)          "Owner",
       SUBSTR(TAB.TABLE_NAME,1,19)     "Table_Name",
       'IOnl'                          "Typ",
       SUBSTR(INDEX_NAME,1,25)         "Index"      
  FROM ALL_TABLES TAB, DBA_INDEXES IND
 WHERE TAB.TABLE_NAME = IND.TABLE_NAME
   AND TAB.OWNER      = IND.OWNER
   AND TAB.IOT_TYPE   = 'IOT'
   AND TAB.TABLE_NAME  LIKE '%&cFLTTAB%';

SET LONG 25
SELECT SUBSTR(TABLE_OWNER,1,10)        "Owner",
       SUBSTR(TABLE_NAME,1,35)         "Table_Name",
       'Part'                          "Typ",
       SUBSTR(PARTITION_NAME,1,25)     "Part-Name",
       HIGH_VALUE                      "Values"
  FROM DBA_TAB_PARTITIONS
 WHERE TABLE_NAME  LIKE '%&cFLTTAB%';

PROMPT
  
PROMPT -- REFERENZEN
PROMPT -- -----------

BREAK ON Table ON Typ SKIP 1

SELECT 	MAI.TABLE_NAME                    "Table",
         'Master von: '                    "Typ",
			DET.TABLE_NAME                    "Ref-Table",
			SUBSTR(DET.CONSTRAINT_NAME,1,35)  "Ref-Constraint"
FROM		ALL_CONSTRAINTS MAI, ALL_CONSTRAINTS DET
WHERE		DET.CONSTRAINT_TYPE   = 'R'                      AND 
			MAI.CONSTRAINT_TYPE  IN ('P','U')                AND
         DET.R_CONSTRAINT_NAME = MAI.CONSTRAINT_NAME      AND 
         MAI.TABLE_NAME LIKE  '%&cFLTTAB%'      			
UNION
SELECT 	DET.TABLE_NAME                   ,
         'Dateil von: '                   ,
			MAI.TABLE_NAME                   ,
			SUBSTR(DET.CONSTRAINT_NAME,1,35) 
FROM		ALL_CONSTRAINTS MAI, ALL_CONSTRAINTS DET
WHERE    DET.CONSTRAINT_TYPE   = 'R'                      AND
         MAI.CONSTRAINT_TYPE  IN ('P','U')                AND    
			DET.R_CONSTRAINT_NAME = MAI.CONSTRAINT_NAME      AND 
         DET.TABLE_NAME  LIKE '%&cFLTTAB%'                
ORDER BY 1, 2 DESC, 3
;


PROMPT

start sqlend.sql

