--Ex 11.0 install 
create table t_11 (a number);
insert into t_11 (a) values (200);
create or replace function f_11 (a number) return number is
my_var number;
BEGIN
select a into my_var from t_11 where rownum < 2;
dbms_output.put_line('f_11:'||to_char(my_var));
return my_var;
end;

--Ex 11.1
select * from user_dependencies;

select * from user_dependencies where name = 'F_11' ;

select * from dba_dependencies 
--where name = 'F_11' 
--where referenced_link_name is not null
where name like 'PCK_AP_AD_ORGANE'
 and type ='PACKAGE BODY'  
;
 
 select * from dba_objects
 where object_name like '%DEPTRE%'
--
 ;


select * from  public_dependency  -- obj not SYS!!!
where object_id=604828
; --id,referenced_id




select p1.object_id,o1.object_name,p1.referenced_object_id,o2.object_name
from  
public_dependency  p1,dba_objects o1,dba_objects o2
where p1.object_id=o1.object_id and o2.object_id=p1.referenced_object_id
;
desc public_dependency;
select * from dba_objects  where object_name = 'PUBLIC_DEPENDENCY' ;--id 604828

select * from user_objects  where object_name = 'F_11' ;--id 604828
select * from user_objects  where object_id in 
(select  referenced_object_id    from  public_dependency
--where object_id=604828
);

-- I n s t a l l
   1   utldtree.sql creates: 
      SEQUENCE  deptree_seq
      Table     deptree_tmptab --order by seq# is a kind of line nr
      Procedure deptree_fill
      VIEW      deptree
                ideptree
-- Create i n s t  a n c e                 
   2  exec deptree_fill('FUNCTION','F_11','P155121');
         deptree_tmptab table is populated

    -- D E P T R E E
   select * from deptree_tmptab  where seq#;

    -- I d e p t r e e  (dependencies) has just one Column
   select * from ideptree;   

--Ex 11.3 Internal


--Ex 11.4 External
select * from v$parameter where name = 'remote_dependencies_mode'; 

alter table t_11 add  (t number );--func get invalid

select 
owner||'.'||object_name obj ,
object_type,
last_ddl_time,status
from user_dependencies d ,dba_objects o
where d.name = 'F_11' 
and (o.object_name=d.referenced_name or o.object_name=d.name )
;

--call and get VALID
begin  dbms_output.put_line(f_11 (1)) ; end;


--Ex 11.5 : proc refere package
create or replace package  pk_115 is    procedure p  ; end pk_115;
create or replace package  body pk_115 is 
   procedure p  is 
   begin
      null;
   end p; 
end pk_115;
create or replace procedure p_115 is begin  pk_115.p;  end;

select * from user_dependencies where referenced_name like '%115%' or   name like '%115%';
/*P_115    PROCEDURE      P155121  PK_115                        PACKAGE
P_115    PROCEDURE      SYS      SYS_STUB_FOR_PURITY_ANALYSIS  PACKAGE
PK_115   PACKAGE BODY   P155121  PK_115                        PACKAGE*/

--recompile spec: -->  proc get invalid
select * from user_objects where object_name like '%115%';




