--2.0 Install
create table p155121.t_2_proc (a number);


--Ex 2.1 CREATE / REPLACE /RE-compile
create or replace procedure p155121.my_p is
de_n number;
begin  
select count(*) into de_n  from t_2_proc ;
delete from t_2_proc ;
end /*my_p*/; 
/

--Ex 2.1 NESTED PROCEDURE
-- can declare proc or func  BUT NOT after variable declaration!!!
create or replace procedure p155121.p_21 is
de_n number;
procedure nest_p IS
begin
   de_n:=0;
end ;
function nest_f  return number IS
begin
   nest_p;
   return 1;
end ;
--de_n_after number; this genereta COMPILE error: cantt declare var after LOCAL proc/func
   begin  
      de_n:=nest_f();
   end ; 
/



--recompile after external changes
select status from all_objects where object_name ='MY_P';--is VALID
alter table t_2_proc add  (e  number); --->> still valid
drop table t_2_proc ;--> invalid
select status from all_objects where object_name ='MY_P';--is INVALID
create table p155121.t_2_proc (a number);--here still invalid
--RECOMPILE
alter procedure p155121.my_p compile; -->
select status from all_objects where object_name ='MY_P';--is VALID again !!!!
--DROP
drop procedure p155121.my_p ;
--INVOKE
EXECUTE p155121.my_p; --plsql:  if was invalid would have recompiled and executed
begin p155121.my_p ; end; /





--Ex 2.2 Parameters
   --NAME
   --TYPE (IN - OUT - IN OUT - default in)
   --DATATYPE : NO precision!  , %TYPE is allowed
   --DEFAULT  : := | default

      --Mixed Notation
      create or replace procedure p155121.p_2_mixed_notation(a number,b number, c number) is
      begin null;end ; /
      execute p155121.p_2_mixed_notation(a=>1,2,c=>3);--NOK
      execute p155121.p_2_mixed_notation(1,2,c=>3);--OK

      --
      create or replace procedure p155121.p_2_3(a number default 0,b number  default 1) is
      begin null;end ; 
      
      execute p155121.p_2_3(2,3);
      execute p155121.p_2_3(2);--IT works ! exercise were wrong!
   


insert into t_2_proc  values (1);
insert into t_2_proc  values (1);--2 rows --


--EXCEPTION:override current exception
create or replace procedure p_2_except is 
my_exception exception;
var number;
begin
   select a into var from t_2_proc    where  a= a;
   exception when others then
--   raise my_exception ;
   dbms_output.put_line('t_2_proc EXCEPTION:'||sqlcode ||'-'||sqlerrm);
end;

execute p_2_except ;--exec p_2_except ;
--execute  immediate ' call p_2_except' ; --doesnt work...


--Ex 2.3 Data Dictionary
   --DEPENDENCY
      select * from user_dependencies;
         --   MY_P  PROCEDURE   SYS      STANDARD                      PACKAGE     6678  HARD
         --   MY_P  PROCEDURE   SYS      SYS_STUB_FOR_PURITY_ANALYSIS  PACKAGE     6678  HARD
         --   MY_P  PROCEDURE   P155121  T_2_PROC                      TABLE       6678  HARD

      select * from all_dependencies where owner='ADPROV' and name = 'PCK_LOGA_ADAPTER';
      --OBJECTS
         select * from user_objects;
         select * from all_objects where (subobject_name is not null or  secondary ='Y' ) and owner not in ('SYS','SYSTEM')         ;         
         --subobject are for partitioned objects (table indexes)
         --created = timestamp(this is a varchar) !
         
      --OBJECT_SIZE
         select * from user_object_size;  --so
         select * from dba_object_size where  type not like 'JAVA%' and type not like 'VIEW%' ;
      --OBJECT_SOURCE
         select * from user_source;
      --OBJECT_ERRORS
         select * from user_errors;

--line is the code line generarting error
create or replace procedure p_2_err IS
begin
dbms_output.put_line('text');
dbms_output.put_line('text');
dbms_output.put_line('text');
dbms_output.put_line('text');
dbms_output.put_line('text');
                   FEHLER !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
dbms_output.put_line('text');
dbms_output.put_line('text');
dbms_output.put_line('text');
dbms_output.put_line('text');
end p_2_err ;

show errors;--funzia ma non mostra nulla
         
         
         
