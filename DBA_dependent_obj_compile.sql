start sqlbegin.sql

PROMPT ======================================================================================================
PROMPT C O M P I L E   D E P E N D E N T  O B J E C T S only Package
PROMPT ------------------------------------------------------------------------------------------------------

ACCEPT cFLTOWN PROMPT 'Selektion Package ...........? ( Default=Alle ) '
ACCEPT cFLTALL PROMPT 'Alle Referenzen .............? ( Default=N )    '

PROMPT ======================================================================================================
PROMPT

PROMPT
PROMPT DURCH COMPILIEREN DES HEADER FALLEN FOLGENDE BODIES INVALID
PROMPT ------------------------------------------------------------

BREAK ON OWNER ON NAME SKIP 1

SELECT  /*+ RULE */
        SUBSTR(DEP.REFERENCED_OWNER,1,8)        "Owner",
        DEP.REFERENCED_NAME  		               "Name",
        SUBSTR(DEP.OWNER,1,8)	                  "Ref_Owner",
	DEP.NAME  		                              "Ref_Name",
        DEP.TYPE		  	                        "Ref_Type", 
        SUBSTR(TO_CHAR(OBJ.LAST_DDL_TIME,'DD.MM.YY HH24:MI'),1,15) "Change"
   FROM  dba_dependencies DEP, DBA_OBJECTS OBJ
   WHERE OBJ.OBJECT_NAME  = DEP.NAME             AND
         OBJ.OWNER        = DEP.OWNER            AND
         OBJ.OBJECT_TYPE  = DEP.TYPE             AND
         DEP.REFERENCED_NAME like '%&cFLTOWN%'	 AND
      (( DEP.REFERENCED_TYPE LIKE 'PACKAGE%'     AND  DEP.TYPE LIKE 'PACKAGE%' )
	   OR '[&cFLTALL]' = '[Y]' )
   ORDER BY 1,2,3,4,5,6;

PROMPT
PROMPT CALLS IN AUFRUFEN IND DEN PACKAGE SIND ( NO INVALID ) 
PROMPT ------------------------------------------------------

BREAK ON OWNER ON NAME SKIP 1

SELECT  /*+ RULE */
        SUBSTR(DEP.OWNER,1,8)                   "Owner",
        DEP.NAME     			                  "Name",
        SUBSTR(DEP.REFERENCED_OWNER,1,8)	      "Ref_Owner",
	DEP.REFERENCED_NAME  		                  "Ref_Name",
        DEP.REFERENCED_TYPE		  	            "Ref_Type", 
        SUBSTR(TO_CHAR(OBJ.LAST_DDL_TIME,'DD.MM.YY HH24:MI'),1,15) "Change"
   FROM  dba_dependencies DEP, DBA_OBJECTS OBJ
   WHERE OBJ.OBJECT_NAME  = DEP.REFERENCED_NAME  AND
         OBJ.OWNER        = DEP.REFERENCED_OWNER AND
         OBJ.OBJECT_TYPE  = DEP.REFERENCED_TYPE  AND
         DEP.NAME like '%&cFLTOWN%'	   	    AND
      ((	DEP.TYPE LIKE 'PACKAGE%'             AND  DEP.REFERENCED_TYPE LIKE 'PACKAGE%')
      OR '[&cFLTALL]' = '[Y]' )
   ORDER BY 1,2,3,4,5,6;

start sqlend

