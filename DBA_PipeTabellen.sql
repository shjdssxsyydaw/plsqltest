-- ==============================================================
-- Umgang mit Select's, welche den Dateninhalt über Pipe erhalten
-- --------------------------------------------------------------
-- 
-- ==============================================================

create or replace package pck_pipeline as
   type type_rec_gueltig is record( gueltig_von date, gueltig_bis date );
   type type_tab_gueltig is table of type_rec_gueltig;
   
   function if_define_gueltig( pd_date in date ) return type_tab_gueltig pipelined;
end pck_pipeline;
/

create or replace package body pck_pipeline as
   function if_define_gueltig( pd_date in date ) return type_tab_gueltig pipelined is
      rec_gueltig type_rec_gueltig;

   begin
     rec_gueltig.gueltig_von := trunc(pd_date) - 1;
     rec_gueltig.gueltig_bis := trunc(pd_date) + 1;
     pipe row (rec_gueltig);
     return;
   end if_define_gueltig;
end pck_pipeline;
/


-- Select -----------------------------

select ver.ver_vertrag, 
       ver_instanzierung, 
       pip.gueltig_von, 
       pip.gueltig_bis 
  from ev_vertraege ver, table( pck_pipeline.if_define_gueltig(ver.ver_instanzierung)) pip
  where ver_vertrag like '%1000'
    and rownum < 50; 
    
    VER_VERTR VER_INSTA GUELTIG_V GUELTIG_B
    --------- --------- --------- ---------
    50001000  16-OCT-96 15-OCT-96 17-OCT-96
    50011000  07-MAY-97 06-MAY-97 08-MAY-97
    50021000  17-OCT-97 16-OCT-97 18-OCT-97
    50031000  10-FEB-98 09-FEB-98 11-FEB-98
    3681000   28-MAR-98 27-MAR-98 29-MAR-98
    50041000  19-MAY-98 18-MAY-98 20-MAY-98    
    ...

-- View -------------------------------

create table ver_sample as 
  select * 
    from ev_vertraege
   where ver_vertrag like '%1000' 
     and rownum < 5;
   
create or replace view view_pipe as 
select ver.ver_vertrag, 
       ver_instanzierung, 
       pip.gueltig_von, 
       pip.gueltig_bis 
  from ver_sample ver, 
       table( pck_pipeline.if_define_gueltig(ver.ver_instanzierung)) pip;
   
select * from  view_pipe;

    VER_VERTR VER_INSTA GUELTIG_V GUELTIG_B
    --------- --------- --------- ---------
    50001000  16-OCT-96 15-OCT-96 17-OCT-96
    50011000  07-MAY-97 06-MAY-97 08-MAY-97
    50021000  17-OCT-97 16-OCT-97 18-OCT-97
    50031000  10-FEB-98 09-FEB-98 11-FEB-98
    
  
       
 