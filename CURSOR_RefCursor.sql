SET ECHO OFF
SET VERIFY OFF
--Find out what tables the user wants to see.
--A null response results in seeing all the tables.
ACCEPT s_table_like PROMPT 'List tables LIKE > '
     
VARIABLE l_table_list REFCURSOR
     
--This PL/SQL block sets the l_table_list variable
--to the correct query, depending on whether or
--not the user specified all or part of a table_name.
BEGIN
  IF '&s_table_like' IS NULL THEN
    OPEN :l_table_list FOR 
      SELECT table_name 
        FROM user_tables;
  ELSE
    OPEN :l_table_list FOR
      SELECT table_name
        FROM user_tables
       WHERE table_name LIKE UPPER('&s_table_like');
  END IF;
END;
/
     
--Print the list of tables the user wants to see.
PRINT l_table_list

