start sqlbegin.sql

PROMPT ======================================================================================================
PROMPT TABLE'S OR INDEXE'S > 100 MB
PROMPT ------------------------------------------------------------------------------------------------------


SET LINES 500

SELECT   /*+ RULE */
         TO_CHAR(EXT.F_SIZE/1024/1024,'9999999.999')        "     Size MB",
         SUBSTR(OBJ.OWNER,1,7)                              "Owner" ,
         OBJ.OBJECT_TYPE                                    "Type"  ,
         SUBSTR(OBJ.OBJECT_NAME,1,25)                       "Object",
	      SUBSTR(EXT.F_TS,1,20)                              "Tablespace",
         OBJ.STATUS                                         "Status",
         EXT.F_ANZEXT                                       "Anz.Ext" 
FROM     DBA_OBJECTS OBJ, SYS.ALL_PROBE_OBJECTS DEB, 
         ( SELECT OWNER              F_OWNER,
                  TABLESPACE_NAME    F_TS,
                  SEGMENT_NAME       F_OBJECT,
                  SEGMENT_TYPE       F_TYPE,
                  SUM(BYTES)       F_SIZE,
                  COUNT(*)           F_ANZEXT
             FROM DBA_EXTENTS
            GROUP BY OWNER, TABLESPACE_NAME, SEGMENT_NAME, SEGMENT_TYPE ) EXT,
         ( SELECT 'TABLE'            F_TYPE,
                  OWNER              F_OWNER,
                  TABLE_NAME         F_NAME,
                  MIN_EXTENTS        F_MINEXT,
                  MAX_EXTENTS        F_MAXEXT,
                  INITIAL_EXTENT     F_INIEXT,
                  NEXT_EXTENT        F_NEXEXT
             FROM DBA_TABLES
           UNION 
           SELECT 'INDEX'            F_TYPE,
                  OWNER              F_OWNER,
                  INDEX_NAME         F_NAME,
                  MIN_EXTENTS        F_MINEXT,
                  MAX_EXTENTS        F_MAXEXT,
                  INITIAL_EXTENT     F_INIEXT,
                  NEXT_EXTENT        F_NEXEXT
             FROM DBA_INDEXES ) STO
WHERE    OBJ.OWNER       = EXT.F_OWNER(+)      AND
	      OBJ.OBJECT_NAME = EXT.F_OBJECT(+)     AND
	      OBJ.OBJECT_TYPE = EXT.F_TYPE(+)       AND
         OBJ.OWNER       = STO.F_OWNER(+)      AND
	      OBJ.OBJECT_NAME = STO.F_NAME(+)       AND
	      OBJ.OBJECT_TYPE = STO.F_TYPE(+)       AND
	      OBJ.OBJECT_NAME = DEB.OBJECT_NAME(+)  AND
	      OBJ.OWNER       = DEB.OWNER(+)        AND
	      OBJ.OBJECT_TYPE = DEB.OBJECT_TYPE(+)  AND
         OBJ.OWNER         <> 'PUBLIC'         AND
         OBJ.OWNER   NOT LIKE '%SYS%'          AND
         EXT.F_SIZE/1024/1024 > 100
ORDER BY 1 DESC;

PROMPT

start sqlend.sql

