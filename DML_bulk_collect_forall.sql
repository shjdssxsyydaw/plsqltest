-- 

--    B U L K   C O L L E C T  (SELECT)
--    retrieve multiple rows with a single fetch, improving the speed of data retrieval
--    if there are too many data it may consume the memory,so you can fetch  up  limited nt of rows in a cursor
--    to <limit> rows:LIMIT c_limit;  FETCH employees_cur BULK COLLECT INTO l_employee_ids      LIMIT c_limit;
--    



   declare
       TYPE orga_t IS TABLE OF ap_ad_organzst.orgz_orga_instanz%TYPE
         INDEX BY PLS_INTEGER; 
       l_orga orga_t ;
   begin
      dbms_output.put_line('1-'||DBMS_UTILITY.get_cpu_time);
      null;
      SELECT orgz_orga_instanz
      BULK COLLECT INTO l_orga
      --LIMIT 1000; becca 100 rows
      FROM ap_ad_organzst
      --WHERE department_id = increase_salary.department_id_in
      ;      
      dbms_output.put_line('2-'||DBMS_UTILITY.get_cpu_time);      
      FOR indx IN 1 .. l_orga.COUNT
      LOOP
         null;
      END LOOP;   
      dbms_output.put_line('3-'||DBMS_UTILITY.get_cpu_time);      

      FOR indx IN (select orgz_orga_instanz  from ap_ad_organzst)
      LOOP
         null;
      END LOOP;   
      dbms_output.put_line('4-'||DBMS_UTILITY.get_cpu_time);      

   end;
   

--    F O R A L L (NSERT,UPDATE,DELETE)
--    that use collections to change multiple rows of data very quickly
--     MUST reference bulk collect cursor!!!!!!!!!!
--     Generate all the DML statements that would have been executed one row at a time, and send them all across to the SQL engine with one context switch.
--     errors: SAVE EXCEPTIONS -lets u save errors
   create table t_b (a number);
   begin
      for i in 1..10000 loop
      insert into t_b values (i);
      end loop;
   end;

   declare
       TYPE orga_t IS TABLE OF t_b.a%TYPE
         INDEX BY PLS_INTEGER; 
       l_t_b orga_t ;
   begin
      --bulk collect
      dbms_output.put_line('1-'||DBMS_UTILITY.get_cpu_time);
      SELECT a
      BULK COLLECT INTO l_t_b
      FROM t_b;      
   
      dbms_output.put_line('2-'||DBMS_UTILITY.get_cpu_time);
      FORALL indx IN 1 .. l_t_b.COUNT
         UPDATE t_b set a=1
         where a = l_t_b(indx)
         ;
      dbms_output.put_line('3-'||DBMS_UTILITY.get_cpu_time);
         UPDATE t_b set a=2;
      dbms_output.put_line('4-'||DBMS_UTILITY.get_cpu_time);               
   end;


   -- save exception
   BEGIN
      FORALL indx IN 1 .. l_eligible_ids.COUNT SAVE EXCEPTIONS
         UPDATE employees emp
            SET emp.salary =
                   emp.salary + emp.salary * increase_pct_in
          WHERE emp.employee_id = l_eligible_ids (indx);
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE = -24381
         THEN
            FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT
            LOOP
               DBMS_OUTPUT.put_line (
                     SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX
                  || ‘: ‘
                  || SQL%BULK_EXCEPTIONS (indx).ERROR_CODE);
            END LOOP;
         ELSE
            RAISE;
         END IF;
   END increase_salary;
 

--PLSQL / SQL cntext switching  
-- assume there are 100 rows and 20 on dept = 10  

-- 20 context switch
SELECT betwnstr (last_name, 2, 6)   FROM employees WHERE department_id = 10;
-- 100 context switch
SELECT employee_id   FROM employees WHERE betwnstr (last_name, 2, 6) = 'MITHY';

-------------------------------------------------------------------------------   
--example from feuerstein

/* Timer utility */

CREATE OR REPLACE PACKAGE sf_timer
IS
   PROCEDURE start_timer;

   PROCEDURE show_elapsed_time (message_in IN VARCHAR2 := NULL);
END sf_timer;
/

CREATE OR REPLACE PACKAGE BODY sf_timer
IS
   /* Package variable which stores the last timing made */
   last_timing   NUMBER := NULL;

   PROCEDURE start_timer
   IS
   BEGIN
      last_timing := DBMS_UTILITY.get_cpu_time;
   END;

   PROCEDURE show_elapsed_time (message_in IN VARCHAR2 := NULL)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
            '"'
         || message_in
         || '" completed in: '
         || (DBMS_UTILITY.get_cpu_time - last_timing) / 100
         || ' seconds');

      start_timer;
   END;
END sf_timer;
/

CREATE TABLE parts
(
   partnum    NUMBER,
   partname   VARCHAR2 (15)
)
/

CREATE TABLE parts2
(
   partnum    NUMBER,
   partname   VARCHAR2 (15)
)
/

DROP TYPE parts_ot FORCE
/

CREATE OR REPLACE TYPE parts_ot IS OBJECT
(
   partnum NUMBER,
   partname VARCHAR2 (15)
)
/

CREATE OR REPLACE TYPE partstab IS TABLE OF parts_ot;
/

DECLARE
   PROCEDURE compare_inserting (num IN INTEGER)
   IS
      TYPE numtab IS TABLE OF parts.partnum%TYPE;

      TYPE nametab IS TABLE OF parts.partname%TYPE;

      TYPE parts_t IS TABLE OF parts%ROWTYPE
         INDEX BY PLS_INTEGER;

      parts_tab   parts_t;

      pnums       numtab := numtab ();
      pnames      nametab := nametab ();
      parts_nt    partstab := partstab ();
   BEGIN
      pnums.EXTEND (num);
      pnames.EXTEND (num);
      parts_nt.EXTEND (num);

      FOR indx IN 1 .. num
      LOOP
         pnums (indx) := indx;
         pnames (indx) := 'Part ' || TO_CHAR (indx);
         parts_nt (indx) := parts_ot (NULL, NULL);
         parts_nt (indx).partnum := indx;
         parts_nt (indx).partname := pnames (indx);
      END LOOP;

      sf_timer.start_timer;

      FOR indx IN 1 .. num
      LOOP
         INSERT INTO parts
              VALUES (pnums (indx), pnames (indx));
      END LOOP;

      sf_timer.show_elapsed_time (
         'FOR loop (row by row)' || num);

      ROLLBACK;

      sf_timer.start_timer;

      FORALL indx IN 1 .. num
         INSERT INTO parts
              VALUES (pnums (indx), pnames (indx));

      sf_timer.show_elapsed_time ('FORALL (bulk)' || num);

      ROLLBACK;

      sf_timer.start_timer;

      INSERT INTO parts
         SELECT * FROM TABLE (parts_nt);

      sf_timer.show_elapsed_time (
         'Insert Select from nested table ' || num);

      ROLLBACK;

      sf_timer.start_timer;

      INSERT /*+ APPEND */
            INTO  parts
         SELECT * FROM TABLE (parts_nt);

      sf_timer.show_elapsed_time (
         'Insert Select WITH DIRECT PATH ' || num);

      ROLLBACK;

      EXECUTE IMMEDIATE 'TRUNCATE TABLE parts';

      /* Load up the table. */
      FOR indx IN 1 .. num
      LOOP
         INSERT INTO parts
              VALUES (indx, 'Part ' || TO_CHAR (indx));
      END LOOP;

      COMMIT;

      DBMS_SESSION.free_unused_user_memory;

      sf_timer.start_timer;

      INSERT INTO parts2
         SELECT * FROM parts;

      sf_timer.show_elapsed_time ('Insert Select 100% SQL');

      EXECUTE IMMEDIATE 'TRUNCATE TABLE parts2';

      DBMS_SESSION.free_unused_user_memory;

      sf_timer.start_timer;

      SELECT *
        BULK COLLECT INTO parts_tab
        FROM parts;

      FORALL indx IN parts_tab.FIRST .. parts_tab.LAST
         INSERT INTO parts2
              VALUES parts_tab (indx);

      sf_timer.show_elapsed_time ('BULK COLLECT - FORALL');
   END;
BEGIN
   compare_inserting (100000);
END;
/

DROP TABLE parts
/

DROP TABLE parts2
/

DROP PACKAGE sf_timer



/*
output
"FOR loop (row by row)100000" completed in: 11.12 seconds
"FORALL (bulk)100000" completed in: .06 seconds
"Insert Select from nested table 100000" completed in: .18 seconds
"Insert Select WITH DIRECT PATH 100000" completed in: .18 seconds
"Insert Select 100% SQL" completed in: .05 seconds
"BULK COLLECT - FORALL" completed in: .14 seconds


*/
/
