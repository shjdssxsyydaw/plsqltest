--OPTIMIZER_GOAL 
select * from v$parameter where name  like 'optimizer_mode';
/*
CBO
   ALL_ROWS    minimum resource use to complete the entire statement).  
   FIRST_ROWS  minimum resource use to return the first row of the result set).  

RBO
   RULE        

CHOOSE: optimizer chooses between  cbo & rbo

*/


--CBO relevant
select  name,display_value,description
 from v$parameter where name  in
('pga_aggregate_target','sort_area_size','hash_area_size')

;
