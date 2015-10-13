set serveroutput on 
declare 
 de_err_nr     number         ;
 de_err_gviz   number         ;
 de_anz_error  number         ;
 s_err_txt     varchar2(50)   ;
 s_err_time    varchar2(30)   ;
begin
   
   de_anz_error := pck_error.if_get_error_count ;
   
   dbms_output.put_line('de_anz_error:' || de_anz_error ) ;
   
   for n_loopindex in 1 .. de_anz_error -1 loop      
      
       de_err_nr  := pck_error.if_get_last_stackerror( n_loopindex -1  ) ;

       begin
          s_err_txt  := pck_error.if_get_last_stackerror_text( n_loopindex -1 ) ;
       exception
         when others then
              s_err_txt  := 'Error' ;   
       end ;
       
       begin
         de_err_gviz:= pck_error.if_get_last_stackerror_gviz( n_loopindex -1 ) ;
       exception
         when others then
              s_err_txt  := Null ;   
       end ;


       s_err_time := to_char(pck_error.if_get_last_stackerror_time( n_loopindex -1 ),'DD.MM.YY HH24:MI:SS' );
       
       dbms_output.put_line( 'Index:' || n_loopindex || 
                            ' ErrNr:' || de_err_nr  || 
                             ' Time:' || s_err_time ||
                             ' Gviz:' || de_err_gviz ||
                             ' Text:' || s_err_txt ) ;
                            
                            
       
   end loop ;

  --  pck_error.if_set_error( null , '' ) ;

end ;
/