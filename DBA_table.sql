start sqlbegin.sql

PROMPT ======================================================================================================
PROMPT T A B L E S
PROMPT ------------------------------------------------------------------------------------------------------

ACCEPT cFLTTAB PROMPT 'Selektion Tabelle...........? '
ACCEPT cFLTLNK PROMPT 'DB-Link.....................? '

PROMPT ======================================================================================================
PROMPT


--- TABELLEN-FELDER ----

COLUMN LEN  FORMAT 9999
BREAK ON OWNER ON TABLE_NAME SKIP 1

PROMPT

SELECT   SUBSTR(COL.OWNER,1,17)                  "Owner",
         SUBSTR(COL.TABLE_NAME,1,25)             "Table_Name",
	 SUBSTR(COL.COLUMN_NAME,1,30)            "Field",
         ' '||COL.NULLABLE||'  '                 "Null",
         SUBSTR(COL.DATA_TYPE,1,10)              "Type",
	 NVL(COL.DATA_PRECISION,COL.DATA_LENGTH) "Len",
	 TO_CHAR(COL.DATA_SCALE,'999')           " Dec"
FROM     ALL_TAB_COLUMNS&cFLTLNK COL
WHERE    COL.TABLE_NAME  LIKE '&cFLTTAB'  
ORDER BY COL.OWNER           ASC,
         COL.TABLE_NAME      ASC,
	 COL.COLUMN_ID	     ASC
;

------- REFERENZ 

BREAK ON Table ON Typ SKIP 1

SELECT 	 MAI.TABLE_NAME                    "Table",
         'Master von: '                    "Typ",
	 DET.TABLE_NAME                    "Ref-Table",
	 SUBSTR(DET.CONSTRAINT_NAME,1,25)  "Ref-Constraint"
FROM	 ALL_CONSTRAINTS&cFLTLNK MAI, ALL_CONSTRAINTS&cFLTLNK DET
WHERE    DET.CONSTRAINT_TYPE   = 'R'                      AND 
	 MAI.CONSTRAINT_TYPE  IN ('P','U')                AND
         DET.R_CONSTRAINT_NAME = MAI.CONSTRAINT_NAME      AND 
         MAI.TABLE_NAME LIKE  '&cFLTTAB'      
UNION
SELECT 	 DET.TABLE_NAME                   ,
         'Dateil von: '                   ,
	 MAI.TABLE_NAME                   ,
	 SUBSTR(DET.CONSTRAINT_NAME,1,25) 
FROM	 ALL_CONSTRAINTS&cFLTLNK MAI, ALL_CONSTRAINTS&cFLTLNK DET
WHERE    DET.CONSTRAINT_TYPE   = 'R'                      AND
         MAI.CONSTRAINT_TYPE  IN ('P','U')                AND    
	 DET.R_CONSTRAINT_NAME = MAI.CONSTRAINT_NAME      AND 
         DET.TABLE_NAME = '&cFLTTAB'     
ORDER BY 1, 2 DESC, 3
;

--- CONSTR ----

BREAK ON Owner ON Table ON Constraint SKIP 1

SELECT   SUBSTR(CON.TABLE_NAME,1,22)  	    "Table",
         SUBSTR(CON.CONSTRAINT_NAME,1,20)   "Constraint",
         SUBSTR(COL.COLUMN_NAME,1,30)       "Column", 
         ' '||CON.CONSTRAINT_TYPE||' '      "Typ",
         SUBSTR(CON.R_CONSTRAINT_NAME,1,15) "Relation"
FROM     ALL_CONSTRAINTS&cFLTLNK CON,
         ALL_CONS_COLUMNS COL
WHERE    CON.CONSTRAINT_NAME    =    COL.CONSTRAINT_NAME AND 
         CON.OWNER              =    COL.OWNER           AND
         CON.TABLE_NAME         =    COL.TABLE_NAME      AND
         COL.TABLE_NAME         =   '&cFLTTAB'           
ORDER BY CON.OWNER           ASC,
         CON.TABLE_NAME      ASC,
         CON.CONSTRAINT_NAME ASC, 
         COL.POSITION        ASC
;

---- INDEXE -----

BREAK ON Owner ON Table ON Index SKIP 1

SELECT   SUBSTR(IND.TABLE_NAME,1,22)      "Table" , 
         SUBSTR(IND.INDEX_NAME,1,20)      "Index" ,
         SUBSTR(COLUMN_NAME,1,30)         "Columnd"  ,                    
         SUBSTR(IND.STATUS,1,6)           "Status"
FROM     ALL_INDEXES&cFLTLNK IND, ALL_IND_COLUMNS&cFLTLNK COL
WHERE    IND.OWNER       = COL.INDEX_OWNER        AND
         IND.INDEX_NAME  = COL.INDEX_NAME         AND   
         IND.TABLE_NAME  = '&cFLTTAB'    
ORDER BY IND.OWNER           ASC,
         IND.TABLE_NAME      ASC,
         IND.INDEX_NAME      ASC,
	 COLUMN_POSITION     ASC
;

---- Trigger ----

SELECT   SUBSTR(TABLE_NAME,1,22)        "Table"  , 
         SUBSTR(TRIGGER_NAME,1,20)      "Trigger",
         TRIGGERING_EVENT               "Event"  ,
         TRIGGER_TYPE                   "Typ"    
FROM     DBA_TRIGGERS&cFLTLNK
WHERE    TABLE_NAME  = '&cFLTTAB'
ORDER BY TRIGGER_NAME
;


PROMPT

start sqlend.sql

