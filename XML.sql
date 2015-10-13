--       X  M  L
--      DBMS_XMLGEN

-- I n s t a l l a t i o n
create table my_test_xml (a number , b VARCHAR2(255),c number);
insert into my_test_xml values (1,'test 1',100);
insert into my_test_xml values (2,'test 2',200);


-- X M L   E L E M E N T
   --Generate a  single node  <my_Date>07-JUN-94</my_Date>
   SELECT XMLElement("ID", a)   FROM my_test_xml;


   --Nested Element
   SELECT XMLElement("main_record",
                        XMLElement("ID", a),
                        XMLElement("description", b)                        
                      )   FROM my_test_xml;   

/*            <main_record>
               <ID>1</ID>
               <description>test 1</description>
             </main_record>
*/


   -- X M L  A T T R I B U T E
   SELECT XMLElement("main_record",
                      XMLAttributes('http://www.w3.org/2001/XMLSchema'     as "xmlns:xsi",
                                    'http://www.oracle.com/Employee.xsd'  as "xsi:nonamespaceSchemaLocation"),                   
                           XMLElement("ID", a),
                           XMLElement("description", b)                        
                      )   
   FROM my_test_xml; 
  /*    <commission xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nonamespaceSchemaLocation="http://www.IGB2B.ch/B2B4IB/2006/xmlSchema commissionV4.1.xsd">
            <header>
            </header>
            <period>
            </period>
            <contract>100353397</contract>
         </commission>
*/   

   -- X M L  F O R E S T
   SELECT 
                           XMLForest(a,b,c,a "test") as xml_out
             FROM my_test_xml; 
/*
   <A>1</A>
   <B>test 1</B>
   <C>100</C>
   <test>1</test>
*/   



   -- Generating an Element from a User-Defined Data-Type Instance ( 2  tables are in use )
   --   PARENT
   --      child row 1
   --      child row 2
   --      child row 3
   --      child row n                     
   
   
CREATE OR REPLACE TYPE emp_t AS OBJECT ("@EMPNO" NUMBER(4),
                                         ENAME VARCHAR2(10));

CREATE OR REPLACE TYPE emplist_t AS TABLE OF emp_t;

CREATE OR REPLACE TYPE dept_t AS OBJECT ("@DEPTNO" NUMBER(2),
                                         DNAME VARCHAR2(14),
                                         EMP_LIST emplist_t);


SELECT XMLElement("Department",
                  dept_t(1,
                         'fix2',
                         CAST(MULTISET(SELECT a,b
                                         FROM my_test_xml
                                                )
                              AS emplist_t)))
  AS deptxml
  FROM my_test_xml
;              

/*
<Department>
      <DEPT_T DEPTNO="1">
      <DNAME>fix2</DNAME>
         <EMP_LIST>
               <EMP_T EMPNO="1">
               <ENAME>test 1</ENAME>
               </EMP_T>
               <EMP_T EMPNO="2">
                  <ENAME>test 2</ENAME>
               </EMP_T>
         </EMP_LIST>
      </DEPT_T>
</Department>
*/




      -- X M L C O N C A T
      SELECT XMLConcat(XMLSequenceType(
                   XMLType('<PartNo>1236</PartNo>'), 
                   XMLType('<PartName>Widget</PartName>'),
                   XMLType('<PartPrice>29.99</PartPrice>'))).getCLOBVal()
  AS "RESULT"
  FROM DUAL;
   /*  
      <PartNo>1236</PartNo>
      <PartName>Widget</PartName>
      <PartPrice>29.99</PartPrice>
   */
   
   
   
   -- X M L A  G  G    (order by)
   SELECT XMLElement("bob",-- doesnt work XMLElement("bob",b) 
                     XMLAgg(XMLElement("Employee",a)
                           ORDER BY a
                           )
                     )
  AS "Dept_list"     
  FROM my_test_xml 
  ;
