--Ex 5.0 install 
create table t_5 (a number);

--Ex 5.1  CREATE ALTER DROP
--SPEC
create or replace package
pk_5 is

a number;
end;
/

--BODY

--ALTER
alter package pk_5 compile;
alter package body pk_5 compile;


--Ex 5.1  GLOBAL variables (public and private)
--SPEC
create or replace package pk_5 is
   de_global_public number default 0;
   procedure f_count ; 
end;
/
--BODY
create or replace package body  pk_5 is
   de_global_private number default 0;
  procedure f_count
   IS
   begin 
   de_global_private := de_global_private  + 1;
   de_global_public  := de_global_public + 1 ;
     dbms_output.put_line('private:'||de_global_private ||' public:'||de_global_public);
   end f_count;

end pk_5;
/
select * from user_objects where object_name ='PK_5';
--
begin
   for i in 1..10 loop
      pk_5.f_count;
   end loop;   
      dbms_output.put_line(--'private:'||de_global_private ||
                           ' public:'||pk_5.de_global_public);
end;


----spec invalid/spec valid : body auto recompile at first call 

create or replace package body  pk_51 is      procedure f_count   IS         begin             dbms_output.put_line('f_count');         end f_count;      end pk_51;/
select * from user_objects where object_name ='PK_51';
create or replace package pk_51 is    eeeeeeeerrr; end;
select * from user_objects where object_name ='PK_51'; --spec & body INVALID
create or replace package pk_51 is    procedure f_count ; end;--the right one
select * from user_objects where object_name ='PK_51';--ok but body still invalid
execute pk_51.f_count;                                   -- AUTOMATIC RECOMPILE
select * from user_objects where object_name ='PK_51';

-------------------------------------------------
--Ex 5.2  PRAGMA SERIALLY_REUSABLE inibiht var tipo loga, must declare so spec AND body sonst compile error.
--
create or replace package pk_5 is  PRAGMA SERIALLY_REUSABLE; 
  de_global_public number default 0;   procedure f_count ; end;/
create or replace package body  pk_5 is PRAGMA SERIALLY_REUSABLE;
   de_global_private number default 0;
  procedure f_count   IS   begin 
   de_global_private := de_global_private  + 1;
   de_global_public  := de_global_public + 1 ;
     dbms_output.put_line('private:'||de_global_private ||' public:'||de_global_public);
   end f_count;
end pk_5;
/
select * from user_objects where object_name ='PK_5';
--
begin    for i in 1..10 loop  pk_5.f_count;  end loop;      dbms_output.put_line(' public:'||pk_5.de_global_public); end;

--Stampa sempre 1 to 10 invece di incrementare decina


---
create or replace package pk_51 is   
function   f_count(a number)  return number; 
end;
/

create or replace package body  pk_51 is 
   function f_count(a number) return number is
      begin
         return 3;
      end f_count;
end pk_51;
/

-------------------------------------------------
--Ex 5.3 DESC :works only in sqlplus
               --cant DESC invalid objects
desc p155121.pk_51;

create or replace package pk_53 is a number; end;
create or replace package body  pk_53 is 
b number;  
function f  return number is 
   begin 
      return 1; 
   end f;
end;
/

describe  p155121.pk_53 ;
  DESC table view   synonym   function package;


----
--Ex 5.4 if drop spec ALSO BODY is DROPPED!!!! (not viceversa)
create or replace package pk_54 is
function f1 return NUMBER;
end  pk_54 ;

create or replace package body pk_54 is
   function f1  return number is
      begin
      return 1;
   end f1;
end pk_54 ;

select * from user_objects where object_name like '%PK_54%';
drop package  pk_54;

--can name k same as a p
select * from user_objects where object_name like '%PK_O%';
create or replace package pk_overload is
   procedure pk_overload  ;
end pk_overload;
/



--function purity : pragma  --dichiarata in pack spec cosi i dvlper sanno
--    if declare the pragma the func is controlled!!!
create or replace package p_f_purity_pragma is 
   pragma restrict_references(p_f_purity_pragma,wnds,wnps,rnps,rnds);--THIS ONE APLLY to the initialization block

   function f_all return number;
   --tables
      function f_wnds return number;--R but cant wr
      function f_rnds return number;--W but cant R 
   -- package variable
      function f_wnps return number;--R but cant wr
      function f_rnps return number;--W but cant R 

   pragma restrict_references(f_all,wnds,wnps,rnps,rnds);--
   pragma restrict_references(f_wnds,wnds);--   
   pragma restrict_references(f_rnds,rnds);--   
   pragma restrict_references(f_wnps,wnps);--   
   pragma restrict_references(f_rnps,rnps);--   
--DEFAULT x all    pragma restrict_references(default,rnps);--   
   


end  p_f_purity_pragma ;

create or replace package body p_f_purity_pragma is 
   my_var number;

   function f_all return number is 
      begin
--         commit;--[1]: 2/1     PLS-00452: Subprogram 'F_P' violates its associated pragma
      return 2;
   end f_all;

-- T A B L E S
   function f_wnds return number is
   var number;
   begin
      select  a into var from t_5  ;  --OK !!!
--      insert into  t_5 values (10) ;  --[1]: 8/4     PLS-00452: Subprogram 'F_WNDS' violates its associated pragma
         my_var := 100;
      return 2;   
   end f_wnds ;

   function f_rnds return number is
   var number;
   begin
--      select  a into var from t_5  ;  --OK !!!
      insert into  t_5 values (10) ;  --[1]: 8/4     PLS-00452: Subprogram 'F_WNDS' violates its associated pragma
         my_var := 100;
      return 2;   
   end f_rnds ;

--PRCEDURE
   function f_wnps return number is
   begin
--        my_var := 100;  violates its associated pragma
      return 2;   
   end f_wnps ;

   function f_rnps return number is
   var number;
   begin
       my_var := 100;--OK
--       var := my_var;-- violates its associated pragma
      return 2;   
   end f_rnps ;

   
end  p_f_purity_pragma ;
-- [1]: 2/1     PLS-00452: Subprogram 'F_P' violates its associated pragma
-- [1]: 8/4     PLS-00452: Subprogram 'F_WNDS' violates its associated pragma
--  [1]: 30/4    PLS-00452: Subprogram 'F_WNPS' violates its associated pragma



create or replace function my_f_comm(a number) return number is 

begin
commit;
return 1;end ;


--Ex 6.0 install 

--Ex 6.1  OVERLOAD :examples that doesnt work   /           compile but get run time error
   --          just rename forma parameter
   create or replace package pk_6 is
      function adding (a number, b number ) return number;
      function adding (c number, d number ) return number;
   end;
   /
   create or replace package BODY pk_6 is
      function adding (a number, b number ) return number is begin return 1; end;
      function adding (c number, d number ) return number is begin return 1; end;
   end;
   /
   select pk_6.adding(1,1) from dual;--HERE ERROR [1]: ORA-06553: PLS-307: too many declarations of 'ADDING' match this call
   --        DIFFERENT return type   ( & just rename forma parameter)
   create or replace package pk_6 is
      function adding (a number, b number ) return number;
      function adding (c number, d number ) return integer;
   end;
   /
   create or replace package BODY pk_6 is
      function adding (a number, b number ) return number is begin return 1; end;
      function adding (c number, d number ) return integer is begin return 1; end;
   end;
   /
   select pk_6.adding(1,1) from dual;--HERE ERROR [1]: ORA-06553: PLS-307: too many declarations of 'ADDING' match this call

--Ex 6.2 USER_ARGUMENTS
select 
package_name,
object_name,overload,argument_name,in_out,position,data_type,data_type,data_length
from user_arguments 
where package_name='PK_6' 
;
--Ex 6.3 USER_dependencies
select * from USER_dependencies
;

   --        Variable:  global private local 
   create or replace package pk_6_var  is
   PRAGMA SERIALLY_REUSABLE ;
      global_var number default 10;
      function inc_glob (a number ) return number;
   end;
   /
   create or replace package BODY pk_6_var is
    PRAGMA SERIALLY_REUSABLE;
      private_var number default 100;
      function inc_glob (a number ) return number is begin 
      private_var := private_var + 1;
      return private_var; 
      end;
   end;
   /
select * from user_objects where object_name ='PK_6_VAR';

--   SESSION 1  schema x
declare  a number;
begin 
for i in 1..3 loop
--pk_6_var.private_var:=pk_6_var.private_var + 1; CANT aCCESS from outside
dbms_output.put_line(pk_6_var.inc_glob(0) 
--||' / pk_6_var.private_var'||pk_6_var.private_var CANT aCCESS from outside
);
dbms_lock.sleep(1);
end loop;
end;
/
--   SESSION 2 schema x
declare  a number;
begin 
for i in 1..3 loop
dbms_output.put_line(pk_6_var.inc_glob(0));
dbms_lock.sleep(1);
end loop;
end;
/
--   SESSION 3 schema y

la 1 la 2 2 e la 3 vedono la ,loro globale e stamapno 100 - 110.... thats it!
