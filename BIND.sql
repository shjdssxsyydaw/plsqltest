set serveroutput on

--REM declare and assign
VAR my_var NUMBER;
VARIABLE my_var_2 number;
execute :my_var := 101;
begin
	:my_var_2 := 10;

--Print	
	dbms_output.put_line('my_var ' ||:my_var ||' my_var2 '||:my_var_2);
end;
/    

print my_var ;	

select :my_var_2 from dual;
