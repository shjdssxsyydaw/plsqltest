--Ex 3.0 install 
create table t_3 (a number);
create table t_31 (a number);

--Ex 3.1 CREATE or REPLACE
create or replace function my_f  (a number)return number is begin return 1; end; 
create or replace function my_f_as (a number)return number as begin return 1; end; 
create or replace function my_f2 (a boolean)return boolean is begin return true; end; --can call only in PLSQL , by the way non compila

select * from user_errors;

--COMPILA but  RUNTIME ERROR
create or replace function my_f_no_return  (a number)return number is n number;begin 
  n:=1;  end; 
select my_f_no_return  (1)from dual;--[1]: ORA-06503: PL/SQL: Function returned without value


--Ex 3.2 OUT param : canT SQL !
create or replace function my_f_with_OUT  (a out number)return number is begin a := 100; return 1; end; 
--    SQL : get error
select my_f_with_OUT(1)   from dual;
-- in PL funzia
declare my_out number; begin 
dbms_output.put_line('func ret:'||my_f_with_OUT(my_out )||' my_out id:'||my_out);  end;
--    PL/SQL: compile but ge trun time error
--NOTE here crate correctly the procedure al
create or replace procedure my_p32  is 
n1 number;
n2 number;
begin 
n1:=my_f_with_OUT  (n2);
select my_f_with_OUT(n2)   into n1 from dual;
end; 
select status from user_objects where object_name='MY_P32'; --VALID!!!!
execute my_p32; ----BUT if YOU execute you get error!!!!!!

--Ex 3.4 --cant DML from a select!
create or replace function my_f3_sel(a number) return number is
begin
insert into t_3 values (a);
return 3;
end my_f3_sel;


--PL ok!
begin dbms_output.put_line(my_f3_sel(4) );  end;
select * from t_3;

-- SELECT NOK
select my_f3_sel(2) from dual;--[1]: ORA-14551: cannot perform a DML operation inside a query 
select my_p3_sel(2) from dual;--[1]: ORA-14551: cannot perform a DML operation inside a query 
-- INSERT UPDATE DELETE --it works!!!!
insert into  t_31 values(my_f3_sel(31) );


declare 
a number;
begin
call substr('aaaa','a',1) into a; 
end;
/
--Ex 3.5 Function that commit : OK PLSQL - Nok SQL
create or replace function my_f_comm(a number) return number is begin
commit;
return 1;end ;
--PL
declare  a number;begin a:=my_f_comm(7) ; end;
--SQL
select my_f_comm(7)  from dual;--[1]: ORA-14552: cannot perform a DDL, commit or rollback inside a query or DML 



 

