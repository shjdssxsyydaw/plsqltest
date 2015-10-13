-- 3 Object type



CREATE TYPE Complex AS OBJECT ( 
   rpart REAL,  -- attribute
   ipart REAL,
   MEMBER FUNCTION plus (x Complex) RETURN Complex,  -- method
   MEMBER FUNCTION less (x Complex) RETURN Complex,
   MEMBER FUNCTION times (x Complex) RETURN Complex,
   MEMBER FUNCTION divby (x Complex) RETURN Complex
);

CREATE TYPE BODY Complex AS 
   MEMBER FUNCTION plus (x Complex) RETURN Complex IS
   BEGIN
      RETURN Complex(rpart + x.rpart, ipart + x.ipart);
   END plus;

   MEMBER FUNCTION less (x Complex) RETURN Complex IS
   BEGIN
      RETURN Complex(rpart - x.rpart, ipart - x.ipart);
   END less;

   MEMBER FUNCTION times (x Complex) RETURN Complex IS
   BEGIN
      RETURN Complex(rpart * x.rpart - ipart * x.ipart,
                     rpart * x.ipart + ipart * x.rpart);
   END times;

   MEMBER FUNCTION divby (x Complex) RETURN Complex IS
      z REAL := x.rpart**2 + x.ipart**2;
   BEGIN
      RETURN Complex((rpart * x.rpart + ipart * x.ipart) / z,
                     (ipart * x.rpart - rpart * x.ipart) / z);
   END divby;
END;


SELF------------
CREATE FUNCTION gcd (x INTEGER, y INTEGER) RETURN INTEGER AS
-- find greatest common divisor of x and y
   ans INTEGER;
BEGIN
   IF (y <= x) AND (x MOD y = 0) THEN ans := y;
   ELSIF x < y THEN ans := gcd(y, x);
   ELSE ans := gcd(y, x MOD y);
   END IF;
   RETURN ans;
END;

CREATE TYPE Rational AS OBJECT (
   num INTEGER,
   den INTEGER,
   MEMBER PROCEDURE normalize,
   ...
);

CREATE TYPE BODY Rational AS 
   MEMBER PROCEDURE normalize IS
      g INTEGER;
   BEGIN
      g := gcd(SELF.num, SELF.den);
      g := gcd(num, den);  -- equivalent to previous statement
      num := num / g;
      den := den / g;
   END normalize;
   ...
END;
----------------

MAP and ORDER Methods

The values of a scalar datatype such as CHAR or REAL have a predefined order, which allows them to be compared. But instances of an object type have no predefined order. To put them in order for comparison or sorting purposes, PL/SQL calls a MAP method supplied by you. In the following example, the keyword MAP indicates that method convert() orders Rational objects by mapping them to REAL values:
CREATE TYPE Rational AS OBJECT ( num INTEGER, den INTEGER, MAP MEMBER FUNCTION convert RETURN REAL, ... ); CREATE TYPE BODY Rational AS MAP MEMBER FUNCTION convert RETURN REAL IS BEGIN RETURN num / den; END convert; ... END;

-----------

Alternatively, you can supply PL/SQL with an ORDER method. An object type can contain only one ORDER method, which must be a function that returns a numeric result. In the following example, the keyword ORDER indicates that method match() compares two objects:

CREATE TYPE Customer AS OBJECT (  
   id   NUMBER, 
   name VARCHAR2(20), 
   addr VARCHAR2(30), 
   ORDER MEMBER FUNCTION match (c Customer) RETURN INTEGER
); 

CREATE TYPE BODY Customer AS 
   ORDER MEMBER FUNCTION match (c Customer) RETURN INTEGER IS 
   BEGIN 
      IF id < c.id THEN
         RETURN -1;  -- any negative number will do
      ELSIF id > c.id THEN 
         RETURN 1;   -- any positive number will do
      ELSE 
         RETURN 0;
      END IF;
   END;
END;

--------------------

CREATE [OR REPLACE] TYPE type_name 
  [AUTHID {CURRENT_USER | DEFINER}]
  { {IS | AS} OBJECT | UNDER supertype_name }
(
  attribute_name datatype[, attribute_name datatype]...
  [{MAP | ORDER} MEMBER function_spec,]
  [{FINAL| NOT FINAL} MEMBER function_spec,]
  [{INSTANTIABLE| NOT INSTANTIABLE} MEMBER function_spec,]
  [{MEMBER | STATIC} {subprogram_spec | call_spec} 
  [, {MEMBER | STATIC} {subprogram_spec | call_spec}]...]
) [{FINAL| NOT FINAL}] [ {INSTANTIABLE| NOT INSTANTIABLE}];

[CREATE [OR REPLACE] TYPE BODY type_name {IS | AS}
  { {MAP | ORDER} MEMBER function_body;
   | {MEMBER | STATIC} {subprogram_body | call_spec};} 
  [{MEMBER | STATIC} {subprogram_body | call_spec};]...
END;]
-------------

Examples of PL/SQL Type Inheritance
-- Create a supertype from which several subtypes will be derived. CREATE TYPE Person_typ AS OBJECT ( ssn NUMBER, name VARCHAR2(30), address VARCHAR2(100)) NOT FINAL; -- Derive a subtype that has all the attributes of the supertype, -- plus some additional attributes. CREATE TYPE Student_typ UNDER Person_typ ( deptid NUMBER, major VARCHAR2(30)) NOT FINAL; -- Because Student_typ is declared NOT FINAL, you can derive -- further subtypes from it. CREATE TYPE PartTimeStudent_typ UNDER Student_typ( numhours NUMBER); -- Derive another subtype. Because it has the default attribute -- FINAL, you cannot use Employee_typ as a supertype and derive -- subtypes from it. CREATE TYPE Employee_typ UNDER Person_typ( empid NUMBER, mgr VARCHAR2(30));



-------------
Defining Constructors

By default, you do not need to define a constructor for an object type. The system supplies a default constructor that accepts a parameter corresponding to each attribute.

You might also want to define your own constructor:

    To supply default values for some attributes. You can ensure the values are correct instead of relying on the caller to supply every attribute value.
    To avoid many special-purpose procedures that just initialize different parts of an object.
    To avoid code changes in applications that call the constructor, when new attributes are added to the type. The constructor might need some new code, for example to set the attribute to null, but its signature could remain the same so that existing calls to the constructor would continue to work.

For example:

CREATE OR REPLACE TYPE rectangle AS OBJECT
(
-- The type has 3 attributes.
  length NUMBER,
  width NUMBER,
  area NUMBER,
-- Define a constructor that has only 2 parameters.
  CONSTRUCTOR FUNCTION rectangle(length NUMBER, width NUMBER)
    RETURN SELF AS RESULT
);
/

CREATE OR REPLACE TYPE BODY rectangle AS
  CONSTRUCTOR FUNCTION rectangle(length NUMBER, width NUMBER)
    RETURN SELF AS RESULT
  AS
  BEGIN
    SELF.length := length;
    SELF.width := width;
-- We compute the area rather than accepting it as a parameter.
    SELF.area := length * width;
    RETURN;
  END;
END;
/

DECLARE
  r1 rectangle;
  r2 rectangle;
BEGIN
-- We can still call the default constructor, with all 3 parameters.
  r1 := NEW rectangle(10,20,200);
-- But it is more robust to call our constructor, which computes
-- the AREA attribute. This guarantees that the initial value is OK.
  r2 := NEW rectangle(10,20);
END;
/

Calling Constructors

Calls to a constructor are allowed wherever function calls are allowed. Like all functions, a constructor is called as part of an expression, as the following example shows:

DECLARE
   r1 Rational := Rational(2, 3);
   FUNCTION average (x Rational, y Rational) RETURN Rational IS
   BEGIN 
      ... 
   END;
BEGIN
   r1 := average(Rational(3, 4), Rational(7, 11)); 
   IF (Rational(5, 8) > r1) THEN 
      ...
   END IF;
END;

When you pass parameters to a constructor, the call assigns initial values to the attributes of the object being instantiated. When you call the default constructor to fill in all attribute values, you must supply a parameter for every attribute; unlike constants and variables, attributes cannot have default values. As the following example shows, the nth parameter assigns a value to the nth attribute:

DECLARE
   r Rational;
BEGIN
   r := Rational(5, 6);  -- assign 5 to num, 6 to den
   -- now r is 5/6

The next example shows that you can call a constructor using named notation instead of positional notation:

BEGIN
   r := Rational(den => 6, num => 5);  -- assign 5 to num, 6 to den


-----------------------------------

sing Function VALUE

As you might expect, the function VALUE returns the value of an object. VALUE takes as its argument a correlation variable. (In this context, a correlation variable is a row variable or table alias associated with a row in an object table.) For example, to return a result set of Person objects, use VALUE as follows:
BEGIN INSERT INTO employees SELECT VALUE(p) FROM persons p WHERE p.last_name LIKE '%Smith';

In the next example, you use VALUE to return a specific Person object:
DECLARE p1 Person; p2 Person; ... BEGIN SELECT VALUE(p) INTO p1 FROM persons p WHERE p.last_name = 'Kroll'; p2 := p1; ... END;

At this point, p1 holds a local Person object, which is a copy of the stored object whose last name is 'Kroll', and p2 holds another local Person object, which is a copy of p1. As the following example shows, you can use these variables to access and update the objects they hold:
BEGIN p1.last_name := p1.last_name || ' Jr';

Now, the local Person object held by p1 has the last name 'Kroll Jr'.
Using Function REF

You can retrieve refs using the function REF, which, like VALUE, takes as its argument a correlation variable. In the following example, you retrieve one or more refs to Person objects, then insert the refs into table person_refs:
BEGIN INSERT INTO person_refs SELECT REF(p) FROM persons p WHERE p.last_name LIKE '%Smith';

In the next example, you retrieve a ref and attribute at the same time:
DECLARE p_ref REF Person; taxpayer_id VARCHAR2(9); BEGIN SELECT REF(p), p.ss_number INTO p_ref, taxpayer_id FROM persons p WHERE p.last_name = 'Parker'; -- must return one row ... END;

In the final example, you update the attributes of a Person object:
DECLARE p_ref REF Person; my_last_name VARCHAR2(15); BEGIN SELECT REF(p) INTO p_ref FROM persons p WHERE p.last_name = my_last_name; UPDATE persons p SET p = Person('Jill', 'Anders', '11-NOV-67', ...) WHERE REF(p) = p_ref; END;



