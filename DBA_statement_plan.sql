-- show the execution plan for a statement

define sql_id=&sql_id

select * 
from table(
  dbms_xplan.display_cursor(
    sql_id          => '&sql_id',
    cursor_child_no => 0
  )
)
/

undefine sql_id

