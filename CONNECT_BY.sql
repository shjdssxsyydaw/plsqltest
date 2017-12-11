CREATE TABLE hierarchy_16
    (emp_id                         NUMBER ,
    position                       NVARCHAR2(255),
    boss                           NUMBER)
 ;

CREATE TABLE hierarchy_16_2
    (emp_id                         NUMBER ,
    position                       NVARCHAR2(255),
    boss                           NUMBER)
;
INSERT INTO hierarchy_16 
VALUES(20,'CEO',NULL);
INSERT INTO hierarchy_16 
VALUES(22,'Dept manager IT',20);
INSERT INTO hierarchy_16 
VALUES(23,'Dept Manager FI',20);
INSERT INTO hierarchy_16 
VALUES(24,'Team manager 1',22);
INSERT INTO hierarchy_16 
VALUES(40,'FI account',23);
INSERT INTO hierarchy_16 
VALUES(41,'Dept Manager HR',20);
INSERT INTO hierarchy_16 
VALUES(43,'Hr assistant',41);
INSERT INTO hierarchy_16 
VALUES(62,'IT consultant',24);
INSERT INTO hierarchy_16 
VALUES(65,'IT consultant 2',24);
INSERT INTO hierarchy_16 
VALUES(66,'FI consultant',40);
INSERT INTO hierarchy_16 
VALUES(69,'no root fath 69',NULL);

---
INSERT INTO hierarchy_16_2 
VALUES(20,'CEO',NULL);
INSERT INTO hierarchy_16_2
VALUES(66,'L1 A',20);
INSERT INTO hierarchy_16_2 
VALUES(67,'L1 B',20);
INSERT INTO hierarchy_16_2 
VALUES(68,'L2 B',67);
INSERT INTO hierarchy_16_2 
VALUES(69,'no root fath 69',NULL);

SELECT emp_id,
       position,
       boss,
       LEVEL,
       sys_connect_by_path(position, '/'),
       sys_connect_by_path(emp_id, '-'),
       sys_connect_by_path(boss, '/'),
       connect_by_root(position),
       connect_by_root(emp_id),
       connect_by_root(boss)
  FROM hierarchy_16
 START WITH emp_id = 20
CONNECT BY PRIOR emp_id = boss
       AND emp_id <> 23
 ORDER SIBLINGS BY position;
 
SELECT *
  FROM hierarchy_16_2
CONNECT BY emp_id = boss
 START WITH emp_id = 20
CONNECT BY PRIOR emp_id = boss;
