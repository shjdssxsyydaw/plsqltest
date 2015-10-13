--  E X C E P T I O N
   --USER DEFINED
   --1) declare raise handle
   -- no nr involved
   declare
     v_bezeichnung     einheit.bezeichnung%TYPE;
     EINHEIT_FEHLER    EXCEPTION;
   begin
     select bezeichnung into v_bezeichnung    from einheit    where einheit_kurz = 'm';
     if v_bezeichnung <> 'Meter' then
       raise EINHEIT_FEHLER;
     end if;
   exception when EINHEIT_FEHLER then
     ...

   end;

   --2) PRAGMA EXCEPTION_INIT  : Trapping Non-Predefined Oracle Server Errors
   --You can trap a nonpredefined Oracle server error by declaring it first. 
   --PRAGMA EXCEPTION_INIT instructs the compiler to associate an exception name with an Oracle error number. 

   declare
     v_bezeichnung    einheit.bezeichnung%TYPE;
     EINHEIT_FEHLER   EXCEPTION;
     PRAGMA EXCEPTION_INIT (EINHEIT_FEHLER, -20100);
   begin
     select bezeichnung into v_bezeichnung    from einheit    where einheit_kurz = 'm';
     if v_bezeichnung <> 'Meter' then
       raise_application_error (-20100, 'Bezeichnung falsch');
     end if;
   exception when EINHEIT_FEHLER then
     ...
   end;

   select * from all_source where lower(text) like '%exception_init%'and owner not like 'S%' and owner not like 'D%';

   --3)raise application error
   -- -20000 to -20999
   -- has 3 parameter  ( numer , msg, should_propagate true/false)
   RAISE_APPLICATION_ERROR   
   http://www.toadworld.com/platforms/oracle/b/weblog/archive/2010/07/14/raise-vs-raise-application-error.aspx
   TRIGGER employees_minsal_tr
   BEFORE INSERT OR UPDATE
   ON employees
   FOR EACH ROW
   BEGIN
   IF :new.salary < 1000000
   THEN
      RAISE_APPLICATION_ERROR (-20000,
          'Salary of '|| :new.salary ||
          ' is too low. It must be at least $100,000.');
   END IF;
END;
   
  --raise VS RAISE_APPLICATION_ERROR   
  1 is for defined exception the others is for uderdefined exception
    
  --EXCEPTION:override current exception
    create or replace procedure p_2_except is 
    my_exception exception;
    var number;
    begin
        select a into var from t_2_proc    where  a= a;
      exception when others then
   --     raise my_exception ;
       dbms_output.put_line('t_2_proc EXCEPTION:'||sqlcode ||'-'||sqlerrm);
    end;
  
    execute p_2_except ;--exec p_2_except ;
    --execute  immediate ' call p_2_except' ; --doesnt work...
  
  
  ---------------------------------------------------------------------------
  -- PROPAGATING a trappe exception: just raise!!!!
  exceptions when others then
--trapped it!
  raise;-- and repropagate!



declare
  -- 1)
  my_exception exception;-- by default sqlcode: 1  sqlerrm: User-Defined Exception
                      --sqlcode:-20101 sqlerrm:ORA-20101: 
  -- 2) 
  PRAGMA EXCEPTION_INIT(my_exception, -20101);
  -- 3) raise_application_error( nr,msg,is_in_stack
  a number;
begin
  dbms_output.enable();
  dbms_output.put_line('outer block');
  a:=1;

  --raise a standard exception
  --raise -1476;  --ERROR (-1476 is no_data_found)
  --raise no_data_found;

    begin 
      dbms_output.put_line('inner block');
      --raise my_exception;
      --a:= 1/0;
      raise_application_error(-20101,'my defined msg',true);
    end;
  raise my_exception;
exception 
  --when zero_div
  when no_data_found then
    dbms_output.put_line(sqlcode ||sqlerrm);
  when my_exception then 
    dbms_output.put_line('my_exception sqlcode:' ||sqlcode ||' sqlerrm:'||sqlerrm);
  when others then
    dbms_output.put_line('sqlcode:' ||sqlcode ||' sqlerrm:'||sqlerrm);
end;
/
set serveroutput on;
--https://docs.oracle.com/cd/B19306_01/appdev.102/b14261/errors.htm#i1871

