--Ex 9.0 install 
--drop table t_9;
create table t_9 (a number);
create table t_9_msg (msg varchar2(512) ,ts timestamp);
create table t_9_restr (a number);

create table t_9_v1 (a number primary key ,b number,c number);
create table t_9_v2 (a number primary key ,c2 number,c3 number);
insert into t_9_v1   values(1,1,1);
insert into t_9_v2   values(1,10,10);
insert into t_9_v2   values(2,20,20);
insert into t_9_v1   values(3,1,1);
insert into t_9_v2   values(3,10,10);
create table t_94  (a number );

create or replace view vw_9  as select t1.a,b,c2 from t_9_v1 t1 join t_9_v2 t2 on t1.a=t2.a ;
select * from vw_9 ;
select * from t_9_v1 ;
select * from t_9_v2 ;
update vw_9 set  c2=1000;
update vw_9 set  a=1000 where c2=1000;


--Ex 9.1  General example
CREATE OR REPLACE  TRIGGER trig_9 
BEFORE -- |AFTER | INSTEAD OF(xViews)
insert OR  update or delete on t_9      --database event can or,but only 1 tab
--update of col1,col2,col3
REFERENCING OLD as my_old --NULL by INSERT
            NEW as my_new --NULL by DELETE

--trigger level : FOR EACH STATEMENT (default x tab) |
--                FOR EACH ROW        (for INSTEAD OF is the only possibilities) 
--WHEN () criteria  (only valid FOR EACH ROW)                     (old.quantity > 0)
--declare 
begin 
   --IF INSERTING
   --IF UPDATING
   --IF DELETING
   --IF IS_SERVERERROR
end;

--before , after only events on tables
CREATE OR REPLACE  TRIGGER trig_9 
BEFORE insert on t_9    
REFERENCING OLD as my_old
            NEW as my_new
begin 
   insert into t_9_msg values('insertion in t_9:',systimestamp);
--   dbms_output.put_line(my_old.a ||'-'||:my_new.a);
end;
drop trigger t_9;
insert into t_9 values(10);
select * from t_9_msg;--triggered


------------
--Ex 9.2
insert into t_9 values(1000);
update vw_9 set  c2=11000;
select * from t_9_msg;--triggered
delete from t_9_msg;--triggered

--todo updatre delete
   --BEFORE
      --statement(default)
      CREATE OR REPLACE  TRIGGER trig_92_bef 
      BEFORE insert on t_9    
      declare
      my_var number;--declare
      begin 
         if updating then   --never fires is an inserting trigger
            insert into t_9_msg values('insertion in t_9:trigger  t_92(BEFORE)-',systimestamp);
         end if;
      end;

      --ROW statement
      CREATE OR REPLACE  TRIGGER trig_92_bef_row
      BEFORE insert on t_9    
      for each row --For each row
      when  (new.a >999 ) --WHEN
            --when  (old.a >999 ) with INSERT old is always NULL!!
      begin 
         insert into t_9_msg values('insertion in t_9:trigger  t_92(BEFORE)  FOR EACH ROW -',systimestamp);
      end;
   

   --AFTER
      --statement(default)
      CREATE OR REPLACE  TRIGGER trig_92_aft
      after insert or update on t_9    
      begin 
      if inserting then
         insert into t_9_msg values('insertion in t_9:trgger t_92(after)-',systimestamp);
      elsif updating then
         insert into t_9_msg values('update in t_9:trgger t_92(after)-',systimestamp);      
      end if;   
      end;
      
      --CAN REFERNECE in aSTMT but get error...wtf!
      CREATE OR REPLACE  TRIGGER trig_92_aft_referencing
      after  update on t_9    
      referencing new as newest
      begin 
         insert into t_9_msg values('update in t_9:trgger t_92(referencing)-'||:newest.a,systimestamp);      
      end;
      
      select * from       t_9_msg ;
      update t_9  set a= 200 where a=10;
      select * from t_9    ;

      --ROW statement
      CREATE OR REPLACE  TRIGGER trig_92_aft_row
      BEFORE insert on t_9    
      for each row --For each row
--      when  ( new.a  > 10)
      begin 
         insert into t_9_msg values('insertion in t_9:trigger  t_92(AFTER)  FOR EACH ROW -',systimestamp);
      end;

   
   --INSTEAD OF  (THERE IS NO for each statement!!!!!!!!!!!!!!!!!)
                -- instead OF IS always for each ROW
         --create or replace view vw_9  as select t1.a,b,c2 from t_9_v1 t1 join t_9_v2 t2 on t1.a=t2.a ;
         select * from vw_9  ;
      --
      CREATE OR REPLACE  TRIGGER trig_92_instead
      instead of  update  on vw_9    
      REFERENCING OLD as my_old
                  NEW as my_new
      begin 
         insert into t_9_msg values('UPDATE in vw_9:trigger trig_92_instead(after)- OLD c2:'
                                    || :my_old.c2||' NEW.c2:'||:my_new.c2 ,systimestamp);
      end;

      --DOESNT WORK for TABLES!!!!Only x View
      CREATE OR REPLACE  TRIGGER trig_92_instead_NOT instead of  update  on t_9  begin     insert into t_9_msg values('DOESNT WORK');    end;


      --ROW statement
      CREATE OR REPLACE  TRIGGER trig_92_instead_row
      instead of  update  on vw_9    
      for each row--for each row
      --when  (old.a >999 )  NOT ALLOWED in INSTEAD of
      begin 
         insert into t_9_msg values('insertion in vw_9:trigger trig_92_instead(after) FOR EACH ROW-',systimestamp);
      end;

      update vw_9 set  c2=11000;
      select * from vw_9;      

      delete from t_9_msg;--triggered
      select * from t_9_msg;--triggered

      -- R e f e r e n c i n g      t e s t
      create or replace trigger t_9_r_ins before insert on t_9
      REFERENCING OLD as my_old
                  NEW as my_new
      for each row
      declare
      text varchar2(255);
      begin 
            --mutating
               --select a into text  from t_9 where rownum < 2; select is fine is no mutauting
               --insert into t_9 values(12345);--[1]: ORA-00036: maximum number of recursive SQL levels (50) exceeded
               --update t_9 set a =10;-- FINE no error, aupdate all except the NEW inserted
                                      -- after     
         insert into t_9_msg values('t_9_r_ins old' || :my_old.a||' NEW.c2:'||:my_new.a ,systimestamp);
--         :my_new.a :=1; --CAN CHANGE N E W (in a before!!! not in an after)
--         :my_old.a :=1;  CANT change OLD!!!!
      end;
      insert into t_9 values('2000' );
      insert into t_9 values('2001' );
      insert into t_9 values('2002' );
      select * from t_9 ;
      select * from t_9_msg ;
               
      -- drop trigger t_9_r_ins ; if create replace on another table get error!!!!!!
      create or replace trigger t_9_r_upd after update on t_9
      REFERENCING OLD as my_old
                  NEW as my_new
      for each row                        
      declare
      text varchar2(255);
      begin 
--select a into text  from t_9 where rownum < 2;-- ***M U T A T I N G***  generate RUNTIME error !!!!!!!
                                                   -- for after and before
         insert into t_9_msg values('t_9_r_upd old' || :my_old.a||' NEW.c2:'||:my_new.a ||'  text var is:'||text ,systimestamp);
      end;
      update t_9  set a = a + 100  where a > 2000;
      update t_9  set a = 0;
      select * from t_9 ;
      select * from t_9_msg ;
      
     
      create or replace trigger t_9_r_del before delete on t_9
      REFERENCING OLD as my_old
                  NEW as my_new
      for each row           
      when  (to_number(my_old.a) >0 ) --WHEN           : cant call  PLsql f or proc in WHEN condition  
      begin 
         dbms_output.put_line(:my_old.a); 
         insert into t_9_msg values('t_9_r_del old' || :my_old.a||' NEW.c2:'||:my_new.a ,systimestamp);
      end;
      
      delete from t_9  
      --where a  > 2100
      ;
      
      select * from t_9 ;
      delete from t_9_msg ;
      select * from t_9_msg ;
           
      
      --  R E S T R I C T I O N

      -- T C L (no COMMIT, ROLLBACK, SAVEPOINT)
      -- error at RUNTIME not compile time
      -- [1]: ORA-04088: error during execution of trigger 'P155121.TRIG_9_RESTRICT'

      CREATE OR REPLACE  TRIGGER trig_9_restrict
      BEFORE insert on t_9_restr    
      begin 
         rollback;
      end;
      
      -- M  U T A T I N G
      -- The table itself
      --     exception: insert, for each row (without subquery)
      --  DELETE: foreign key with DELETE CASCADE       
      --  Views are never mutating!
      
      /*-Mutating table (only FOR EACH ROW) compila but runtime err
          -table affected by the DML
          -Update: after aupdate 
    
         -Insert FOR EACH ROW
         exception: INSERT with sub query
               (note if select AS is always mutating)
          -Delete : FOR EACH STATEMENT 
                    the deleted table T1 and the table with foreign constaint on T1.
               -VIEW are never mutatuig
      */
      
      insert into t_9_restr values(1);


--Ex 9.2 ENABLE  (trig or TABLE level)
alter trigger trig_9_restrict disable;

alter table t_9_restr enable /*disable*/  all triggers ;

--Ex 9.3 NON DML triggers:
--db triggers
if (IS_SERVERERROR(10562)) then
elsif (IS_SERVERERROR(10565)) then
elsif (IS_SERVERERROR(10566)) then

;

--
select * from dba_objects where lower(object_name ) like 'logmnr_ddl_trigger_proc' ;
select * from all_source  where lower(name ) like 'logmnr_ddl_trigger_proc' ;

--Ex 9.4 avoid insert through an exception in trigger
CREATE OR REPLACE  TRIGGER trig_9_4
BEFORE insert on t_94  
declare
my_exception exception ;
begin 
 dbms_output.put_Line('trig_9_4');
 raise no_data_found ;
end;

begin 
insert into t_94   values(2);
exception when others  then  dbms_output.put_Line(SQLERRM ||' / SQLcode'||SQLcode); end;
end;

select * from t_94   ;


--Ex 9.5 CALL
create or replace procedure p_95 as begin dbms_output.put_line('p_95: procedure CALLed'); end; 

CREATE OR REPLACE  TRIGGER trig_9_5
before insert on t_9
begin
dbms_output.put_line('test'); 
--   CALL p_95;it should work but it doesnt....
p_95;
end;


--Ex 9.last
select * from user_triggers; 
select * from dba_triggers; 



