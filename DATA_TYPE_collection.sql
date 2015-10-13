-- 3 Collection
--https://docs.oracle.com/cd/B10501_01/appdev.920/a96624/05_colls.htm#19834
      select * from user_types;
      select * from user_coll_types;
      
      select * from user_nested_tables;
      select * from user_nested_table_cols;

      select * from user_varrays;

--Refer attribute:
[Collection][index].[attribute]
--EXISTS
--COUNT
--LIMIT --null fot nt aa
--FIRST LAST 
--PRIOR NEXT
--EXTEND  / TRIM : NT VA   non estend e' un appensd e in varraay sbraga se superi max
--DELETE : delete   delete(n)  delete(n,m)
            --in varr casnt  delete(n)  but can delete and trim
--EXCEPTION 
   collection_is_null
   no_data_found
   subscript_beyond_count
   subscript_outside_limit --idx not legal val
   value_error

--can select  list of empid directyly in a NT
   

--install
--------------------------------------------------------------------------------
--                Associative array 
--   is not created as type

--------------------------------------------------------------------------------
--                Nested table
--   created as type
--   as column is stored OUT OF LINE
--CREATE
   create or replace type  n_nested_type is table of number   --scalar,ref BUT NOT  boolean,long, long_raw,natural,positive,ref_cursor
   --not null
   ;

--ALTER
   --alter type n_nested_type  modify element type (mod el type) [cascade |invalidate]

--DROP
   drop type n_nested_type ; --FORCE is optional
   drop type n_nested_type force;

-- create as column
   create table t_3_nested_table (a number, n n_nested_type)
   nested table n store as nested_num_id;
--------------------------------------------------------------------------------
--                VARRAY
--BOUNDED persistent
-- STORED INLINE  (if varray > 4k will be stored outofline)
-- more Performant tha Nested table because no access to I/O
   create or replace type v_varray_type is VARRAY (3) of number;-- VARRAY|VARYING ARRAY

   --ALTER
   alter type v_varray_type MODIFY LIMIT 4 CASCADE;--INVALIDATE | CASCADE
   
   --DROP
   drop type v_varray_type FORCE; ---force is optional

   --create COLUMN
   create table  t_3_varray (a number, n v_varray_type);
   
   
--------------------------------------------------------------------------------


   
--------------------------------------------------------------------------------
--Associative array
declare
   type asso_array_type is table of number  --THATS value -- number (subtype),varchar(subtype), date, boolean, blob , clob
                                                          -- inferred type
                                                          -- UDT
   --not null
   index by varchar2(10)  --key   --available number,char,varchar2       rowid,raw,long_raw,binary_integer,plus_integer,positive,natural,signtype
   ;
   
   asso_array asso_array_type ;
   asso_array_null asso_array_type ;
--   asso_array_empty asso_array_type := asso_array_type() ;
   s_key      varchar2(10);
   
begin
--   asso_array_empty :=  asso_array_type();  empty
   asso_array('austin'):= 100;
   asso_array('toronto'):= 2;
   asso_array('boston'):= 22;   
   asso_array('chicago'):= 999;   
   asso_array('zurich'):= 32;      

   --overwrite
   asso_array('austin'):= 12;
   
   --LOOP with FIRS NEXT
   s_key := asso_array.first;
   dbms_output.Put_line('Associative array: First KEY '|| s_key);
   while (s_key is not null)
   loop
      dbms_output.put_line(' Current KEY :'||s_key ||' current VALUE:'|| asso_array(s_key));
      s_key := asso_array.next(s_key);
      dbms_output.Put_line(' Next KEY:'||s_key);
   end loop;

   --reference not existing key
   begin
      dbms_output.Put_line('reference not existing key '||asso_array('dummy'));-- no_data_found
   exception 
      when no_data_found then
         dbms_output.Put_line('reference not existing key'||sqlerrm||'/'||SQLCODE);
   end;   
   --reference not initialized
   dbms_output.Put_line(asso_array_null('dummy'));      
   
   --Refer attribute:
   --[Collection][index].[attribute]
--   dbms_output.Put_line(asso_array[0].'austin');
   
dbms_output.Put_line('Associative array');
exception 
   when no_data_found then
      dbms_output.Put_line(sqlerrm||'/'||SQLCODE);
   when others then
      dbms_output.Put_line(sqlerrm||'/'||SQLCODE);
end;
/

  --METHODS
      declare 
         type asso_array_type is table of number  index by varchar2(10);
          asso_array asso_array_type ;
      begin
     asso_array('austin'):= 100;
     asso_array('toronto'):= 2;

      --exists
       if asso_array.exists('gino') then
          dbms_output.Put_line('exists: '|| asso_array('gino'));
       else  
          dbms_output.Put_line('NOT exists: gino');
       end if;      
      --count
          dbms_output.Put_line('count: '|| asso_array.count());
      --limit  NULL!!!!
         -- dbms_output.Put_line('limit: '|| asso_array.limit);
      --first last : order by value
          dbms_output.Put_line('first: '|| asso_array.first()||'/last: '|| asso_array.last());
   

    exception
     when others then
        dbms_output.Put_line(sqlerrm||'/'||SQLCODE);
     end;
--------------------------------------------------------------------------------
--Nested table
   --Types stored in DB
      select * from user_types;
      select * from user_coll_types;
   --Columns stored in DB
      select * from user_nested_tables;
      select * from user_nested_table_cols;
      

--DML
   truncate table t_3_nested_table;
   --INSERT
   insert into t_3_nested_table (a, n ) values(1,n_nested_type(3,66,0,11));--instance object and iitialize
   insert into t_3_nested_table (a, n ) values(2,n_nested_type(110,120,140,180));--instance object and iitialize
   insert into t_3_nested_table  (a, n ) values(3,n_nested_type(180));--instance object and iitialize
   --UPDATE
   update t_3_nested_table set  n = n_nested_type(5,6,7,8/*,8 so get upd err*/) where a = 1 ;--instance object and iitialize
      --updatesingle element in the nested list
      -- NOTE must return 1 single row  & update 1 & 1 element in the nested table 
      --                               otherwise
      --[1]: ORA-01427: single-row subquery returns more than one row
   update TABLE (select n from t_3_nested_table where a = 1 ) T1  
      set   T1.Column_value  = 9000 
      where T1.Column_value  = 8  ;


   --SELECT
   select * from t_3_nested_table ;
   select 
      a,n2.*
   from 
      t_3_nested_table n1,
      table (n1.n) n2      
       ; --reference an object

--PLSQL
declare
   type nested_type is table of number;
   n_nested_var nested_type ;
   nested_type_empty nested_type := nested_type() ;   
BEGIN
   n_nested_var :=nested_type(4,66,73);
   --delete
   n_nested_var.delete(1); --Del VALUE = 4 !!!!!!!!!! not index 4
   for i in 1..n_nested_var.count()
   loop
      if n_nested_var.exists(i) then
      dbms_output.Put_line('Nested(i):'||n_nested_var(i));
      end if;
   end loop;
end;
/

  --METHODS
      declare 
          type nested_type is table of number;
          n_nested_var nested_type ;
      begin
          n_nested_var :=nested_type(4,66,73);
         --exists
          for i in 1..10 loop
             if n_nested_var.exists(i) then
                dbms_output.Put_line('exists: '|| n_nested_var(i));
             else  
                dbms_output.Put_line('NOT exists: i='||i);             
             end if; 
          end loop;
      --count
          dbms_output.Put_line('count: '|| n_nested_var.count());
      --limit  NULL!!!!
          dbms_output.Put_line('limit: '|| n_nested_var.limit());
      --extend  trim
          n_nested_var.extend(50);--addd 50 element
          dbms_output.Put_line('count after extend 50: '|| n_nested_var.count());
          n_nested_var.extend;--addd 1 element
          dbms_output.Put_line('count after extend null: '|| n_nested_var.count());
          n_nested_var.extend(10,31);--addd x elem with val y element
          dbms_output.Put_line('count after extend x,y 10,31: '|| n_nested_var.count());

          n_nested_var.trim(43);--rem 433 element
          dbms_output.Put_line('count after trim: '|| n_nested_var.count());

      exception 
         when others then
            dbms_output.Put_line(sqlerrm||'/'||SQLCODE);
  end;
  
  
  
  select emp_id from employee into nested_tableofnr;---useful
  
  
      
--------------------------------------------------------------------------------
--    VARRAY
select * from user_varrays;
select * from user_types;
select * from user_coll_types;
 --DML
    create table  t_3_varray (a number, n v_varray_type);

   --INSERT
   insert into t_3_varray  (a, n ) values(3,v_varray_type(180));--instance object and iitialize
   insert into t_3_varray  (a, n ) values(3,v_varray_type(31,32,33));--instance object and iitialize

   --UPDATE
   update t_3_varray set  n = v_varray_type(5,6,7/*,8 so get upd err*/) where a = 3 ;--instance object and iitialize
      --single element cannot be updated




   --SELECT
   select * from t_3_varray ;
   select 
      a,n2.*
   from 
      t_3_varray n1,
      table (n1.n) n2      
       ;
   
   --PLSQL
   declare
      type v_varray_type is VARRAY (3) of number;-- VARRAY|VARYING ARRAY
      v_v_arr v_varray_type ;
   begin
      v_v_arr := v_varray_type(11,12,13);
      --v_v_arr := v_varray_type(11,12,13,14);--sbraga [1]: ORA-06532: Subscript outside of limit
      for i in 1..v_v_arr.count()
      loop
         dbms_output.Put_line('VARRAY(i):'||v_v_arr(i));
      end loop;
   end;
   /


   --METHODS
   declare
      type v_varray_type is VARRAY (3) of number;
      v_v_arr v_varray_type ;
   begin
      v_v_arr := v_varray_type(11,12,13);
      --EXISTS
      for i in 1..10
      loop
         if v_v_arr.exists(i) then
            dbms_output.Put_line('VARRAY(i):'||v_v_arr(i));         
         else
            dbms_output.Put_line('VARRAY(i) doesnt exists');                  
         end if;
      end loop;
      
      --count
          dbms_output.Put_line('count: '|| v_v_arr.count());
      --limit
          dbms_output.Put_line('limit: '|| v_v_arr.limit());
      --first last : order by value
          dbms_output.Put_line('first: '|| v_v_arr.first||'/last: '|| v_v_arr.last);
      --prior next : order by value
          dbms_output.Put_line('prior: '|| v_v_arr.prior(2)||'/next: '|| v_v_arr.next(0));
      --extend  trim
--          v_v_arr.extend;--addd 50 element sbraga non estend e' un appensd e in varraay sbraga se superi max
--          dbms_output.Put_line('count after extend: '|| v_v_arr.count());
          v_v_arr.trim();--rem 433 element
          dbms_output.Put_line('count after trim: '|| v_v_arr.count()||' limit:'|| v_v_arr.limit());

   end;
   /
   
   
   
   
   
   -----------------------------------------------------------------------------
   https://docs.oracle.com/cd/B10501_01/appdev.920/a96624/10_objs.htm
   
   
   Manipulating Individual Collection Elements with SQL
Multilevel VARRAY Example
Example of Multilevel Collections and Bulk SQL
How Do Bulk Binds Improve Performance?
Using the FORALL Statement
Counting Rows Affected by FORALL Iterations with the %BULK_ROWCOUNT Attribute
