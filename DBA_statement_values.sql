define sql_id=&sql_id

select to_char(last_captured,'dd.mm.yyyy hh24:mi:ss')                     captured,
       sbc.child_number                                                   child_number,
       sbc.position                                                       position,
       sbc.name                                                           name,
       substr(sbc.datatype_string,1,15)                                   datatype,
       substr(decode(sbc.was_captured,'YES',sbc.value_string,'n/a'),1,60) value_string
  from v$sql_bind_capture sbc
 where sbc.sql_id         like '&sql_id'
 order by sql_id, hash_value, address, child_number, position
/

undefine sql_id

