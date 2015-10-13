-- 3 RECORD
--https://docs.oracle.com/cd/B10501_01/appdev.920/a96624/05_colls.htm#19834
What Is a Record?

DECLARE
   TYPE TimeRec IS RECORD (
      secs SMALLINT := 0,
      mins SMALLINT := 0,
      hrs  SMALLINT := 0);
BEGIN
   ...
END;

When calling a parameterless function, use the following syntax:
function_name().field_name -- note empty parameter list

NESTEd 
BEGIN
   ...
   IF item(3).duration.minutes > 30 THEN ...  -- call function
END;

Assigning Null Values to Records

To set all the fields in a record to null, simply assign to it an uninitialized record of the same type, as shown in the following example:
DECLARE TYPE EmpRec IS RECORD ( emp_id emp.empno%TYPE, job_title VARCHAR2(9), salary NUMBER(7,2)); emp_info EmpRec; emp_null EmpRec; BEGIN emp_info.emp_id := 7788; emp_info.job_title := 'ANALYST'; emp_info.salary := 3500; emp_info := emp_null; -- nulls all fields in emp_info ... END;

