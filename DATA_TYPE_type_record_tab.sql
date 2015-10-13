declare 
-- NEW TYPE
--type type_test_rec ; --eventua FORWARD declaration



-- NEW RECORD (of data type and def data type)
type type_test_rec is record 
   (a number,    b number,    c number(3)     )   ;

   --
type composite_rec is record 
   (trec type_test_rec   ,a number,    b number,    c number(3)     )   ;

-- NEW TABLE of
 TYPE my_table_typ IS TABLE OF type_test_rec 
          INDEX BY BINARY_INTEGER;

-- actual vatriable instance
actual type_test_rec ;
actual_composite composite_rec;
actual_tab my_table_typ ;

begin 
   actual.a := 1;
   actual.b := 2;   

   dbms_output.put_line('actual.a:'||actual.a || '/actual.b:'||actual.b);
   
   actual_composite.a :=1;
   actual_composite.b :=2;
   actual_composite.c :=3;

   actual_composite.trec.c :=10;
   actual_composite.trec.c :=20;
   actual_composite.trec.c :=30;
   
   dbms_output.put_line('actual_composite.a:'||actual_composite.a || '/actual_composite.b:'||actual_composite.b
                        ||'/actual_composite.trec.a:'||actual_composite.trec.a
                        );
                            
   -- T A B L E
   --exists
   if actual_tab.exists(1)  then
      dbms_output.put_line('actual_tab.exists');
   else
      dbms_output.put_line('actual_tab. NOT exists');         
   end if; 
   --count  
   dbms_output.put_line('actual_tab.count():'||actual_tab.count());
   
   actual_tab(1).a :=100;
   actual_tab(2).a :=200;
   actual_tab(3).a :=300;
   actual_tab(5).a :=300;
   if actual_tab.exists(1)  then
      dbms_output.put_line('actual_tab.exists');
   else
      dbms_output.put_line('actual_tab. NOT exists');         
   end if;   
   dbms_output.put_line('actual_tab.count():'||actual_tab.count());
    --reference 
   dbms_output.put_line('actual_tab.count():'|| actual_tab(1).a );
   --prior next
   dbms_output.put_line('next di 3:'|| actual_tab.next(3)||'/priordi 3:'|| actual_tab.prior(3) );
   --delete
   actual_tab.delete (2);
   dbms_output.put_line('actual_tab.count():'||actual_tab.count());
   
end;
/
