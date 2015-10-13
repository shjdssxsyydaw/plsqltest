
1
----------------------------------------------------------------------------------------------------
Forma Normale:
1NF :each cell in a table must contain only one values  and
         cant  be duplicate rows.
2NF:1NF + unique primary key
        ogni colonna che non e’ primary key , dipende dall’intera chiave:
        {Student,subject},age NON E’  2NF    perche age dipende soloda student e non da all PK
3NF:2NF + column related to the key nothing else
      all the attributes in a table are dependent only on the PK
      {Student,subject},city,street,zip is NOT 3NF because city depend from zip
       2 tables {Student,subject},zip  / {zip},city,street  IS 3NF

SQL is 4gl and its the only lang to interact withrdbms


2
----------------------------------------------------------------------------------------------------
SCHEMA collection of db objects owned by a user
NON Schema objects:public syn,user,roles
--name max LEN = 30
--1st char must be a letter, after special char allowed : _ #  $
-- name convention:  with "" can give lower case name and ' ' blank in the name
--   without "" it always turn in upper case

CREATE objType objName attrib
   create table "p155121.piPpo" ( a number); OK:select * from "p155121.piPpo"; Nok: select * from p155121.piPpo; select * from PIPPO;
   --Name space boundaries:in same schema cannot have same name a : table,view,privatesynonym,user def type ,BUT can allrest  
   create table  test (a number not null  ,b number,c number default 88,primary key (b)  );


DATA TYPE
   NULL = unknown ,  emp= NULL is always False ? use is null
   --LONG is deprecated!!!

   data type
      char(n) fixed length! pad with blank
      varchar2(n) dynamic length max 4k
      number(n,m) in n - -> N-M se metti + N ERROR                     1-38
                  in m  - -> m : se metti + M truncate                 -82,127
                  N < M  - -> e-notation  cioe 0.m cifre (4,5) 0.12345, (10,-2) round to hundred
       nchar,nvarchar contains the UNICODE           
       date       :                          yyyy mm dd HH MI SS
       timestamp(1-9)  :                     date + millisecond
       timestamp(1-9)  with time zone :       timestamp  +  (  TZR (es. cest) OR TZO (es. +04) )
       timestamp(1-9)  with local time zone : timestamp  +  UTC  (or dbtime is unclear)(at run time will ADD your session time zone)--data stored in the database is normalized to the database time zone, and the time zone offset is not stored as part of the column data.
       interval year to month  +000000001-02
       interval day to second  +000000000 10:20:30.000000000
       ;
      create table p155121.t_date (a date,b timestamp,c timestamp with time zone,d timestamp with local time zone, e interval year to month ,f interval day to second);
      insert into t_date values (sysdate,sysdate,sysdate,sysdate,TO_YMINTERVAL('01-02'), TO_DSINTERVAL('2 10:20:30.456' ));    
      insert into t_date values (SYSTIMESTAMP,SYSTIMESTAMP,SYSTIMESTAMP,SYSTIMESTAMP,TO_YMINTERVAL('03-04'),TO_DSINTERVAL('2 10:20:30.456'));    
      select * from t_date ;    
      SELECT value FROM   nls_session_parameters WHERE  parameter = 'NLS_DATE_FORMAT';

       blob binary
       clob char
       nclob clob UNICODE;
       create table t_lob ( b blob, c clob, n nclob,id number) ;    select * from t_lob;
    
CONSTRAINTS
   cont type P,U,C,R
   foreign key have to reference a unique key
   ma meglio alter table perche quando reinstalli db se tabella non ancora certa so cazzi
   --u can foreign key on same table reports_to example
   CHECK
   PK to more fields is a composite key
;



   CONSTRAINTS: PKEY,NOTNULL(only inline),UNIQUE,CHECK --Y cant CREATE stmt constraint,but ALTER table drp/add constraint
    if dont provide explicit name default is like : SYSC00091
    3 way to create it:;
     create table p155121.pippo (a  number primary key);   IN-line
     create table p155121.pippo2 (a  number constraint my_constraint_test primary key);
     create table p155121.pippo3 ( a  number );
     alter table p155121.pippo3 modify a  primary key ;
     create table p155121.pippo4 ( a  number , primary key (a) );OUT-line
     create table p155121.t_2_pippo5 ( a  number , constraint testa primary key (a) );
     select * from all_constraints where owner like 'P155121' and table_name like '%PIPP%';--P primary key
     
3
----------------------------------------------------------------------------------------------------
DDL /DML/TCL
DDL flashback :restore previous version of obj
        purge flash bin
DML merge
      insert control ordeR: tablename,column,values datatype(constraint is Runtime err not syntax)
          nell insert prova una convesione: ”101” come number va bene o ´01012011´
         is the “implicit data conversion”
COMMIT: IMPLICIT COMMIT : DDL ALWAYS PERFORM A COMMIT SO:
                 delete where id=29
                 alter index;
                 rollback;
                 id=29 is gone!!!!!!
ROLLBACK TO SP_1
SAVEPOINT: if duplicate name dont get error ;(  new override old
                       sp are actually alias for SCN
                        commit delete all existing  savepoint,if RB sp_1 -->err


    create table p155121.commit_impl (a number);
   insert into commit_impl values(1);
   insert into commit_impl values(2);
   savepoint sp_1;
   insert into commit_impl values(3);
   savepoint sp_2;
   insert into commit_impl values(4);
   rollback to sp_1;
   insert into commit_impl values(5);
   commit;
   select * from commit_impl;
   rollback to sp_1;-->ERR



4
----------------------------------------------------------------------------------------------------
ROWNUM
   rownum okkio ke e assegnato pria dell order by;
   select rownum,rowid,o.orga_person orga from ap_ad_organe  o order by orga desc;
     
   like % dont select null
   delete EMPLOYEE ,funzia, FROM is optional
   AND is evaluetad BEFORE or!!!!Not,and,or -->rephrase with () to understand
   x=y or x=t and f=t ?   (x=y(  x=t and f=t))
   BETWEEN ?  >= And <= inclusive
   ORDER BY order by default is asc
   you can order by ship ASC,cost DESC
   alias can bu used inorder by but not in having e group by….boh!!!
   NULL is by default greater , but you can specify NULLS FIRST oppure NULLS LAST;
   select * from employee
   where dept=11 or last_name='smith' or last_name='mine'  and dept = 11;
   
   select a from (select null as a from dual union select 1 as a  from dual) order by a NULLS LAST;
   select {'high-voltage'}from dual;
          

   
   
   SESSION PARAM select name,description ,value from v$parameter order by name;
   SELECT agez_bez from ap_ad_agenturzst  where agez_bez like '\_OFL-Team B';
   ESCAPE  char % ;
      select * from (select '_%_aa' a  from dual union select '''pippo''' a from dual)
      where a like '%/%%' ESCAPE '/' ;
       select * from all_tables where table_name like 'PROVISIONS/_I%' escape '/';
   
6;

----------------------------------------------------------------------------------------------------
--conversione
select--number
to_number('1,233,000.765','9,999,999.999') ,to_number('$111','$999') dollar ,to_number('      123.45','B999.99') blank ,to_number('1.2','9D9')   dot
,to_number('1-','999MI') minus_ ,to_number('1F','XXXX') hexadecimal
from dual;
select--NUMBER
to_char(1234567.89,'$999') ,-- it returns  #####
to_char(1234567.89,'$99999999.99')--
,to_char(1234567.89,'B99999999.99') one_space
,to_char(1234567.89,'C99999999.99')USDval,to_char(1234.89,'L99999')local_curr
,to_char(1234.89,'9G999')group_fmt--
,to_char(1234.89,'9G999D99')group_decimal_fmt--
,to_char(-1234.89,'999999MI')minus_fmt,to_char(1234,'XXXXXXX')hexa
,to_char(-1234.89,'S999999')sign_pre,to_char(1234.89,'999999S')sign_post
from dual;--DATE to char
select to_char(sysdate,'"today is :" DAY  dd.mm.yyyy')
      ,to_char(sysdate,'AD AM CC D DD DDD DL')
      ,to_char(sysdate,'DY FX "Julian" J')
      ,to_char(sysdate,'IW  W WW')  week     
      ,to_char(sysdate,'RR RRRR') year_
     ,to_char(systimestamp,'"Thort:" TS " dayligtsav:" TZD " Tzonr:" TZH')  --ONLY TimeStamp
     ,to_char(systimestamp,'"tzminute:" TZM " regioninfo:" TZR " Tzonr:" TZH')  --ONLY TimeStamp     
from dual;
select --timestamp
 to_timestamp('10-SEP-0214:10:10.123000','DD-MON-RRHH24:MI:SS.FF') to_tmestamp from dual;
select --dsinterval yminterval
  to_dsinterval('03 11:10:10.123000') to_DS_inteerval ,
  to_yminterval('03-11') to_YM_inteerval from dual;


   --cast : in AS out
   --EXTRACT FM ftom e
    select cast(sysdate as timestamp),
            extract(DAY  from sysdate) --available FM : YEAR MONT....SECOND time_tone_regio time_zone_abbr
    from dual
    ;   

-- data in different in time zone  (call center example)
     --UTC : universal
     --DBTIMEZONE (select dbtimezone from dual)
     --sessiontimezone     (select sessiontimezone from dual)
     select  dbtimezone ,sessiontimezone , --out maybe tmz (region) or tzo (offset)
             CURRENT_TIMESTAMP,--is a TS  timezone derived from  sessiontimezone
             current_date--curr date within  sessiontimezone
             ,localtimestamp--no TZ
             ,systimestamp --with TZ
     from dual;
    
     TIMESTAMP WITH TIME ZONE
     TIMESTAMP WITH LOCAL TIME ZONE
     tmz
       time zone region name : CEST  CET LMT  CDT;
      select * from v$timezone_names;--- 1name many abbrev
       advantage is that region is daylight saving indipendent, offset no!
     tzo
        time zone offset 'TZH:TZM' -05:00
        it doesnt reflect dlsaving changes
        daylight STANDARD vs daylight SAVING ;


      select new_time(sysdate,'AST','PST'), --THE HELL takes as input only limited number of TZ ,return DATE
      from dual;
--TIMEZONE conversion
      select FROM_TZ(TIMESTAMP '2014-09-12 01:50:42', '5:00') fromTZ-- TS --> to TS with timeZone   f(ts,tzh:tzm))
             ,FROM_TZ(localTIMESTAMP , '7:00')   from_tz_   
            ,TO_TIMESTAMP_TZ('1999-12-0111:00:00-08:00','YYYY-MM-DDHH:MI:SSTZH:TZM')    --CHAR --> TS with TZ
          ,cast('01-JAN-2014 11:00:00' as TIMESTAMP WITH LOCAL TIME ZONE) cast_to_withLocal_TZ --to TS with LOCAL tz u need a CAST
      from dual;


     --at time zone <timezone>
      --at local : to LOCAL SESSION:...allora e' inutile...
      select TO_TIMESTAMP('01.02.2014 16','dd.mm.yyyy HH24') at TIME ZONE DBTIMEZONE  as dbtime,
             TO_TIMESTAMP('01.02.2014 16','dd.mm.yyyy HH24') at TIME ZONE SESSIONTIMEZONE  as sesstime  ,    
             TO_TIMESTAMP('01.02.2014 16','dd.mm.yyyy HH24') at TIME ZONE '+05:00',
             TO_TIMESTAMP('01.02.2014 16','dd.mm.yyyy HH24') at TIME ZONE 'America/New_York'             
       from dual;     
      select TO_TIMESTAMP('01.02.2014 16','dd.mm.yyyy HH24') at local     from dual;            
         

-- S T R I N G
--INITCAP
select initcap('joHNAtan MCDonald''s antani')from dual;
--LENGTH  L R TRIM
select length('joHNAtan MCDonald''s antani'),
       rpad('fiLIPpo',10,'_')   ,lpad('fiLIPpo',10,'_')  ,
       rtrim('11 fiLIPpo 11622331','123'),ltrim('1a12fiL1IPpo1','1a'), --puoi mettere list of char to be trimmed!!!!
       trim( LEADING '1' FROM '111fiLIPpo') --leading trailing both nota il FROM
       ,sysdate ,trim(leading from sysdate ),
       instr('antani calibrato pantani pantomima', 'an',1,3),instr('antani calibrato pantani pantomima', 'an',-2,1)--string,search,start,occurence_nt , - minus conta dalla fine
       ,nvl(null,1),nvl2(100,1,2) from dual;
from dual;
--REPLACE SOUNDEX http://en.wikipedia.org/wiki/Soundex firstletter+alg suresto consonanti
select replace('joHNAtan MCDonald''s antani','o','0'),soundex('filippo') from dual;
--DECODE senza il default se non trova torna NULL - p1 = null then return default
select  decode(txt,'my note','test' ,' ','empty','NF') from (select null as txt from dual) ;
-- A S C I I http://www.techonthenet.com/ascii/chart.php
   begin for  i in 0 .. 255 loop  dbms_output.put_line(i ||'-'||chr(i) ); end loop;  end;/
   select ascii('L'),
          asciistr('a_non_ascii_char_Ä_toUTF16'),
          ascii('A'),chr(65)  --ascii --> code , code--> ascii
    from dual;

select CONVERT('Ä Ê Í Õ Ø A B C D E ', 'US7ASCII', 'WE8ISO8859P1') ,
       CONVERT('Ä Ê Í Õ Ø A B C D E ', 'US7ASCII', 'WE8MSWIN1252')

from dual;
select * from v$NLS_PARAMETERS;
--http://en.wikipedia.org/wiki/ISO/IEC_8859-1 is it the WE8ISO8859P1??? 255 char

--N U M B E R
--ROUND TRUNC - NUMBERS
select round(111.12395,3),trunc(101.123459,5),round(12345.6789,-1),trunc(12345.6789,-2)
from dual;
select user from dual;
--REMINDER MOD
select remainder(67, 21 )  resto ,67/21, mod(67,21),
           bin_to_num(1,0,0,1),
            ceil(1.2),floor(1.2),
            coalesce(null,1) ret_1st_notnullexpr ,
            exp(1)--  e(2.7) alla n
            ,greatest(1,2,3,4,5,100,6,7,8,null)

 from dual;

select * from nls_session_parameters where parameter in ('NLS_NUMERIC_CHARACTERS','NLS_CURRENCY','NLS_ISO_CURRENCY');-- '.,' DG decimal group
--D A T E
--DATE NEXT_DAY LAST_DAY ADD_MONTH MONTHS_BETWEEN NUM_TO_MYINTERVAL  NUM_TO_DSINTERVAL to_yminterval
select TRUNC(sysdate, 'YEAR') ,TRUNC(sysdate,'Q') ,  
       round(sysdate, 'YEAR')
      ,next_day(sysdate,'FRIDAY'),--week day
      last_day(sysdate),round(MONTHS_BETWEEN(sysdate,sysdate + 30)) mont_between,
      numtoyminterval(12,'month'),to_yminterval('+01-00') --YEAR TO MONTH
      ,extract( month from sysdate  -365)
from dual ;
--to_char to_date to_number

--new_time,from_tz,to_timestamp_tz -'at timezone' 'at local'
select * from v$timezone_names
--where tzname like '%urop%'
;



--DUMP returns a VARCHAR2 value containing the data type code, length in bytes, and internal representation of expr.
--http://ellebaek.wordpress.com/2011/02/25/oracle-type-code-mappings/
select dump(1),dump('a'),dump('abc'),dump(sysdate),dump(LOCALTIMESTAMP),dump(CURRENT_TIMESTAMP),dump(1.1) from dual;
select id,rowid from employee where
rowid=chartorowid('ABxxpUAD/AAAAFkAAA');--devi fa er conversion

select dump(rowid) from dual;
SELECT NLS_LOWER('NOKTASINDA', 'NLS_SORT = XTurkish') "Lowercase"
FROM DUAL;

-- AGGREGATE
--median
select median(a) from (select 1 a from dual union select 2   a from dual union select 5   a from dual union select 2100   a from dual  );
functions from sql reference



7
----------------------------------------------------------------------------------------------------
count(*) return ALL ;count(a) NON CONTA I NULL OCIO!!!;
all grouping functions ignores null except count(*) , grouping and grouping_id

--doppio COUNT
select count( count(agez_histozustand))--,pck_ap_ad_agenturen.if_get_agen_agentur(agez_agen_instanz) 
from  ap_ad_agenturzst 
group by pck_ap_ad_agenturen.if_get_agen_agentur(agez_agen_instanz) 
;


--GROUP BY
--1 LEVEL
group C1,Cn
select C1,C,aggr(C1),aggr(C_all)
order by  stuff in select clause
--2 LEVEL

--KEEP  (first or last )can be used with  min max sum avg count 


--rank
select --0.7 3000
--prsl_jahrespraemie_chf,
min(prsl_jahrespraemie_chf) min_,max(prsl_jahrespraemie_chf) max_,median(prsl_jahrespraemie_chf) median_,trunc(avg(prsl_jahrespraemie_chf) ,4)avg_,sum(prsl_jahrespraemie_chf),count(*),
rank( 20000 ) within group (order by  prsl_jahrespraemie_chf)
from provisions_sollstellungen
where rownum < 10000
;
--First (lowest!!!!) Last (highest!!!!) aggregate_func KEEP (dense_rank firs orde by E1)
select max(prsl_anrechnungspraemie_chf)  KEEP (dense_rank last order by prsl_jahrespraemie_chf)
from provisions_sollstellungen
where rownum < 10000;
--the same but performance degrade....
select max(prsl_anrechnungspraemie_chf)   from provisions_sollstellungen
where rownum  < 10000
and prsl_jahrespraemie_chf in(
select min(prsl_jahrespraemie_chf)
from provisions_sollstellungen 
where rownum  < 10000
)
;


select 
   count(prsl_instanzierung),trunc(prsl_instanzierung),
   rownum,prsl_provisionsart,
   pck_ap_provisionsarten.if_get_prar_bez( pck_ap_provisionsarten.if_get_prar_instanz(prsl_provisionsart),1) prar_bez
from 
   provisions_sollstellungen 
where rownum  < 10000
group by trunc(prsl_instanzierung ),prsl_provisionsart
order by 2,3 asc
;







--NESTING
--u can nest MAX 2 level!!!!!!

select
prfr_orga_person ,
min(prfr_betrag_chf) min_,max(prfr_betrag_chf) max_,median(prfr_betrag_chf) median_,
trunc(avg(prfr_betrag_chf) ,4) - median(prfr_betrag_chf) avg_min_med ,
trunc(avg(prfr_betrag_chf) ,4)avg_,sum(prfr_betrag_chf),count(*),
rank( 20000 ) within group (order by  prfr_betrag_chf desc) rank_
--,prfr_jahrespraemie_chf,prfr_pro_rata_praemie_chf,prfr_provisionsart,prfr_ansatz,prfr_betrag_chf,prfr_adlp_instanz
from 
   provisions_freigaben
where    prfr_valuta > sysdate -120 -- prfr_instanz > 12994990371 
and rownum < 20000
group by prfr_orga_person 
order by prfr_orga_person 
;

-- 2  N   E  S   T
select trunc(avg(max(prfr_betrag_chf) ),2),min(prfr_orga_person)
from     provisions_freigaben where    prfr_valuta > sysdate -120 and rownum < 20000
group by prfr_orga_person 
;

select max(prfr_betrag_chf) ,prfr_orga_person
from     provisions_freigaben where    prfr_valuta > sysdate -120 and rownum < 20000
group by prfr_orga_person 
order by  max(prfr_betrag_chf) desc
;


-- grouping retur 0|1
-- distinguish superaggregate from normal : superaggregate are the result of rollup and cube
-- 
select * from ;

select 
agez_bez,pck_ap_ad_organe.if_get_orga_person(prfr_orga_instanz) orga,
count(*) all_freigaben,trunc(avg(prfr_betrag),1)
,grouping(pck_ap_ad_organe.if_get_orga_person(prfr_orga_instanz))
,grouping(agez_bez)
 from ap_ad_agenturzst,provisions_freigaben
where   ROWNUM < 10000
and agez_histozustand=2 
and prfr_agen_instanz=agez_agen_instanz
group  by rollup (agez_bez,pck_ap_ad_organe.if_get_orga_person(prfr_orga_instanz))
order by agez_bez,pck_ap_ad_organe.if_get_orga_person(prfr_orga_instanz)
;








8;
----------------------------------------------------------------------------------------------------
-- INNER vs OUTER (outer: left:left is alway there ,right right always there )
-- EQUI  vs NON-equi
--cross inner

-- INNER 
-- match all
select    * from     provisions_sollstellungen,provisions_interface
where prsl_valuta = to_date('01.05.2014','dd.mm.yyyy')    and rownum < 100000
 and prsl_prif_instanz=prif_instanz;  --SYNTAX 1

select    * from     
provisions_sollstellungen JOIN provisions_interface on prsl_prif_instanz = prif_instanz --SYNTAX 2
--provisions_sollstellungen INNER JOIN provisions_interface on prsl_prif_instanz = prif_instanz --SYNTAX 3
where prsl_valuta = to_date('01.05.2014','dd.mm.yyyy')    and rownum < 100000;

--same query inverted result 
--OUTER  LEFT
select    prsl_instanz ,prfr_instanz from    provisions_sollstellungen LEFT OUTER JOIN  provisions_freigaben on prfr_instanz=prsl_prfr_instanz where prsl_prif_instanz =16907840991;--2 rows
select    prsl_instanz ,prfr_instanz from   provisions_freigaben LEFT OUTER JOIN  provisions_sollstellungen  on prfr_instanz=prsl_prfr_instanz where prsl_prif_instanz =16907840991;--null
--OUTER  RIGHT
select    prsl_instanz ,prfr_instanz from   provisions_sollstellungen RIGHT OUTER JOIN  provisions_freigaben on prfr_instanz=prsl_prfr_instanz where prsl_prif_instanz =16907840991;--null
select    prsl_instanz ,prfr_instanz from   provisions_freigaben RIGHT OUTER JOIN  provisions_sollstellungen  on prfr_instanz=prsl_prfr_instanz where prsl_prif_instanz =16907840991;--2rows
--OUTER  FULL
select    prsl_instanz ,prfr_instanz from   provisions_sollstellungen FULL OUTER JOIN  provisions_freigaben on prfr_instanz=prsl_prfr_instanz where prsl_prif_instanz =16907840991;--2rows
select    prsl_instanz ,prfr_instanz from   provisions_freigaben FULL OUTER JOIN  provisions_sollstellungen  on prfr_instanz=prsl_prfr_instanz where prsl_prif_instanz =16907840991;--2rows
--NATURAL JOIN
select * from 
( select 1 c1 ,1 c20,1  c30 from dual   union select 2 c1 ,2 c20,2  c30 from dual  union select 3 c1 ,3 c20,3  c30 from dual  ) t1 
NATURAL JOIN  
(select 1 c1 ,'b' c2 ,'b' c3 from dual   union  select 2 c1 ,'c' c2 ,'c' c3 from dual  union select 3 c1 ,'d' c2 ,'d' c3 from dual ) t2    ;
--USING
select * from ( select 1 c1 ,1 c20,1  c30 from dual union select 2 c1 ,2 c20,2  c30 from dual union select 3 c1 ,3 c20,3  c30 from dual union select 4 c1 ,4 c20,4  c30 from dual  ) t1 
LEFT JOIN
(select 1 c1 ,'b' c2 ,'b' c3 from dual  union  select 2 c1 ,'c' c2 ,'c' c3 from dual  union select 3 c1 ,'d' c2 ,'d' c3 from dual ) t2    
 USING( c1)
 ;
--CROSS JOIN
select * from 
( select 1 c1 ,1 c20,1  c30 from dual union select 2 c1 ,2 c20,2  c30 from dual union select 3 c1 ,3 c20,3  c30 from dual union select 4 c1 ,4 c20,4  c30 from dual  ) t1 ,
(select 1 c1 ,'b' c2 ,'b' c3 from dual  union  select 2 c1 ,'c' c2 ,'c' c3 from dual  union select 3 c1 ,'d' c2 ,'d' c3 from dual ) t2     ;
--NON EQUI JOIN
between;
--SELF JOIN false case....
select 
pck_ap_ad_agenturen.if_get_agen_agentur(agen.agez_agen_instanz) agentur,nvl(pck_ap_ad_agenturen.if_get_agen_agentur(ueb.agez_agen_instanz),100000000)ueb_agentur,agen.agez_bez agen_bez,ueb.agez_bez ueb_bez,agen.agez_agenturtyp a_typ,ueb.agez_agenturtyp ueb_typ
from ap_ad_agenturzst agen    join  ap_ad_agenturzst ueb on   nvl(agen.agez_agen_instanz_ueb,agen.agez_agen_instanz ) = ueb.agez_agen_instanz 
where 2=agen.agez_histozustand and ueb.agez_histozustand=2 order by 4;
--1 Generalagentur    2 Hauptagentur         3 Organisationseinheit
select *from ap_ad_agenturzst where agez_histozustand=2 order by agez_agenturtyp;
--....1 table
select 
   nvl(pck_ap_ad_agenturen.if_get_agen_agentur(child.agez_agen_instanz_ueb) ,pck_ap_ad_agenturen.if_get_agen_agentur(child.agez_agen_instanz)  )p2,
   pck_ap_ad_agenturen.if_get_agen_agentur(child.agez_agen_instanz) child,
   agez_agen_instanz_ueb,agez_bez
from ap_ad_agenturzst  child  
where child.agez_histozustand=2    
order by 1
;
--u can foreign key on same table reports_to example

select * from domaenen_base where domb_name like '%AGENTUR%' ;


--;9
----------------------------------------------------------------------------------------------------
-- single row sub query 
select agez_bez  from ap_ad_agenturzst where 2=agez_histozustand   
   and pck_ap_ad_agenturen.if_get_agen_agentur(agez_agen_instanz_ueb) = 
   (select   pck_ap_ad_agenturen.if_get_agen_agentur(agez_agen_instanz)from  ap_ad_agenturzst 
    where   agez_bez ='Aarau' and agez_histozustand=2)
    ---IF u get more than 1 row --> [1]: ORA-01427: single-row subquery returns more than one row
    -- to avoid errorr can use an aggregate function (min,max)  or rownum < 2
    --          oppure operatori in not any all some any 
    ;
--note "^="   equivale  "!="  "<>"

-- IN NOT (ANY/SOME ) ALL  
--    ALL   preceeded by =, !=, >, <, <=, >= 
select agez_bez  from ap_ad_agenturzst where 2=agez_histozustand   
   and pck_ap_ad_agenturen.if_get_agen_agentur(agez_agen_instanz_ueb) in
   (select   pck_ap_ad_agenturen.if_get_agen_agentur(agez_agen_instanz)from  ap_ad_agenturzst 
    where   agez_bez ='Aarau' and agez_histozustand=2);

select  orga_person from ap_ad_organe
where   orga_person  > ALL  (select  max(orga_person)-10 from ap_ad_organe);

--    "x = ALL (...)": The value must match all the values in the list to evaluate to TRUE.
--    "x != ALL (...)": The value must not match any values in the list to evaluate to TRUE.
--    "x > ALL (...)": The value must be greater than the biggest value in the list to evaluate to TRUE.
--    "x < ALL (...)": The value must be smaller than the smallest value in the list to evaluate to TRUE.
--    "x >= ALL (...)": The value must be greater than or equal to the biggest value in the list to evaluate to TRUE.
--    "x <= ALL (...)": The value must be smaller than or equal to the smallest value in the list to evaluate to TRUE.

--SOME / ANY   =, !=, >, <, <=, >= 

--    "x = ANY (...)": The value must match one or more values in the list to evaluate to TRUE.
--    "x != ANY (...)": The value must not match one or more values in the list to evaluate to TRUE.
--    "x > ANY (...)": The value must be greater than the smallest value in the list to evaluate to TRUE.
--    "x < ANY (...)": The value must be smaller than the biggest value in the list to evaluate to TRUE.
--    "x >= ANY (...)": The value must be greater than or equal to the smallest value in the list to evaluate to TRUE.
--    "x <= ANY (...)": The value must be smaller than or equal to the biggest value in the list to evaluate to TRUE.


9 subquery
---------------------------------------------------------------------------------------------------------------------------
single row (= != < >), multi row (ANY ALL IN NOT),multi column,scalar , correletated (EXIST);




10 Views Sequences Indexes Synonym Object Privileges
---------------------------------------------------------------------------------------------------------------------------
--VIEW
create or replace view vw_emp as
select  name,lastname,dept_descr,salary
from emp047  natural join  dept047
 can update,insert,delete se le info disponibili lo permettono
note:can insert stuff that you ll not see later*!!!(ex where cost > 100, ma puoi inserire cost=2….)
create or replace view vw_emp_5 as select * from emp047 where salary > 5000
insert into   vw_emp_5 values ( seq_create_emp.nextval ,'dino','crodino',2,3000)
select *  from emp047;

--INLINE VIEW   (  select * from (select bla bla) )
--helps with rownum problem: u order by rwnum outside the inline view
compile
alter view  vw_emp compile;
cant ALTER on the select , only create or rreplace



--SEQUENCE
start with, increment by, nocycle, cycle (then can use minvaliue,maxvalue )
create sequence seq_create_emp start with 10 maxvalue 1000 nocycle

--cant call currval se nella session non hai chaimato nextval
select seq_create_emp.nextval from dual;
select seq_create_emp.currval from dual;
se no truschino;
 select last_number from DBA_SEQUENCES where sequence_name ='INSTANZ_ID' ; 
--lot of limitations about where you can use it






--INDEX
-- when drop table the index os also deleteed...but when recreate tab idx is not recreated
-- automatic on primary key or unique  creation
--LIKE use index only if  ‘SMITH%’ wildcard is not at the beginnning;


   --SINGLE column

    --Composite
    create index idx_f1_f2 on EMPLOYEE (f1,f2) 
    

--UNIQUE
    create UNIQUE index idx_f1 on EMPLOYEE (f1) ;

--PRIVATE & PUBLIC SYNONYM (theres no PRIVATE keyword achtung)
-- for public add puiblic kw otherwise is private.
-- dont need to alreay exist to create synonym
-- dont neeed privilege to create synonym on obj (but when you ll select yes)

create  or replace synonym stillnotexist for fanta_table--private
frop synonym  stillnotexist for fanta_table
--there is no alter 
u can create synonym with same name public & private,but private has namespace priority


--OBJECT PRIVILEGES
--add column
alter table emp (agap number);-- not null non funzia se ci sono altre rows, ma DEFAULT works

11 Managing Objects Schema
-------------------------------------------------------------------------------  
create table p155121.test_11 (a number );
-- Column :ADD & Modify --> alter table
   --   order :datatype, DEFAULT, Constraints
   --       2 sintassi 
          DROP COLUMN
             DROP (<collumn list>) 
   
   --    A D D column
      alter table  p155121.test_11 ADD (b number );
   --    options : default,not null
      alter table  p155121.test_11 ADD (c number default 10);
      alter table  p155121.test_11 ADD (f number not null);--fail if rows already in the table!!! Default solve the problem
         insert into   p155121.test_11 values (0,0,0,0);          
         alter table  p155121.test_11 ADD (d number not null ); 
         ORA-01758: table must be empty to add mandatory (NOT NULL) column   ;
         alter table p155121.test_11 ADD ( d number DEFAULT 100  NOT NULL);--...not null sempre in fondo...
         --IT WORKS
      -- MULTIPLE COLUMN
      alter table  p155121.test_11 ADD (e number ,g number ); 
   --    M O D I F Y column
      -- it does NOT rename column!!!

      --       NOT NULL & reverse NOT NULL
      alter table p155121.test_11 modify a not null;
      alter table p155121.test_11 modify a  null;
   
      --       POPULATED COLUMNS
      --WHEN you CANT modify columns:
         -Data types conversion:some values already in : NO AUTOMATIC DATATYPE CONVERSION
         -Precision & scale: when prec & scale are lost
         -NOT NULL: there are some null : nota diverso da ADD
         -uniique:values not unique
         -foreign key:fk  violated
         -check:check violated
   --    "R E N A M E  C OL U M N" must use both...
      alter table p155121.test_11 RENAME COLUMN a to h;
   --     DROP COLUMN
      alter table p155121.test_11 DROP (f,g,h);
      alter table p155121.test_11 DROP (e) CASCADE CONSTRAINTS;--CASCADE CONSTRAINTS
   --     U N U S E D
   -- cant be recovered,can create another col with same name,stay in col count but cant recover which name
   --
      alter table p155121.test_11 SET UNUSED COLUMN d;
      select * from user_tables where table_name ='TEST_11'; 
      
-- C O N S T R A I N T S   A D D           
--dont create, but alter table add constraints ,can be DEFERRABLE
   -- Primary key : 3 syntax
      create table p155121.test_11_2 (c number,d number ,e number);
      create table p155121.test_11_3 (c number,d number ,e number);
      --INline
      ALTER table p155121.test_11 MODIFY B primary key;
      ALTER table p155121.test_11_2 MODIFY C CONSTRAINT pk_test11 PRIMARY KEY;
      --OUTline (when pk multipe cols)
      ALTER table p155121.test_11_3
       ADD CONSTRAINT pk_new  PRIMARY KEY (c,d);
   -- NOT NULL : 
      --INline
      ALTER table p155121.test_11_3 MODIFY C NOT NULL;
      ALTER table p155121.test_11_3 MODIFY C CONSTRAINT pk_test11 NOT NULL;
      --OUTline (when pk multipe cols)
      ALTER table p155121.test_11_3
       ADD CONSTRAINT nn_test  NOT NULL(c,d);
   
   -- CHECK : 
      --OUTline (when pk multipe cols)
      ALTER table p155121.test_11_3
       ADD CONSTRAINT fk_test   CHECK (C < 100);
   -- FOREIGN KEY : 
      --OUTline (when pk multipe cols)
      ALTER table p155121.test_11_3
       ADD CONSTRAINT fk_test   FOREIGN KEY (C) REFERENCES tab1 ON (col_c);-- ON DELETE CASCADE


-- C O N S T R A I N T S   M O D I F Y 
-- is limited...use DROP & CREATE instread

-- C O N S T R A I N T S   D R O P
   --PRIMARY KEY 
      ALTER table p155121.test_11 DROP PRIMARY KEY; -- CASCADE | KEEP INDEX |
   --UNIQUE 
      ALTER table p155121.test_11 DROP UNIQUE C; -- CASCADE | KEEP INDEX |
   --NOT NULL
      ALTER table p155121.test_11_3 MODIFY   C NULL ; -- CASCADE | KEEP INDEX |


-- C O N S T R A I N T S   E N A B L E / D I S A B L E
   ALTER TABLE p155121.test_11_3  DISABLE CONSTRAINT fk_tab;
   --Primary Key
   ALTER TABLE p155121.test_11_3   DISABLE PRIMARY KEY;

   --VALIDATE / NOVALIDATE
   ALTER TABLE p155121.test_11_3   ENABLE NOVALIDATE ck_100; ---non applica alle regole esistenti
   ALTER TABLE p155121.test_11_3   DISABLE VALIDATE ck_100; ---rare use  x exchange partition   
   
   --DEFERRABLE / DEFERED
   -- use during transaction when reactivate , there is a Rollback id integrity check fail.
   ALTER TABLE ships ADD CONSTRAINTS fk_1 FOREIGN KEY (a1) REFERENCES tab2 ON c1
   DEFERRABLE;
   
   --DEfer REactivate
   SET CONSTRAINT  fk_1  DEFERRED;--   SET ALL CONSTRAINT  DEFERRED;
   SET CONSTRAINT  fk_1  IMMEDIATE;--   SET ALL CONSTRAINT  IMMEDIATE;
   --RENAME
   ALTER TABLE ship RENAME CONSTRAINT fk_1 TO fk_2;
   
   
-- INDEX   
   create table p155121.t10 (
   a number
      PRIMARY KEY 
         USING INDEX 
            (create index IX_Test ON p155121.t10(a))         
   ,
   b number
   );
   
   
-- R E C Y C L E   B I N
-- if restored dependent obj arerestored  with some limitations
select * from user_recyclebin;
select * from recyclebin;
select sum(space  )*8192 ,max(space )*8192 from dba_recyclebin;--7 213 154 304 space in BLOCK 
select * from v$parameter;
SELECT * FROM   v$parameter2;--SESSION PARAMETER???
select * from  dictionary where table_name like '%SESS%';
alter session set recyclebin on;
-- P U R G E :can be flashedback
purge table p155121.test_purge;



select * from  p155121.test_11 ;


cascade constraints:alter table drop c1  cascade constraints

alter table emp047 set unused agap_code
cant retrieve names uf unused column but can drop them with alter table emp047 drop unused columns
 --Constraints
can not create NOT NUL constraints out of line!!!!only inline
drop primary key: cascade,keep index o drop index (drop e’ default);
drop a not null constraints:
alter table emp047 modify  agap_code NULL ---not null is a special one
--its faster to enable const on a table then perform check row 1 by 1: so desable,insert and enable
--disable/enable
alter table emp047 DISABLE constraints fk_dept_id --cascade se richiesto
alter table emp047 ENABLE constraints fk_dept_id --cant cascade the enable



--Validate / Invalidate
enable novalidate:    rows already there are not checked
enable validate / disable novalidate:default
disable valdate: special use

ORacle reccomends following steps:
disable,import data,enable no validate,enable
--Deferable: can defer constraint within a transaction
alter table emp047 
add constraints fk_dept_id foreign key  dept_id references department(dept_id)DEFERRABLE;
set constraint fk_dept_id DEFERRED.
once commit happen constarint is resored , but if constraint was violated the transaction just ROLLBACK.
--REname constraints:
alter table emp047 RENAME constraints fk_c1 TO fk_nuova
--Create intex with create table
when create a PK an index is also created by default ,but we can create one explicitly:

create table test ( a number  PRIMARY KEY
 USING INDEX ( create index idx_tst on test(a)))
-- u can also: USING INDEX idx_name (per assegnare un index che gia esiste)
--Function based index:
create index idx_upper on emp(UPPER(lastname))  //on emp(salary*age)

--FLASHBACK
cant retrieve :
befroe last DDL on table
CAN retireve; immediate before Drop, SCN,timestamp,restore point
FLASHBACK table emp047 to  BEFORE DROP 



flashback table flashback_test to before drop


 seconds ago
select * from flashback_test
FILI7
29 secondago
drop table flashback_test
FILPPO047
42 secons ago


FIIPPO047
63 secods ago


FLIPPO047


create table flashback_test (a number )


insert into flashback_test values (2)

select * fromflashback_test

;
select * from recyclebin;
select * from user_recyclebin;
--PURGE
--aftrr PURGE cant flashback a table: note purge can also be automatical scheduled from DBA

PURGE table emp047;--table have to be dropped before

--
create table test (a number)  ENABLE ROW MOVEMENT; insert into…,commit,delete,commit
flashback table emp047 TO scn ---thath the reccomended one
       get scn so: select dbms_flashback.get_system_change_number from dual;

flashback table emp047 TO timestamp
flashback table emp047 TO restore point;
      crea cosi:   create RESTORE POINT my_restorep;
                          select * from v*restore_point;
select dbms_flashback.get_system_change_number from dual;
select current_scn from v$database;

--USE EXTERNAL TABLE
you can only select NO insert,index,lob etc.

directory: create or replace DIRECTORY dir_01 as ’/dir_01’
                grant READ on DIR_01 to SCOTT


;



12 Set - Union,Union all,Intersect, Minus
no order by in the intermediate query.ONLY AT THE END
can order by referencing position or reference(here is valid the alias in 1st query)
--UNION : remove duplicate
select rownum,'set',e.* from  emp047_set e
union
select rownum,'emp',ee.* from  emp047 ee
order by 3
set
EMP_ID    NAME    LASTNAME    DEPT_ID    SALARY
1    john    bagiggia    1    3000
2    john    smith    1    6000
3    john    doe    2    9000
4    john    bianchi    2    5000
10    john    lastrada    1    7000
50    john    crodino    2    
emp
1    john    bagiggia    1    3000
2    john    smith    1    6000
3    john    doe    2    9000
4    gianni    bianchi    2    5000
10    gino    lastrada    1    7000
50    dino    crodino    2    3000
---
my union
john bagiggia
john smith
john doe
john bianchi
gianni bianchi
john lasstrada
john crodino
gino lastrada
gino crodino
--UNION ALL: keep  duplicate
--INTERSECT
 john    bagiggia
 john    doe
 john    smith

--MINUS : sl primo sottrai i secondi

john    bianchi
john    crodino    
john    lastrada




13 Rollup Cube Grouping sets grouping grouping id

--Rollup
is a GROUP BY extension (and like group by doesnt recognize aliases of select)
group by rows are AGGREGATE ,rollup rows are SUPERAGGREGATE rows 


PK_ID    REGION    STATE    CITY    OFFICE    PRICE
8    us    illinois    chicago    of3    20
1    eu    italy    rome    of1    100
2    eu    italy    rome    of2    300
2    eu    germany    berlin    of1    300
3    eu    germany    berlin    of1    300
4    eu    germany    munich    of1    400
5    eu    france    paris    of1    400
6    us    illinois    chicago    of1    400
7    us    illinois    chicago    of1    300

SINTASSI 1  :group by  rollup(list)-- standard tutti totaloni
select region ,state,city,sum(price)
from  analytic_test
group by  rollup(region,state,city)

SINTASSI 2  :group by,  rollup(list) -- non fa il totalone dei group by ,quindi”taglia” a sx
select region ,state,city,sum(price)
from  analytic_test
group by region, rollup(state,city)




-CUBE (3d rollup)
select region ,state,city,sum(price)
from  analytic_test
group by  cube(region,state,city)

--GROUPING(function):distinguish aggregate from superaggregate
0-->group by
1-->field rolled up (column is null)
--FUNZIA anche senza ROLLUP/CUBE!!!non serve a nulla ma funzia (important test)

select grouping(region), grouping(state),grouping(city),
region,state,city,
sum(price)
from  analytic_test
group by  cube(region,state,city)


select grouping(region), grouping(state),grouping(city),
region,state,city,
sum(price)
from  analytic_test
group by  region, cube(state,city)

--GROUPING SETS( group by clause):
is a midpoint between group by & rollupCube
it performs UNION ALL of the “group by” specified in “grouping sets” clause

select state,sum(price)
from  analytic_test
group by GROUPING SETS ((state),null)


14 Dictionary
select* from dictionary;
   USER_ :current user stuff
   ALL_  :all you have priv TO
   dba_  :everything

--   tabella prefissi
   v_$  DYNAMIC PERFORMANCE VIEW  db inst par;
   v$   Public synonym db inst par;
   session_
   nls_
   
--catalog
select * from cat;
select * from user_catalog;

select * from DBA_COL_COMMENTS;
select * from DBA_ERRORS;
select * from DBA_INDEXES where table_name='PROVISIONS_INTERFACE'; --reread
select * from DBA_IND_COLUMNS;

select c.index_name,column_name,column_position,column_length,descend,
index_type,uniqueness,status,num_rows
from
   DBA_INDEXES i,DBA_IND_COLUMNS c
   where i.table_name='PROVISIONS_SOLLSTELLUNGEN'
   and c.table_name=i.table_name
   and i.index_name=c.index_name
   order by c.index_name asc
      ; --reread

select * from dba_col_comments where table_name in ('DBA_INDEXES','DBA_IND_COLUMNS')
--and lower(column_name) in ('column_position','column_length','descend','index_type','uniqueness','status','num_rows')
;


select * from all_constraints where owner='ADPROV' order by table_name ;
select * from all_cons_columns  where owner='ADPROV' order by table_name ;
-- constarintt completa (the R ref a PK not a column)
select
con.table_name,con.constraint_name,constraint_type,search_condition,column_name,position
r_owner,r_constraint_name,status,deferrable,deferred
from all_constraints con,all_cons_columns  col
where --con.table_name='AP_AD_ORGANZST'
--and
 con.table_name=col.table_name
and con.constraint_name=col.constraint_name
order by con.constraint_name;

    C (check constraint on a table)
    P (primary key)
    U (unique key)
    R (referential integrity)
    V (with check option, on a view)
    O (with read only, on a view)


select * from DBA_OBJECTS;
select * from DBA_ROLE_PRIVS;
select * from DBA_ROLES   ;
select * from dictionary where table_name like '%CONSTR%';

--PRIVILEGE : sys & tab & role
--   sys are system : create session , create table
--   tab are object
--   role are grants to role
--
--   granted to current user
select * from USER_SYS_PRIVS order by 1;--        sys priv granted to user
                                        --        have no     sys  , why? check role is all there
select * from USER_tab_PRIVS order by 1;--        grtantee or grantor x current user
select * from USER_ROLE_PRIVS order by 1;--        Roles granted to current user                      
--   all
select * from dba_SYS_PRIVS order by 1;--        sys priv granted to user
select * from dba_tab_PRIVS order by 1;--        grtantee or grantor x current user
select * from dba_ROLE_PRIVS order by 1;--        Roles granted to current user                      
--  sys & tab granted to roles
select * from ROLE_SYS_PRIVS          ;--System privileges granted to roles                 
select * from ROLE_TAB_PRIVS          ;--Table privileges granted to roles                  


--session
select * from  SESSION_ROLES order by 1;--Roles which the user currently has enabled.        
select * from ROLE_ROLE_PRIVS order by 1;--  Roles which are granted to roles                   

-------------------

select * from DBA_SEQUENCES order by 1 ;  
select * from DBA_SEQUENCES where sequence_name ='INSTANZ_ID' ;  
select instanz_id.nextval    from   dual;--17174581135
                                          -- 17174581673
select * from DBA_SYNONYMS order by owner asc;
select * from DBA_VIEWS;

select * from all_tables where table_name='PROVISIONS_INTERFACE'; --row_movement
select * from all_tables where row_movement <>'DISABLED';--34 sys view...


select * from all_objects where object_name like 'V_$%';
select * from all_objects where object_name like 'V$%';
select * from v$database;
select * from v$parameter;
select * from v$session;



select * from dictionary
where table_name like 'NLS_%' or table_name like 'SESSION_%'
;
select * from NLS_DATABASE_PARAMETERS;
select * from NLS_INSTANCE_PARAMETERS;
select * from NLS_SESSION_PARAMETERS ;
select * from SESSION_PRIVS          ;
select * from SESSION_ROLES          ;


--add comment on table,cant delete but add ' '
comment on table port is 'bla vbla';
sys privs: grantee_grant_privs
constraint abbreviation;



--18
-- you can GRANT / REVOKE 
--    a SYSTEM / OBJECT privilege
--       to a USER,ROLE or PUBLIC
-- grants comes directly or through role (or role of role ) or through public
-- have their own separate namespace
-- ROLE can be ASSIGNED to PUBLIC!!!!!
-- ROLE can be assigned to other ROLE , so you have a treeof privs....

-- user priv on sys SYS
select * from user_sys_privs;  -- SYSTEM PRIVILEGE to user:may be empty, probably you have grant through role
select * from dba_tab_privs;   -- OBJ PRIV to users :all grants on object include users,role,

--all OBJ privs you have . through user,role or Public                           
select * from all_tab_privs_recd; 
select * from all_tab_privs_made ;
--all sys privs for current session: through user or role
select * from session_privs;   -- 
--ROLE : can assign role to a user or to a role!


-- 3 historical rows
-- CONNECT,RESOURCE,DBA

- create ROLE 047_ROLE ;
grant select on pippo to 047_role;

select * from dba_role_privs
where granted_role ='INTERACTIVE_GROUP'
; --all privs for a role
INTERACTIVE_GROUP

select * from dba_roles_privs; --all S Y S T E M  privs for a role

select * from dba_tab_privs; --all O B J E C T privs for a role
select * from role_role_privs; --roles assigned to roles 
-- sys or tab priv x a role
select * from role_sys_privs;
select * from role_tab_privs;
--roles for curr sess
select * from session_roles;


--ROLE I HAVE : through my role + public role
-- missing 2nd level? role of role
select * from user_role_privs;
--   see the difference:
   select * from user_role_privs
   where granted_role not in  (select granted_role from dba_role_privs where grantee= user) ;

-- grant to role i have (excluding the PUBLIC one).
select 
 r.granted_role,r.admin_option ,' ' obj_name,' ' column_name,p.privilege,p.admin_option
from 
   dba_role_privs r,role_sys_privs p
where
   r.grantee = user
    and  r.granted_role=p.role
--order by  r.granted_role  
union
select 
 r.granted_role,r.admin_option ,p.table_name,p.column_name,p.privilege,p.grantable
from 
   dba_role_privs r,role_tab_privs p
where
    r.grantee = user
    and  r.granted_role=p.role
order by 1,3,5 asc 
;
--missing  level?should you connect by 
select granted_role  from dba_role_privs where grantee in (
select granted_role  from dba_role_privs where grantee in (
select granted_role  from dba_role_privs where grantee in (
select granted_role  from dba_role_privs where grantee in (
select granted_role from dba_role_privs where grantee =user))));
select * from dba_role_privs where grantee in (
select granted_role from dba_role_privs where grantee =user);

--todo do the connect by !!!!!



--17 Regular expression
-- (s) match all string s
-- [] OR-match    at least 1 that match -char based
--    [=e=]    e equivalents  
-- [^]OR-NoMatch  at least 1 that DONT  match
--   . 1 char
-- REPETITION ? * + : ? 0 or1  ,* 0 or more, + 1 or more
--            {n} exactly n , {n,}  n or more  , {n,m} min N times max M times
--            [3-8]  [a-zA-Z] collation // PPOSIX style [[:digit:]]  minuscolo
--                   http://www.regular-expressions.info/posixbrackets.html
--                   blank vs spaces: [:space:] will also match items like new line characters
--
--  | OR 
--  ^ begin_of_line , $ end_of_line
-- escape \
--                      replace backreference '\2 \1 \3' replace ,ma  sostituisci prima 2 1 3 pattern definitida ()

select REGEXP_SUBSTR( s1,pattern,            POSITION,N_MATCH,                          CRITERIA) from dual;--returns the string that match pattern
select REGEXP_INSTR(  s1,pattern,            POSITION,N_MATCH,which_n_give_back,        CRITERIA) from dual;--instr
select REGEXP_REPLACE(s1,pattern,REPLACE_STR,POSITION, §       N_TO_BE_REPLACED,         CRITERIA) from dual;--repaleced full string
select REGEXP_REPLACE('! grazie 1000','([[:punct:]]) ([[:alpha:]]+) ([[:digit:]]+)','\2 \2 \2  \3 \1') from dual;--backreference  \3

select * from dual 
       WHERE REGEXP_LIKE(s1,pattern,CRITERIA) from dual;--boolean  onli in WHERE CLAUSE!!!!!!!
--CRITERIA:       
--c casesensitive, i not casesensitive,n . is newline,m threat as multiple rows,x ignore whitespaces

-- . dot match any char 
select REGEXP_SUBSTR('abc 2',
                     '.') from dual; --cerca de
select REGEXP_REPLACE('abc 2',
                      '.','<__.__>') from dual;
select * from dual where REGEXP_LIKE('01-01-2011','[[0-9]]{2}'); --match  
select REGEXP_substr('01-01-2000','[0-9]{2}-[0-9]{2}-[0-9]{4}') from dual ; --match  
select * from dual where REGEXP_LIKE('01-01-2000','([.])-');  --nomatch
                    
-- ?   0 or 1 occurence of previous expression
select REGEXP_SUBSTR('abc 2',
                     '(f)?') from dual; 
select REGEXP_REPLACE('abc 2',
                      '?','<__?__>') from dual;--0 found
select REGEXP_REPLACE('abccccccccccc2',
                      'c?','<__c__>') from dual;--1 found


-- *  0 or more of preceding
select REGEXP_SUBSTR('abc 2',
                     '(b)*') from dual; 
select REGEXP_REPLACE('abc 2',
                      '*','<__*__>') from dual;--
select REGEXP_REPLACE('abccccccccccc2',
                      'c*','<__*__>') from dual;
-- + 1 or more of preceding
select REGEXP_SUBSTR('abc 2',
                     '(b)+') from dual;
select REGEXP_REPLACE('abc 2',
                      '+','<__+__>') from dual;--
select REGEXP_REPLACE('abccccccccccc2',
                      'c+','<__+__>') from dual;--


-- () : threat as sub expression : (def) --> match def e' un AND non OR come graffa
select REGEXP_SUBSTR('abc 2dg  def  dep',
                     '(d)(e)') from dual; --cerca de
select REGEXP_REPLACE('abc 2dg def dep',
                      '(d)(e)','<__(d)(e)__>') from dual;
select * from dual
where REGEXP_LIKE('abc 2dg  def  dep',
                     '(abc)(e)');
                      
-- [] : List of expression : collation kind of OR
select REGEXP_SUBSTR('abc 2dg  def  dep',
                     '[de]') from dual; --cerca 
select REGEXP_REPLACE('abc 2dg df dep',
                      '[de]','<__[de]__>') from dual;
select * from dual
where REGEXP_LIKE('abc 2dg df dep',--match
                      '([ace]b[redcbd]( ))') ;                      
-- [^ ] : "not equals"
select REGEXP_SUBSTR('abc 2dg  def  dep',
                     '[^de]') from dual; --cerca de
select REGEXP_REPLACE('abc 2dg df dep',
                      '[^de]','<__[^de]__>') from dual;
-- | OR
select REGEXP_REPLACE('abc 2dg ffffd',
                      '(d)|(g)','<__ d|g __>') from dual;
-- ^  $  begin end line
select REGEXP_REPLACE('abc 2dg ffffd',
                      '^','<__^__>') from dual;--append at beginning
select REGEXP_REPLACE('abc 2dg ffffd',
                      '^(a)','<__^__>') from dual;-- replace a at beginning
select REGEXP_REPLACE('abc 2dg ffffd',
                      '$','<__^__>') from dual;--append at end
-- character class type [:alnum:] [:alpha:] [:blank:] [:digit:] [:lower:] 
select REGEXP_REPLACE('abc 2dg ffffd',
                      '[[:digit:]]','<__[:digit:]__>') from dual;
select REGEXP_REPLACE('abc 2dg ffffd',
                      '[0-9]','<__[:digit:]__>') from dual;
select REGEXP_REPLACE('abc 2dg ffffd',
                      '[[:digit:]]','<__[:digit:]__>') from dual;




--various example
select * from dual where REGEXP_LIKE('john,HR,100',
                                   '[^(IT)(HR)(FI)]') ;--
select REGEXP_substr('john,HR,100',
                                   '[^(IT)(HR)(FI)]') from dual  ;--                                   
select * from dual where REGEXP_LIKE('HR',
                                   '[^(IT)(HR)(FI)]') ;--true 'john,HR,100' would be false
select * from dual where REGEXP_LIKE('abccccccccccc2','g?') ;--true
select * from dual where REGEXP_LIKE('abccccccccccc2','g+') ;--false
select * from dual where REGEXP_LIKE('abccccccccccc2','c+') ;--true
select * from dual where REGEXP_LIKE('ccccccccccc','g+') ;--false
select * from dual where REGEXP_LIKE('abccccccccccc2','g*') ;--true
select * from dual where REGEXP_LIKE('abccccccccccc2','c{7,14}') ;--true
select * from dual where REGEXP_LIKE('abccccccccccc2','[a-f]2') ;--true
select * from dual where REGEXP_LIKE('abccccccccccc2','[a-b]2') ;--false
select * from dual where REGEXP_LIKE('abcc4cccccccfcc32','[[:digit:]]2') ;--true
select * from dual where REGEXP_LIKE('abccccccccccc2','[[:DIGIT:]]2') ;--false error
substr '[^;]+' 1,n n-mo campo;
'[[:alpha:]+]' char 
'[[:alpha:]]+' parola
;
select REGEXP_substr('abc def g','[[:alpha:]+]') ,REGEXP_substr('abc def g','[[:alpha:]]+') 
from dual  ;
select '<'||REGEXP_SUBSTR('0123456789 abcdefGHIL','[[:space:]]')||'>' from dual;
select '<'||REGEXP_SUBSTR('0123456-_789 abc,def;GHIL','[[:punct:]]')||'>' from dual;
select '<'||REGEXP_SUBSTR('0123456789 abcdefGHIL','[[:digit:]]')||'>' from dual;
select '<'||REGEXP_SUBSTR('0123456789 abcdefGHIL','[[:blank:]]')||'>' from dual;
select '<'||REGEXP_SUBSTR('0123456789 abcdefGHIL','[[:alpha:]]')||'>' from dual;
select '<'||REGEXP_SUBSTR(' :; 0123456789 abcdefGHIL','[[:alnum:]]')||'>' from dual;
SET SERVEROUTPUT ON
set feedback off
clear screen

declare
s_string  nvarchar2(255);
s_pattern nvarchar2(255);
s_substr nvarchar2(255) default 'empty';
BEGIN
dbms_output.enable(10000);

dbms_output.put_line('substr : ---------------------' );
s_string := '1234567890 abcdefh 3412 _3412 !';
s_pattern :='(34)[0-9]{2,8}[[:blank:]]';
select   
regexp_substr(s_string,s_pattern,1,2,'c')
into s_substr 
from dual;

dbms_output.put_line('string:<'||s_string ||
                     '>pattern:<'||s_pattern || '> out:<'||   nvl(s_substr,'not found')|| '>' );
dbms_output.put_line('instr : ---------------------' );
select   
regexp_instr(s_string,s_pattern,3,2,1)--opt 0 or 1 when 1 give index AFTER pattern
into s_substr 
from dual;

dbms_output.put_line('string:<'||s_string ||
                     '>pattern:<'||s_pattern || '> out:<'||   nvl(s_substr,'not found')|| '>' );

dbms_output.put_line('replace : ---------------------' );
dbms_output.put_line('        : remover' );

select   
regexp_replace(s_string,s_pattern)
into s_substr 
from dual;

dbms_output.put_line('string:<'||s_string ||
                     '>pattern:<'||s_pattern || '> out:<'||   nvl(s_substr,'not found')|| '>' );
  
dbms_output.put_line('        : rep' );

select   
regexp_replace(s_string,s_pattern,'FOUND')
into s_substr 
from dual;

dbms_output.put_line('string:<'||s_string ||
                     '>pattern:<'||s_pattern || '> out:<'||   nvl(s_substr,'not found')|| '>' );

dbms_output.put_line('        : rep start at 4 ' );
select   
regexp_replace(s_string,s_pattern,'FOUND',4 )
into s_substr 
from dual;
dbms_output.put_line('string:<'||s_string ||
                     '>pattern:<'||s_pattern || '> out:<'||   nvl(s_substr,'not found')|| '>' );
END;


------------------------------------------------------
-- difficult 2nd round
-- [...] : collating in current locale
-- [==] : equivalence:  [=e=] -->eéè 
-- {n1},{n1,},{n1,n2}




--TODO select over partition by
--grouping_ID
--todo grouping with rollup cube xml /grouping_id
--todo create table (...) organization external
REDO 11


Format Element    Description                                                         Example
CC                One greater than the first two digits of a four-digit year.         ROUND(SYSDATE,'CC')
SCC               One greater than the first two digits of a four-digit year.         ROUND(SYSDATE,'SCC')
Year              
SYYYY             Year; rounds up on July 1.                                          ROUND(SYSDATE,'SYYYY')
YYYY              Year; rounds up on July 1.                                          ROUND(SYSDATE,'YYYY')
YEAR              Year; rounds up on July 1.                                          ROUND(SYSDATE,'YEAR')
YYY               Year; rounds up on July 1.                                          ROUND(SYSDATE,'YYY')
YY                Year; rounds up on July 1.                                          ROUND(SYSDATE,'YY')
Y                 Year; rounds up on July 1.                                          ROUND(SYSDATE,'Y')
IYYY              ISO year.                                                           ROUND(SYSDATE,'IYYY')
IY                ISO year.                                                           ROUND(SYSDATE,'IY')
I                 ISO year.                                                           ROUND(SYSDATE,'I')
Q                 Quarter; rounds up on sixteenth day of the second month of the quarter. ROUND(SYSDATE,'Q')
Month  
MONTH             Month; rounds up on sixteenth day.                                 TRUNC(SYSDATE,'MONTH')
MON               Month; rounds up on sixteenth day.                                 TRUNC(SYSDATE,'MON')
MM                Month; rounds up on sixteenth day.                                 TRUNC(SYSDATE,'MM')
RM                Month; rounds up on sixteenth day.                                 TRUNC(SYSDATE,'RM')
Week
     
WW                Same day of the week as the first day of the year.                 TRUNC(SYSDATE,'WW')
W                Same day of the week as the first day of the ISO year.             TRUNC(SYSDATE,'IW')
W                 Same day of the week as the first day of the month.                TRUNC(SYSDATE,'W')
Day
      
DD                Day of the month (from 1 to 31).                                   ROUND(SYSDATE,'DD')
DDD               Day of the year (from 1s to 366).                                   ROUND(SYSDATE,'DDD')
J                 Day.                                                               ROUND(SYSDATE,'J')
tarting Day of the week.                                          
DY                Starting Day of the week.                                         TRUNC(SYSDATE,'DY')
DAY               Starting Day of the week.                                         TRUNC (SYSDATE,'DAY')
HH                Hour of the day (from 1 to 12).                                   TRUNC (SYSDATE,'HH')
HH12              Hour of the day (from 1 to 12).                                   TRUNC (SYSDATE,'HH12')
HH24              Hour of the day (from 0 to 23).                                   TRUNC (SYSDATE,'HH24')
MI                Minute (from 0 to 59).                                            TRUNC (SYSDATE,'MI')
----------------------------------------------------------------------------------------------
 

--------------------------------------------------------------------------------------------------




http://ellebaek.wordpress.com/
http://dbaora.com/nls_numeric_characters-as-easy-as-possible/
http://raminhashimzade.wordpress.com/
https://asktom.oracle.com/pls/apex/f?p=100:9:0::NO
http://www.oracle-base.com/
http://dwhanalytics.wordpress.com/
http://gennick.com/database/?category=SQL+Server

test:
https://www.selftestsoftware.com/gen.aspx?sn=STS_OracleDemoList&pf=page&pn=STS_OracleDemoListPage&utm_source=MRKT-13713&utm_medium=microsite&utm_term=oracle_demo&utm_content=non_paid&utm_campaign=STS_Partners_14#


;

select * from dual;
