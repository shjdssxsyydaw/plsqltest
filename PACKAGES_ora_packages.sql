--7.0 Install
create table p155121.t_7_sql (a number,b number, c number, d VARCHAR2(255));
insert into t_7_sql  values (1,0,0,'first');
insert into t_7_sql  values (2,0,0,'second');
insert into t_7_sql  values (3,1,0,'third');
--------------------------------------------------------------------------------
--                            D B M S __ O U T P U T 
--------------------------------------------------------------------------------


--Ex 7.1 enable /diisable
   execute dbms_output.enable(buffer_size => NULL); -- default is 20k / NULL means no limit m
   execute DBMS_OUTPUT.DISABLE;

--Ex 7.2 PUT_LINE ( PUT + NEW_LINE ) 
   -- they DONT write to console but to a buffer,the buffer is then flushed to console at end of block execution
   --put_line add '/n' new line
   --put just write to buffer ma non scrive su schermo sino che non chiami new_line 
   --trigger:
   --with before insert if insert fails tha buffer is kept,but next good execution of trigger is released: so it writes 2 msg the OLD & the NEW!

    --put : non scrive till a new_line comes
      select  dbms_output.put_line('o') from dual;--error
      execute dbms_output.put('dont appear'); 
      begin       dbms_output.put('onnniiiii');        end;      /
         begin
            for i in 1..10 loop
               dbms_output.put('just put'); 
               dbms_output.new_line;
            end loop;
         --dbms_output.new_line;
         end;
         /
   --new_line
   begin dbms_output.new_line(); end; /

   --line = put {n} + new_line
    execute dbms_output.put_line('ciao'); 

   --get_line,get_lines : They pullout from the buffer, the row is infact litterally deleted!!!!
   --get_line : fetc one row from buffer, next call fetch previous buffer row
                --status 0 = good read
    --note that row is not written              
    DECLARE  buffer1 VARCHAR2(100);  buffer2 VARCHAR2(100);buffer3 VARCHAR2(100);    status INTEGER; 
    BEGIN
        dbms_output.put_line('ROW 1');
        dbms_output.put_line('ROW 2');       
        dbms_output.put('just put 1');
        dbms_output.put('just put 2');
--                dbms_output.new_line(); if u add this line buffer 3 will be printed
--------------------------------------        
        dbms_output.get_line(buffer1, status);
        dbms_output.get_line(buffer2, status);
        dbms_output.get_line(buffer3, status);

        dbms_output.put_line('Buffer(1): ' || buffer1 ||' / Status: ' || TO_CHAR(status));
        dbms_output.put_line('Buffer(2): ' || buffer2||' / Status: ' || TO_CHAR(status));
        dbms_output.put_line('Buffer(3):'  || buffer3 ||' / Status: ' || TO_CHAR(status));-- note here that the line  "put" are not printd case there is no NEW LINE

    END;     
      /

   -- GET_LINES  : 
   DECLARE
    outtab dbms_output.chararr; --Srray delle linee lette
    fetchln INTEGER := 15; --Number of read rows (from buffer)
   BEGIN
     outtab(1) := 'This is a test';
     outtab(12) := 'of dbms_output.get_lines';
     dbms_output.put_line('A: ' || outtab(1));
     dbms_output.put_line('A: ' || outtab(12));
   
     dbms_output.get_lines(outtab, fetchln);
     dbms_output.put_line(TO_CHAR(fetchln));
   
     FOR i IN 1 .. fetchln /*+1 se leggi oltre no err?*/ LOOP
       dbms_output.put_line('B: ' || outtab(i));
     END LOOP;
   END;
   /

--------------------------------------------------------------------------------
--                            D B M S __  J O B 
--------------------------------------------------------------------------------
-- every60 sec it monitor if there are job scheduled
-- 

select * from v$parameter where name like 'job_queue_processes';--maximum number of job queue slave processes
--value=1000                                                            
select * from v$parameter where lower(name) like 'job_queue_interval';--  How often the scheduler should check for jobs to execute???default setting of 60 seconds is adequate
--nort found  MAX=3600 sec


--Ex 7.3
   --SUBMIT : (series of job)
      DBMS_JOB.SUBMIT( 
         job       OUT    BINARY_INTEGER,-- ID nr assigned to the batch you sheduled
         what      IN     VARCHAR2,      -- THAT'S THE JOB!!!!!  adprv.pck_xxx.my_func();
         NEXT_DATE IN DATE DEFAULTSYSDATE, -- Very 1st time schedule ().
         interval  IN     VARCHAR2 DEFAULT 'NULL',--interval between schedulation of next jobs
                                                  --sysdate + 8/24    
         no_parse  IN     BOOLEAN DEFAULT FALSE,--
         instance  IN     BINARY_INTEGER DEFAULT ANY_INSTANCE,-- Outside exam scope
         force     IN     BOOLEAN DEFAULT FALSE);-- Outside exam scope
   --CHANGE (update attributes): change one jobs attribute
      dbms_job.change(
            job       IN BINARY_INTEGER,
            what      IN VARCHAR2,
            next_date IN DATE,
            interval  IN VARCHAR2,
            instance  IN BINARY_INTEGER DEFAULT NULL,
            force     IN BOOLEAN        DEFAULT FALSE);
   exec dbms_job.change(14144, NULL, NULL, 'SYSDATE + 3');   

   --WHAT  NEXT_DATE INTERVAL
      dbms_job.what(if_job ,'job.descr')  dbms_job.interval(id_job,interval)  dbms_job.next_date
     --update the attirbutes
   --INSTANCE -- Outside exam scope
   --REMOVE
     dbms_job.remove (job IN BINARY_INTEGER);
   --RUN        :Execute once, right here right now!
     dbms_job.run(
      job   IN BINARY_INTEGER,
      force IN BOOLEAN DEFAULT FALSE);
     
     exec dbms_job.run(job_no);
   --others stuff
   --USER_EXPORT
      --      Let you export job info to other DB
      dbms_job.user_export (
         job    IN     BINARY_INTEGER,
         mycall IN OUT VARCHAR2);
      SELECT job FROM user_jobs;
      set serveroutput on
      DECLARE  callstr VARCHAR2(500); BEGIN   dbms_job.user_export(394544, callstr);
      dbms_output.put_line(callstr);
     END;
     /
   --BROKEN
      --If failed to execute job is re scheduled after 1-2-4-8-16 minutes and then is set BROKEN.
      --You can manually set Broken.
   --ISUBMIT   --Internal Oracle use!!!!!

   Select * from dba_jobs;     
      --desc dba_jobs;
      --LOG_USER  who submitted the job
      --PRIV_USER  default batch privileges
      --SCHEMA_USER parse schema
      --LAST_DATE,LAST_SEC        : last sucessfully exec
      --      THIS_DATE/THIS_SEC  : if currently running
      --      NEXT_DATE/NEXT_SEC  : next execution 
      --   Last execution
      --           TOTAL_TIME 
      --            BROKEN     
      --            INTERVAL   
      --            FAILURES   
      --WHAT    :pl/sql block or code to be executed           
      --NLS_ENV            MISC_ENV                              
      --INSTANCE            who can execute if 0 = ALL           


--------------------------------------------------------------------------------
--                            D B M S __  S C H E D U L E R
--------------------------------------------------------------------------------
-- define program
-- define schedules
-- define job
--drop 

SELECT owner, program_name, enabled FROM dba_scheduler_programs;
SELECT * FROM dba_scheduler_programs where owner <> 'SYöS';

   -- Create the test programs.
      BEGIN
        -- PL/SQL Block.
        DBMS_SCHEDULER.create_program (
          program_name   => 'test_plsql_block_prog',
          program_type   => 'PLSQL_BLOCK',
          program_action => 'BEGIN DBMS_STATS.gather_schema_stats(''SCOTT''); END;',
             enabled        => TRUE,
             comments       => 'Program to gather SCOTT''s statistics using a PL/SQL block.');

        -- Shell Script.
        DBMS_SCHEDULER.create_program (
          program_name        => 'test_executable_prog',
          program_type        => 'EXECUTABLE',
          program_action      => '/u01/app/oracle/dba/gather_scott_stats.sh',
       number_of_arguments => 0,
          enabled             => TRUE,
          comments            => 'Program to gather SCOTT''s statistics us a shell script.');
      
           -- Stored Procedure with Arguments.
        DBMS_SCHEDULER.create_program (
          program_name        => 'test_stored_procedure_prog',
       program_type        => 'STORED_PROCEDURE',
             program_action      => 'DBMS_STATS.gather_schema_stats',
       number_of_arguments => 1,
          enabled             => FALSE,
          comments            => 'Program to gather SCOTT''s statistics using a stored procedure.');
      
        DBMS_SCHEDULER.define_program_argument (
       program_name      => 'test_stored_procedure_prog',
          argument_name     => 'ownname',
          argument_position => 1,
          argument_type     => 'VARCHAR2',
          default_value     => 'SCOTT');
         
     DBMS_SCHEDULER.enable (name => 'test_stored_procedure_prog');
      END;
      /

   --D R O P
   DBMS_SCHEDULER.drop_program (program_name => 'test_plsql_block_prog');
   
   
   -- S C H E D U L E S
   -- Create the schedule.
   BEGIN
   -  DBMS_SCHEDULER.create_schedule (
       schedule_name   => 'test_hourly_schedule',
       start_date      => SYSTIMESTAMP,
          repeat_interval => 'freq=hourly; byminute=0',
       end_date        => NULL,
       comments        => 'Repeats hourly, on the hour, for ever.');
   END;
   /
   -- Display the schedule details.
   SELECT owner, schedule_name FROM dba_scheduler_schedules;
   
   --JOBS
   BEGIN
  -- Job defined entirely by the CREATE JOB procedure.
  DBMS_SCHEDULER.create_job (
    job_name        => 'test_full_job_definition',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN DBMS_STATS.gather_schema_stats(''SCOTT''); END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'freq=hourly; byminute=0',
    end_date        => NULL,
    enabled         => TRUE,
    comments        => 'Job defined entirely by the CREATE JOB procedure.');

  -- Job defined by an existing program and schedule.
  DBMS_SCHEDULER.create_job (
    job_name      => 'test_prog_sched_job_definition',
    program_name  => 'test_plsql_block_prog',
    schedule_name => 'test_hourly_schedule',
    enabled       => TRUE,
    comments      => 'Job defined by an existing program and schedule.');

  -- Job defined by existing program and inline schedule.
  DBMS_SCHEDULER.create_job (
    job_name        => 'test_prog_job_definition',
    program_name    => 'test_plsql_block_prog',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'freq=hourly; byminute=0',
    end_date        => NULL,
    enabled         => TRUE,
    comments        => 'Job defined by existing program and inline schedule.');

  -- Job defined by existing schedule and inline program.
  DBMS_SCHEDULER.create_job (
     job_name      => 'test_sched_job_definition',
     schedule_name => 'test_hourly_schedule',
     job_type      => 'PLSQL_BLOCK',
     job_action    => 'BEGIN DBMS_STATS.gather_schema_stats(''SCOTT''); END;',
     enabled       => TRUE,
     comments      => 'Job defined by existing schedule and inline program.');
   END;
   /

   --------------------------------------------------------------------------------
--                            D B M S __  D D L
--------------------------------------------------------------------------------
--Ex 7.4
   --alter_compile (otherwise couldnt in PL)
   declare 
      msg varchar2(100);
   begin
    select to_char(last_ddl_time,'dd.mm.yyyy HH24:MI:SS')    into msg from user_objects where object_name='MY_P32';
    dbms_output.put_line('before '||msg);
    dbms_ddl.alter_compile('PROCEDURE','P155121','MY_P32');
    select to_char(last_ddl_time,'dd.mm.yyyy HH24:MI:SS')    into msg from user_objects where object_name='MY_P32';
    dbms_output.put_line('after '||msg);
   end;
   /
   --analyze_object  : last_analyzed not found...missconfig?
   declare 
      msg varchar2(100);
   begin
    select to_char(last_ddl_time,'dd.mm.yyyy HH24:MI:SS')    into msg from user_objects where object_name='PT1';
    dbms_output.put_line('before '||msg);
    dbms_ddl.analyze_object('TABLE',--table,cluster,index
                  'P155121','PT1',
                  'COMPUTE'); --estimate :nr of rows or %
                              --compute 
                              --delete
    select to_char(last_ddl_time,'dd.mm.yyyy HH24:MI:SS')    into msg from user_objects where object_name='PT1';
    dbms_output.put_line('after '||msg);
   end;
   /
--   select * from user_objects where object_name ='PT1';   --NO  
   select * from all_tab_columns    where column_name like '%ANALYZED%'   ;
   select * from all_tab_columns    where column_name like '%PROCED%'   ;   
--   select * from ALL_PROCEDURES  where object_name ='PTA';
   select * from DBA_TABLES where table_name  ='PT1'; 
   
   --WRAP
   declare s varchar2(88); begin dbms_output.put_line(DBMS_DDL.WRAP('CREATE OR REPLACE FUNCTION get_date_string RETURN number AS  BEGIN RETURN 1; END get_date_string;')); end;
   --create wrapped
   declare s varchar2(88); begin 
      dbms_output.put_line(DBMS_DDL.create_WRAPped('CREATE OR REPLACE FUNCTION get_date_string RETURN number AS  BEGIN RETURN 1; END get_date_string;',
                           lb  => 1,
                           ub  => 1));
   end;
   
--------------------------------------------------------------------------------
--                            D B M S __  P I P E
--------------------------------------------------------------------------------
   --Ex 7.5
   SELECT * FROM v$db_pipes;
   

      --Create the pipe
  --sender
      -- - ->Pack MSG
      --     Send msg
   --receiver
      -- Create LISTENER for the pipe
      -- <-- Reeive msg --Bloccante e legge 1 msg alla volta
      --     UNpack msg


      --REMOVE pipe
      
      
   ---sender
      --Create the pipe
      -- - ->Pack MSG
      --     Send msg
      
      
      -- L I S T E N
      declare 
        status    NUMBER;
        message   VARCHAR2(80);
        pipe_name VARCHAR2(30) := 'MY_PIPE';    
        nt_type number;
        msg2   VARCHAR2(80);
      begin
        -- Create a pipe
--        status := DBMS_PIPE.create_pipe(pipe_name); if already exist get error
        -- Listen for incoming messages on the pipe
        status := DBMS_PIPE.receive_message(pipename => pipe_name,
                                       timeout  => DBMS_PIPE.maxwait);--BLOCCCANTE FINO TIMEOUT
--next_item_pipe  :PRIMA DELL UNPACK                                     
        -- Message received successfully.
        IF status = 0 THEN       

        nt_type:=DBMS_PIPE.next_item_type();
        select decode (nt_type,0 ,'No more items',6 ,'NUMBER',9 ,'VARCHAR2',11, 'ROWID',12 ,'DATE',23 ,'RAW',nt_type )
        into msg2
        from dual;
        DBMS_OUTPUT.put_line('Next Item Type: ' ||msg2  ||'-'||nt_type);        
        DBMS_PIPE.unpack_message(message);
        DBMS_OUTPUT.put_line('Message received: ' || message );
        else 
          DBMS_OUTPUT.put_line('status <> 0');
        END IF;                                       
      end;
      
      
      --  S E N D 
         --SENDER   
      DECLARE   status    NUMBER;   message   VARCHAR2(80) := 'Hello you on the other side '||to_char(sysdate,'dd.mm.yyyy HH24:MI:SS');   pipe_name VARCHAR2(30) := 'MY_PIPE';BEGIN
        DBMS_PIPE.pack_message(message);
        status := DBMS_PIPE.send_message(pipe_name);
      END;
      /




   --sender 
      --REMOVE pipe      
      declare status number; begin  status:=DBMS_PIPE.remove_pipe(pipename => 'MY_PIPE') ; end;
  --next item type
  determines datatype of the next item in the local message buffer.
0 No more items
6 NUMBER
9 VARCHAR2
11 ROWID
12 DATE
23 RAW
    
;

--------------------------------------------------------------------------------
--                            D B M S __  S Q L
--------------------------------------------------------------------------------
--   DML
--       select,insert,update,delete
--
-- unclear with ddl the parse execute the command

   --Ex 7.6        
   declare
    de_cursor number;
    stmt      varchar2(255);
    descr     t_7_sql.d%type;    
    status    number;
    my_var    number;
   begin
       --SELECT
       stmt     := 'select d   from t_7_sql where a='||1;
       -- C U R S O R :open
       de_cursor :=dbms_sql.open_cursor;
       dbms_output.put_line('SEL cursor ID:'||de_cursor);
          -- P A R S E / Define_column / EXECUTE (parse is always runtime)
       dbms_sql.parse(de_cursor,stmt,DBMS_sql.V7);
       dbms_sql.define_column(de_cursor,1,descr,30);              
       status:=dbms_sql.execute(de_cursor);  --status is %ROWCOUNT
       dbms_output.put_line('SEL status Execute:'||status);
         loop
               -- F E T C H / value_column
            exit when dbms_sql.fetch_rows(de_cursor)=0;            
            dbms_sql.column_value(de_cursor,1,descr);
            dbms_output.put_line('descr:'||descr);
         end loop; 
        -- C U R S O R :close
       dbms_sql.close_cursor(de_cursor);
       --INSERT,UPDATE,DELETE
       stmt     := 'update  t_7_sql  set d=''updated descr''where a='||1;
       de_cursor :=dbms_sql.open_cursor;
       dbms_output.put_line('upd-cursor ID:'||de_cursor);
       dbms_sql.parse(de_cursor,stmt,DBMS_sql.V7);
       status:=dbms_sql.execute(de_cursor);
       dbms_output.put_line('upd-status Execute:'||status);
       dbms_sql.close_cursor(de_cursor);

       ---------- W I T H     B I N D   V A R I A B L E
       -- you can bind after the parse
       stmt     := 'select d   from t_7_sql where a=:bindvar';
       de_cursor :=dbms_sql.open_cursor;
       dbms_sql.parse(de_cursor,stmt,DBMS_sql.native);
       dbms_sql.define_column(de_cursor,1,descr,30);              
       --bind
       my_var   :=1;
       dbms_sql.bind_variable(de_cursor,':bindvar',my_var);
       status:=dbms_sql.execute(de_cursor);
         loop
            exit when dbms_sql.fetch_rows(de_cursor)=0;            
            dbms_sql.column_value(de_cursor,1,descr);
            dbms_output.put_line('bind 1 descr:'||descr);
         end loop; 
       dbms_sql.close_cursor(de_cursor);
   end;   
   /

--Ex 7.7 ERRORS COMES AT RUN TIME!!!!is sql is wrong
   CREATE OR REPLACE PROCEDURE P_7_SQL IS
       de_cursor number;
       stmt      varchar2(255);
       descr     t_7_sql.d%type;    
       status    number;
      begin
          stmt     := 'ERROR_ERROR___select d   from t_7_sql where a='||1;
          de_cursor :=dbms_sql.open_cursor;
          dbms_sql.parse(de_cursor,stmt,DBMS_sql.V7);
          dbms_sql.define_column(de_cursor,1,descr,30);              
          status:=dbms_sql.execute(de_cursor);
          dbms_sql.close_cursor(de_cursor);
      end P_7_SQL;   
      /
       

--------------------------------------------------------------------------------
--                            D Y N A M I C  s q l
--------------------------------------------------------------------------------
--SYSREFERENCE CURSOS
--  are pointer  to results set in query work area 

   --Ex 7.8 DNS    (execute immediate using)
   begin 
      EXECUTE IMMEDIATE 'create table p155121.t_7_dyn (a number(1))';
   end;
   select * from p155121.t_7_dyn ;

   declare v_data varchar(255) ; 
   begin 
--      EXECUTE IMMEDIATE 'SELECT d FROM from t_7_sql WHERE a = :text_string' INTO v_data USING '1';
      dbms_output.put_line(v_data);  
   end;--Doesnt work must be a table??
   select * from p155121. ;



-- Delete an existing (or not existing) objects
declare 
ps_table_name varchar2(64) default 'TEST_EXISTS';
begin
   for i in (select NULL from user_objects where object_name = ps_table_name )
   loop
      execute immediate 'drop table '||ps_table_name;
      dbms_output.put_line('dropped table!');
   end loop;
 end;
 /   


--------------------------------------------------------------------------------
--                            NDS vs dbms_sql
--------------------------------------------------------------------------------
-- NDS cant when :
--    nr & data type is unknown till runtime
--    convert long & raw  to varchar/lob
--
--    gluing VS placeholder(bind var) : gluing is subject to injection attack
-- steps NDS steps
--    1 stmt parsed at runtime
--    2 map variable to placeholders
--    3 nds engine parse and run without bind
--    4 read return values : USING or RETURNING INTO

      -- Method 1 static : DDL + DML : only for ins upd del NO SELECT
      --  dbms_sql equivalent function/proc
      --  exec open_cursor parse
      -- here u just concat strings
      -- use dbms_assert!
      
      --ex .drop_if_exists.sql
      --nds
      -execute immediate 'drop table'||my_variable_name;
      --dbms_sql   
      stmt := 'drop table '||  s_owner||'.'||s_object_name ;
      dbms_sql.parse(c,stmt,dbms_sql.NATIVE);
      status:= dbms_sql.execute(c);
      dbms_sql.close_cursor(c);

      -- Method 2 Dynamic with INPUT :  USING (input) / RETURNING INTO (output)
      --  dbms_sql equivalent function/proc
      --  bind_array bind_variable /  
      --                   open_cursor parse
      --bind is IMMUNE  to INJECTION! 
      --nds
      declare
         stmt varchar2(1024);
         de_a number default 1;de_b number default 1;  de_c number default 1; de_d varchar2(64) default 'NDS with bind';     
         s_tab constant varchar2(1024) :='t_7_sql';                       
      begin
--        stmt := 'insert into :my_tab'[1]: ORA-00903: invalid table name cant substitute a table name!!!
         stmt := 'insert into '||'t_7_sql'
                 ||'  values '
                 ||'( :my_a , :my_b,:my_c , :my_d)';     --BIND!!!!
        EXECUTE IMMEDIATE stmt
           USING de_a,de_b,de_c,de_d;
        --ASSERT   

      end;      
      select a.*,rowid from       t_7_sql  a;

      --dbms_sql
      declare
         stmt   varchar2(1024);
         de_a   number default 1;de_b number default 1;  de_c number default 1; de_d varchar2(64) default 'NDS with bind Method 2';                           
         c      integer := dbms_sql.open_cursor;  
         status integer;
      begin
        stmt := 'insert into '|| dbms_assert.simple_sql_name( 't_7_sql' ) ||'  values '||'( :my_a , :my_b,:my_c , :my_d)';     
        --parse                 
        dbms_sql.parse(c,stmt,dbms_sql.NATIVE);
        -- bind
        dbms_sql.bind_variable(c,'my_a',de_a);--if not all binded:[1]: ORA-01008: not all variables bound
        dbms_sql.bind_variable(c,'my_b',de_b);
        dbms_sql.bind_variable(c,'my_c',de_c);
        dbms_sql.bind_variable(c,'my_d',de_d);                
        status:= dbms_sql.execute(c);
        dbms_sql.close_cursor(c);
        dbms_output.put_line('Inserted: status='||status);
      end;      
      select a.*,rowid from       t_7_sql  a;

       --seee example 7.6
                loop
               -- F E T C H / value_column
            exit when dbms_sql.fetch_rows(de_cursor)=0;            
            dbms_sql.column_value(de_cursor,1,descr);--here we go!!!!!!!!!!!!!
            dbms_output.put_line('descr:'||descr);
           end loop; 
           
           
           
      -- Method 3 Dynamic with IN/OUT  :  USING (input) / RETURNING INTO (output)
      --  dbms_sql equivalent function/proc
      --  bind_array bind_variable /  
      --    column_value/define value
      --       excute execute_and_fetch
      --           fetch rows
      --                   open_cursor parse
      -- Select  
      --    Single   row:  INTO 
      --    Multiple row:  BULK COLLECT INTO     
      -- note sys_refcursor
    
     --nds
     
     --dbms_sql
     
        -- single fetch
         declare
            my_cursor sys_refcursor;
            stmt varchar2(1024);
            de_a number default 1;
            de_b number default 1;         
            de_c number default 1;         
            de_d varchar2(64) default 'NDS with bind';                           
         begin
           stmt := 'select d from t_7_sql   where '
                    ||'a = :my_a or b = :my_b';     --BIND!!!!
           dbms_output.put_line('stmt:'||stmt);         
           open my_cursor for stmt USING de_a,de_b        ;
           loop
              fetch my_cursor  into de_d;
               exit when my_cursor%notfound;
               dbms_output.put_line(de_d);         
            end loop;
           close my_cursor;        
         end;
      
         -- BULK fetch
         declare
            my_cursor sys_refcursor;
            stmt varchar2(1024);
            de_a number default 1;
            de_b number default 1;         
            de_c number default 1;         
            de_d varchar2(64) default 'NDS with bind';                                    
            
            type d_record  is record (d varchar2(1024));
            type d_collection is table of d_record ;
            d_all d_collection;
         begin
           stmt := 'select d from t_7_sql   where '
                 ||'a = :my_a or b = :my_b';     --BIND!!!!
        dbms_output.put_line('stmt:'||stmt);         
          open my_cursor for stmt USING de_a,de_b        ;
           loop 
            --BULK collect fetch
            fetch my_cursor bulk collect into d_all;
             for i in 1..d_all.count loop
               dbms_output.put_line(d_all.i);         
              end loop;
             close my_cursor;        
         end;      
      select a.*,rowid from       t_7_sql  a;
      
      --REading output
      --single   row:todo
      --multiple row



      -- Method 4 Dynamic with IN/OUT  :  USING (input) / RETURNING INTO (output) +
      --                                  + UNKNOWN param List!!!!
      --  dbms_sql equivalent function/proc
      --  bind_array bind_variable /  
      --    column_value/define value
      --       DESCRIBE_COLUMNS,DESCRIBE_COLUMNS2,DESCRIBE_COLUMNS3
      --       excute execute_and_fetch
      --           fetch rows
      --                   open_cursor parse
      --                      VARIABLE_VALUE
      u still neeed to prepare  with dbms_sql and  then convert in sysref cirsor NDS

--------------------------------------------------------------------------------
--                            D B M S _ A S S E R T
--------------------------------------------------------------------------------
http://oracle-base.com/articles/10g/dbms_assert_10gR2.php#SIMPLE_SQL_NAME
http://www.dba-oracle.com/t_dbms_assert.htm         
used in databases that don’t employ bind variables to help prevent SQL injection attacks, by “sanitizing" the SQL.  See here for details on SQL injection attacks


BEGIN 
   dbms_output.put_line(dbms_assert.simple_sql_name( '1t_7_sql' )); --OK
   dbms_output.put_line(dbms_assert.simple_sql_name( '1t_7_sql' )); --Nok    
end;
BEGIN
dbms_output.put_line(dbms_assert.enquote_name('"SERVERS"'));--ok
dbms_output.put_line(dbms_assert.enquote_name('SERVERS"')); -- Nok
end;
BEGIN
dbms_output.put_line(dbms_assert.enquote_literal('  _ SERVERS  - '));--ok
end;

--------------------------------------------------------------------------------
--                            U T L _ F I L E
--------------------------------------------------------------------------------
   --Ex 7.9 
   select * from all_directories;
   -- WRITE a File  --FOPEN PUT_LINE
   --create or replace procedure utl_file_test_write (
   declare
     path        varchar2(255) default '/appl/entw/public/out'; --Have to exists a ora_directory
     filename    varchar2(255) default 'test_file';
     firstline   varchar2(255) default 'test txt';
     file_handler  utl_file.file_type;
   begin
       file_handler := utl_file.fopen (path,filename, 'W');
       utl_file.put_line (file_handler, firstline);
       utl_file.fclose(file_handler);
   end;/
   
   
   -- READ a File --GET_LINE
   --create or replace procedure utl_file_test_read (
   declare   
     path        varchar2(255) default '/appl/entw/public/out'; --Have to exists a ora_directory
     filename    varchar2(255) default 'test_file';
     input_file   utl_file.file_type;  
     input_buffer varchar2(4000);
   begin
     input_file := utl_file.fopen (path,filename, 'R');
     utl_file.get_line (input_file, input_buffer);
     dbms_output.put_line(input_buffer);
     utl_file.fclose(input_file);  
   end;
   /

   --MODES
   r -- read text
   w -- write text
   a -- append text
   rb -- read byte mode
   wb -- write byte mode
   ab -- append byte mode
   
   
   --REMOVE
   --UTL_FILE.FREMOVE (
   
   --Various
   IS_OPEN 
   NEW_LINE
   
   
   https://www.leaveyourmark.info/site/signup
            
--------------------------------------------------------------------------------
--                            A L E R T 
--------------------------------------------------------------------------------
--begins with a client process registering interest in an alert. 
--Once it registers for an alert, 
   dbms_alert.register('TESTEVENT');
--it waits for that specific alert (waitone) or any other alert (waitany) to occur. 
    dbms_alert.waitone(name    => 'TESTEVENT',message => :msg,status  => :status ); --or WAITANY
--Once the alert occurs, the client is notified and a string is passed containing whatever the signal process selected to send to the client (Figure 5.1). 
 dbms_alert.signal(name    => 'TESTEVENT',message => 'This is a message / Dies ist eine Nachricht' );
 http://www.dba-oracle.com/t_dbms_alert.htm
   ;


--------------------------------------------------------------------------------
--                            L O C K 
--------------------------------------------------------------------------------
ALLOCATE_UNIQUE  Allocates a unique lock ID to a named lock.
CONVERT  Converts a lock from one mode to another.
RELEASE Releases a lock.
REQUEST Requests a lock of a specific mode.
SLEEP Procedure Puts a procedure to sleep for a specific time.   
http://www.adp-gmbh.ch/ora/plsql/sync_sessions.html

--session 1   : LOCK exclusive 
 dbms_lock.allocate_unique('control_lock', v_lockhandle);
  v_result := dbms_lock.request(v_lockhandle, dbms_lock.x_mode);

   -- same procedure: they access LOCK in SHARED mode
      --session 2     A N D!!!   session 3
      dbms_lock.allocate_unique('control_lock', v_lockhandle);
      v_result := dbms_lock.request(v_lockhandle, dbms_lock.ss_mode);
      dbms_output.put_line('bla bla');
    -- ... here the just wait....    
 
 --session 1 RElease the lock....
  v_result := dbms_lock.release(v_lockhandle);
     
      --session 2 &  3  : now het the lock and can print
      bla bla
    

--------------------------------------------------------------------------------
--                            D B M S __  S E S S I O N 
--------------------------------------------------------------------------------
context var for pkg
FREE_UNUSED_USER_MEMORY 
http://eval.veritas.com/mktginfo/products/White_Papers/Application_Performance/DBMS_Session_Application_Packages_WP_5-May-04.pdf

access and change session level settings in SQL.
can be made using DBMS_SESSION are:
Enabling and disabling roles
Setting National Language Support (NLS) characteristics
Resetting package states and releasing session package memory
Setting Trusted Oracle label characteristic


DBMS_SESSION.SET_ROLE Procedure Enable or disable roles for thesession
DBMS_SESSION.SET_SQL_TRACE ProcedureTurn session SQL tracing on or off
DBMS_SESSION.SET_NLS Procedure Set National Language Supportcharacteristics for the session
DBMS_SESSION.CLOSE_DATABASE_LINK Procedure Close an inactive but open database link
DBMS_SESSION.SET_LABEL Procedure Set Trusted Oracle label 
DBMS_SESSION.SET_MLS_LABEL_FORMAT Procedure Set Trusted Oracle MLS label format
DBMS_SESSION.RESET_PACKAGE Procedure Clear all persistent package state
DBMS_SESSION.UNIQUE_SESSION_ID Function Returns a unique character string for the session
DBMS_SESSION.IS_ROLE_ENABLED Function Returns TRUE if role enabled 
DBMS_SESSION.SET_CLOSE_CACHED_OPEN_CURSORS Procedure Turns automatic closing of cached cursors on or off

--------------------------------------------------------------------------------
--                            D B M S __  APPLICATION_INFO
--------------------------------------------------------------------------------
 allow applications to "register" their currentexecution status with the ORACLE database. Once registered, information about thestatus of an application canbe externally monitored through several of the V$ virtual
tables. The package can be used to develop applicationsthat can track and monitor: 

--------------------------------------------------------------------------------
--                            H T P
--------------------------------------------------------------------------------
htp.
The htp (hypertext procedures) and htf (hypertext functions) packages generate HTML tags. For instance, the htp.anchor procedure generates the HTML anchor tag, <A>. The following commands generate a simple HTML document:

create or replace procedure hello AS
BEGIN
    htp.htmlopen;           -- generates <HTML>
    htp.headopen;           -- generates <HEAD>
    htp.title('Hello');     -- generates <TITLE>Hello</TITLE>
    htp.headclose;          -- generates </HEAD>
    htp.bodyopen;           -- generates <BODY>
    htp.header(1, 'Hello'); -- generates <H1>Hello</H1>
    htp.bodyclose;          -- generates </BODY>
    htp.htmlclose;          -- generates </HTML>
END;

select    htp.htmlOpen from dual;
http://psoug.org/reference/htp.html
--owa_util.

--------------------------------------------------------------------------------
--                            H T P
--------------------------------------------------------------------------------

BEGIN
  EXECUTE IMMEDIATE 'ALTER SESSION SET smtp_out_server = ''127.0.0.1''';
  UTL_MAIL.send(sender => 'me@address.com',
            recipients => 'you@address.com',
               subject => 'Test Mail',
               message => 'Hello World',
             mime_type => 'text; charset=us-ascii');
END;
/

SEND Procedure  Packages an email message into the appropriate format, locates SMTP information, and delivers the message to the SMTP server for forwarding to the recipients
SEND_ATTACH_RAW Procedure Represents the SEND Procedure overloaded for RAW attachments
SEND_ATTACH_VARCHAR2 Procedure Represents the SEND Procedure overloaded for VARCHAR2 attachments
