start sqlbegin.sql
SET LINES 500

PROMPT ======================================================================================================
PROMPT O B J E K T E
PROMPT ------------------------------------------------------------------------------------------------------

ACCEPT cFLTOBJ PROMPT 'Object.......? ( Default=Alle ) '
ACCEPT cFLTOWN PROMPT 'Owner........? ( Default=Alle ) '
ACCEPT cFLTTYP PROMPT 'Type.........? ( Default=Alle ) '

PROMPT ======================================================================================================

--- OBJECT ANZEIGEN ---

SELECT   /*+ RULE */
         SUBSTR(OBJ.OWNER,1,7)             "Owner" ,
         OBJ.OBJECT_TYPE                   "Type"  ,
         SUBSTR(OBJ.OBJECT_NAME,1,25)      "Object",
         DECODE(DEB.DEBUGINFO,'T',' x ','   ') "Deb",
	      SUBSTR(EXT.F_TS,1,20)             "Tablespace",
         OBJ.STATUS                        "Status",
         SUBSTR(TO_CHAR(OBJ.CREATED,'DD.MM.YY') ,1,8) "Create",
         SUBSTR(TO_CHAR(OBJ.LAST_DDL_TIME,'DD.MM.YY HH24:MI:SS'),1,18) "Change",
         STO.F_MINEXT                       "MIN-Ext",
         STO.F_MAXEXT                       "MAX-Ext",         
         STO.F_INIEXT/1024                  "INI-Ext KB",
         STO.F_NEXEXT/1024                  "NEXT-Ext KB",
         EXT.F_ANZEXT                       "Anz.Ext",
         TO_CHAR(EXT.F_SIZE/1024/1024,'9999.999')               "  Size MB"
FROM     DBA_OBJECTS OBJ, SYS.ALL_PROBE_OBJECTS DEB, 
         ( SELECT OWNER              F_OWNER,
                  TABLESPACE_NAME    F_TS,
                  SEGMENT_NAME       F_OBJECT,
                  SEGMENT_TYPE       F_TYPE,
                  SUM(BYTES)       F_SIZE,
                  COUNT(*)           F_ANZEXT
             FROM DBA_EXTENTS
            WHERE SEGMENT_NAME LIKE '%&cFLTOBJ%'  AND
                  OWNER        LIKE '%&cFLTOWN%' 
            GROUP BY OWNER, TABLESPACE_NAME, SEGMENT_NAME, SEGMENT_TYPE ) EXT,
         ( SELECT 'TABLE'            F_TYPE,
                  OWNER              F_OWNER,
                  TABLE_NAME         F_NAME,
                  MIN_EXTENTS        F_MINEXT,
                  MAX_EXTENTS        F_MAXEXT,
                  INITIAL_EXTENT     F_INIEXT,
                  NEXT_EXTENT        F_NEXEXT
             FROM DBA_TABLES
            WHERE OWNER       LIKE '%&cFLTOWN%'  AND
                  TABLE_NAME  LIKE '%&cFLTOBJ%' 
           UNION 
           SELECT 'INDEX'            F_TYPE,
                  OWNER              F_OWNER,
                  INDEX_NAME         F_NAME,
                  MIN_EXTENTS        F_MINEXT,
                  MAX_EXTENTS        F_MAXEXT,
                  INITIAL_EXTENT     F_INIEXT,
                  NEXT_EXTENT        F_NEXEXT
             FROM DBA_INDEXES
            WHERE OWNER       LIKE '%&cFLTOWN%'  AND
                  INDEX_NAME  LIKE '%&cFLTOBJ%' ) STO
WHERE    OBJ.OWNER       = EXT.F_OWNER(+)      AND
	      OBJ.OBJECT_NAME = EXT.F_OBJECT(+)     AND
	      OBJ.OBJECT_TYPE = EXT.F_TYPE(+)       AND
         OBJ.OWNER       = STO.F_OWNER(+)      AND
	      OBJ.OBJECT_NAME = STO.F_NAME(+)       AND
	      OBJ.OBJECT_TYPE = STO.F_TYPE(+)       AND
	      OBJ.OBJECT_NAME = DEB.OBJECT_NAME(+)  AND
	      OBJ.OWNER       = DEB.OWNER(+)        AND
	      OBJ.OBJECT_TYPE = DEB.OBJECT_TYPE(+)  AND
         OBJ.OBJECT_NAME LIKE '%&cFLTOBJ%'     AND
         OBJ.OWNER       LIKE '%&cFLTOWN%'     AND
         OBJ.OBJECT_TYPE LIKE '%&cFLTTYP%'     AND
         LENGTH(OBJ.OWNER) >= 4                AND 
         OBJ.OWNER         <> 'PUBLIC'         AND
         OBJ.OWNER   NOT LIKE '%SYS%'
ORDER BY OBJ.CREATED ,1,2,3,4;

PROMPT

start sqlend.sql

