--Ex 8.0 install 
create table t_8 (a number, b blob);
create table t_8_lob_c (a number, b clob);
create table t_8_lob_b (a number, b blob);
create table t_8_lob_bc  (a number, b clob,c clob);
select * from t_8 ;
select a,nvl(dbms_lob.getlength(b ) ,0)  lengthfrom t_8 ;

/*Constants  : DBMS_LOB defines the following constants:
   file_readonly CONSTANT BINARY_INTEGER := 0;
   lob_readonly  CONSTANT BINARY_INTEGER := 0;
   lob_readwrite CONSTANT BINARY_INTEGER := 1;
   lobmaxsize    CONSTANT INTEGER        := 18446744073709551615;
   call          CONSTANT PLS_INTEGER    := 12;
   session       CONSTANT PLS_INTEGER    := 10;
*/

--select nvl(dbms_lob.get_storage_limit(b) ,1) a from t_8; non funzia zio catorcio
--select * from v$parameter where name like 'max%'; max_string_size niot found
   select *  from  v$parameter WHERE UPPER (NAME) = 'DB_BLOCK_SIZE';--8k
/*
E X C E P T I ON
   INVALID_ARGVAL 21560  The argument is expecting a nonNULL, valid value but the argument value passed in is NULL, invalid, or out of range.
   ACCESS_ERROR  22925  You are trying to write too much data to the LOB: LOB size is limited to 4 gigabytes.
   NOEXIST_DIRECTORY  22285    The directory leading to the file does not exist.
   NOPRIV_DIRECTORY   22286   The user does not have the necessary access privileges on the directory or the file for the operation.
   INVALID_DIRECTORY 22287 The directory used for the current operation is not valid if being accessed for the first time, or if it has been modified by the DBA since the last access
   OPERATION_FAILED 22288 The operation attempted on the file failed
   UNOPENED_FILE 22289 The file is not open for the required operation to be performed.
   OPEN_TOOMANY 22290 The number of open files has reached the maximum limit.
   NO_DATA_FOUND EndofLob indicator for looping read operations. This is not a hard error.
   VALUE_ERROR   6502 PL/SQL error for invalid values to subprogram's parameters.
*/

--------------------------------------------------------------------------------
-- LOB: B C NC                                                                --
--------------------------------------------------------------------------------
--insert into t_8 (a) values (200);

--Ex 8.1 ASSIGN

--ASSIGN:
   -- CLOB NCLOB
      -- CANT initialize with a string bigger than 32 K (need empty_blob)
      --to insert more than 32k clob u need a writeappend
      declare
         var_c_1  clob ;
         var_c_2  clob := EMPTY_CLOB();
         var_c_3  clob := 'test clob';
      begin   
      -- NULL,EMPTY or populated: getlength
         dbms_output.put_line(   'var_c_1:'|| nvl(to_char(dbms_lob.getlength(var_c_1 )),'null' )  
                               ||'/var_c_2(empty):'|| nvl(dbms_lob.getlength( var_c_2),0)   
                               ||' var_c_3(assigned):'|| nvl(dbms_lob.getlength(var_c_3 ) ,0)     
                               ) ;
      end;
      /
      
      --SQL : cant select into
         --insert into values (char < 32k OR empty_clob OR func?)            
      --can only insert up to 32k !!!
      declare
         fc  clob := EMPTY_CLOB();
         text varchar2(32000) ;
      begin   
            text  := lpad(text,32000,'-' );
            insert into t_8_lob_c values(1,text);
            insert into t_8_lob_c values(2,empty_clob());            
      end;
      /
         select * from    t_8_lob_c ;
      --loadfromfile loadclobfromfile
      -- clob nclo < 32K
     
     --INSERT 
     declare
        fc  clob;
     begin   
       insert into  t_8_lob_c (a,b) values (10,empty_clob())
           RETURNING b into fc  ;
     end;
     --UPDATE
     declare
        fc  clob;
     begin   
       update t_8_lob_c set b= empty_clob() where a=10
           RETURNING b into fc  ;
     end;
      
   -- BLOB
      declare
         var_b_1    blob :=  EMPTY_BLOB();         
      begin  
            insert into t_8_lob_b values(1,'42'||'41'||'52'); --HEXADCIMAL ASSIGNEMENT!!!!
            insert into t_8_lob_b values(2,empty_blob());            
            --RAW insert raw is possible
            --loadblobfromfile
      end;
      /
     select * from t_8_lob_b ;


      --INSERT
      --UPDATE
      -- see clob      


--READ  from file    (here NO 32K limit in size )
      --C NC LOB
      --similar to blob
      
      
      --B LOB   
      --Ex 8.
      declare
         var_b_1    blob :=  EMPTY_BLOB();
         my_bfile   bfile:=  bfilename('PUBLIC_OUT','test.jpg');   
         src_offset number :=1;
         dst_offset number :=1;
         des_clob  blob :=  EMPTY_BLOB();  
         stmt varchar2(1024);    
      begin  
          --Exists 
          if dbms_lob.fileexists(my_bfile) = 1 then
             dbms_output.put_line('my_bfile file_exists');
            --Is open
            if dbms_lob.fileisopen(my_bfile) = 1  then
               dbms_output.put_line('file my_bfile is open');
            else
               dbms_output.put_line('open file my_bfile');
               dbms_lob.open(my_bfile,dbms_lob.lob_readonly);
           end if;
          --Write 
          dbms_output.put_line('var_b_1 length(before):'|| nvl(dbms_lob.getlength(var_b_1 ),0 )) ;
           --insert empty
          insert into t_8  (a,b) values(1,var_b_1);  
          --update blob
          stmt:='update t_8 set b=empty_blob() where a=1 returning b into :locator';
          execute immediate stmt using out  des_clob;
          
          --READ the file
          DBMS_LOB.LOADBLOBFROMFILE (
                     des_clob , --nocopy
                     my_bfile,--src_bfile   IN            BFILE, 
                     DBMS_LOB.LOBMAXSIZE,--nvl(dbms_lob.getlength(my_bfile ),0 ),-- amount      IN            INTEGER, 
                     dst_offset , --1 IN OUT        INTEGER, 
                     src_offset  -- 1 IN OUT        INTEGER
                    );
          dbms_output.put_line('var_b_1 length (after):'|| nvl(dbms_lob.getlength(var_b_1 ),0 )) ;                 
          dbms_lob.close(my_bfile);
         end if;
      end;
      /
   
delete from t_8_clob;

select a,
   nvl(dbms_lob.getlength(b ),0 ) len_b,b,
   nvl(dbms_lob.getlength(c ),0 ) len_c,c
from t_8;

-- write
   declare
      var_c_1    clob ;
      var_c_2    clob ;
      v_buffer   VARCHAR2(100) default 'ciao!';
      id number  := 3;
   begin  

       insert into t_8_clob  (a,b,c) values(id,empty_clob(),empty_clob());  
       update t_8_clob set b = empty_clob() where a = id    returning b into var_c_1 ;
       DBMS_LOB.WRITE (var_c_1,1,1,v_buffer);
       dbms_output.put_line('var_c_1 length (1):'|| nvl(dbms_lob.getlength(var_c_1 ),0 )) ;                 
       DBMS_LOB.WRITE (var_c_1,1,1,v_buffer);
       dbms_output.put_line('var_c_1 length (2):'|| nvl(dbms_lob.getlength(var_c_1 ),0 )) ;                 
       for i in 1..100 loop
         DBMS_LOB.WRITEappend (var_c_1,1,v_buffer);
       end loop;  
       DBMS_LOB.WRITEappend (var_c_1,1,'pippo');
       for i in 1..100 loop
         DBMS_LOB.WRITEappend (var_c_1,1,v_buffer);
       end loop;  
-- I N S T R                          
     dbms_output.put_line('instr:'||
                  DBMS_LOB.INSTR (var_c_1,'pippo',1,1));     
       dbms_output.put_line('var_c_1 length (3):'|| nvl(dbms_lob.getlength(var_c_1 ),0 )) ;                 
--APPEND a LOB to another LOB
--     update t_8_clob set b = empty_clob() where a = id    returning c into var_c_2 ;
     SELECT b     INTO var_c_1    FROM t_8_clob   WHERE id=3;
     SELECT c     INTO var_c_2    FROM t_8_clob   WHERE id=3;             
     DBMS_LOB.append (var_c_2,var_c_1);
     DBMS_LOB.TRIM (var_c_2,20);
     dbms_output.put_line('b length (after append):'|| nvl(dbms_lob.getlength(var_c_1 ),0 ) ||
                          '/ c length (after append & trim):'|| nvl(dbms_lob.getlength(var_c_2 ),0 ) 
                                                    
     ) ;                 
--  C O M P A R E     0=OK
dbms_output.put_line( 'compare:'||DBMS_LOB.COMPARE (var_c_1,var_c_2,100,1,1));
dbms_output.put_line( 'compare(eq):'||DBMS_LOB.COMPARE (var_c_1,var_c_1,10,1,1));
   end;
   /

--CONVERSION
    converttoblob (c,nc lob ? blob);
    converttoclob (blob ? c,nc lob );      
--COPY
--trim      --cut the file afte n bytes
--erase  -This procedure erases a part (chunk) or all of an internal LOB.
--fragment insert delete move replace 
--getchunksize

--------------------------------------------------------------------------------
--     B   F  I L E         :read only                                        --
--------------------------------------------------------------------------------
-- use them to locate a file and maybe load it into a lob

--insert from BFILE

select * from all_directories;



--------------------------------------------------------------------------------
--     T E M P O R A R Y                                                      --
--------------------------------------------------------------------------------

-- temporary tablespace stores the temporary LOB data.

--V$TEMPORARY_LOBS
   select *--sid,"SERIAL#",username
   from 
   v$session s ,V$TEMPORARY_LOBS t
   where s.sid=t.sid;

DECLARE 
  a blob; 
  b blob; 
BEGIN 
  dbms_lob.createtemporary(b, TRUE); 
    dbms_output.put_line( 'get_storage_limit'||DBMS_LOB.get_storage_limit(a));
  -- the following assignment results in a deep copy 
  a := b; 
  --free temp
 DBMS_LOB.FREETEMPORARY (b);   
END; 

--istemporary
--freetemporary

