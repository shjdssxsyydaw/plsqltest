-- Plaintext of a statement by its sql_id
-- (see ses.sql)
select sql_text
  from v$sqltext
 where sql_id = '&sql_id'
 order by piece
/

