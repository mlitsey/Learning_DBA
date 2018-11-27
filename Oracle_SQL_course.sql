Apex to access oracle cloud database

--retrieving data FROM a table
'SELECT CLAUSE (QUERY)'

SELECT * FROM EMP;

SELECT <COLUMN1, 2, 3>
FROM <SOME_TABLE>

SELECT JOB FROM EMP;
SELECT JOB, ENAME FROM EMP;
SELECT job, ename FROM emP;

dept name and location columns only
SELECT * FROM dept;                      'did this to see what the names of the columns are'
SELECT <dept_name, location> FROM dept;
'DEMO'
SELECT SQL Workshop and object browser in APEX to see what tables are available
SELECT * FROM dept;

'set rows in APEX to 15'
SELECT job FROM emp;
SELECT distinct job FROM emp;  'use the <distinct> feature to only see unique values'

'WHERE CLAUSE'

SELECT * FROM emp WHERE job = 'MANAGER';
    easier to read like this
SELECT *
FROM emp
WHERE job = 'MANAGER';
SELECT * FROM emp WHERE job = 'manager';   'will not work since the data (job='manager') needs to be exact'
SELECT * FROM emp WHERE job = 'MANaGER';
SELECT * FROM emp WHERE job = 'SALESMAN';
SELECT * FROM emp WHERE ename = 'ALLEN';

SELECT * FROM emp WHERE job = 'SALESMAN' and sal = 1600 and comm = 500;
SELECT * FROM emp WHERE job = 'SALESMAN' and sal = 1600;    'start filtering out restrictions to get data'
SELECT * FROM emp WHERE job = 'SALESMAN' and sal = 1600 and comm = 300;
SELECT * FROM emp WHERE job = 'SALESMAN' and sal = 1600 and comm = 300 and deptno = 30;
SELECT * FROM emp WHERE job = 'SALESMAN' and sal = 1600 and comm = 300 and deptno = 30 and ename = 'BILL';
SELECT lname FROM emp;
SELECT ename FROM emp;


-- Using operators in the WHERE clause

SELECT * FROM emp;
SELECT * FROM emp WHERE job = 'SALESMAN';
SELECT * FROM emp WHERE job != 'SALESMAN';    -- not equal to SALESMAN
SELECT * FROM emp WHERE job != 'SALESMAN' and job = 'SALESMAN';
SELECT * FROM emp WHERE job != 'SALESMAN' and job = 'SALESMAN' and sal < 2500;  -- less than 2500
SELECT * FROM emp WHERE job != 'SALESMAN' and job = 'SALESMAN' and sal < 3000;
SELECT * FROM emp WHERE job != 'SALESMAN' and job = 'SALESMAN' and sal <= 3000; -- less than or equal to 3000
SELECT * FROM emp WHERE job != 'SALESMAN' and job = 'SALESMAN' and sal > 3000;  -- greater than 3000
SELECT * FROM emp WHERE comm < sal;
SELECT * FROM emp WHERE sal > comm;
SELECT * FROM emp WHERE job != 'MANAGER' and sal > 2500 and deptno = 20;

-- Combining WHERE, AND, OR with operators

SELECT * FROM emp WHERE job = 'CLERK';
SELECT * FROM emp WHERE job = 'CLERK' and job = 'SALESMAN';
SELECT * FROM emp WHERE job = 'CLERK' or job = 'SALESMAN';
SELECT ENAME FROM emp WHERE job != 'MANAGER' and job != 'SALESMAN' and sal >= 2000;
SELECT * FROM dept;
SELECT ENAME, HIREDATE FROM emp WHERE deptno = 20 or deptno = 30;

-- query filtering with BETWEEN, IN, NULL

SELECT ENAME, HIREDATE FROM emp WHERE deptno = 20 or deptno = 30;
SELECT ENAME, HIREDATE FROM emp WHERE deptno IN (20, 30);     -- same as above but shorter and easier to read
SELECT ENAME, HIREDATE FROM emp WHERE deptno NOT IN (20, 30); -- does not contain 20 or 30
SELECT ENAME, HIREDATE FROM emp WHERE ENAME IN ('FORD','SMITH', 'ALLEN', 'WARD', 'MARTIN');
SELECT ENAME, HIREDATE FROM emp WHERE ENAME NOT IN ('FORD','SMITH', 'ALLEN', 'WARD', 'MARTIN');

SELECT * FROM emp WHERE HIREDATE between '05/01/1981' and '12/09/1982';     -- shows a range between 1st and 2nd date, dates and strings must be in quotes
SELECT * FROM emp WHERE sal between 1000 and 2000;                          -- range is inclusive or bottom and top of range
SELECT * FROM emp WHERE sal between 950 and 1600;
SELECT * FROM emp WHERE sal not between 950 and 1600;

SELECT * FROM emp WHERE comm is null;     -- no data in the field
SELECT * FROM emp WHERE comm is not null;   -- field has data in it

'Write a query that returns those employees that dont make any commision and have a salary greater than 1100 but less than 5000. Exclude those employees that have a salary equal to 3000.'

SELECT * FROM emp
WHERE comm is null
and sal between 1101 and 4999
and sal != 3000 order by sal

-- query filtering conditions & operator precedence

 'answer to above question as instructor shows '
SELECT * FROM emp
WHERE (comm is null
and sal > 1100 and sal < 5000
and sal <> 3000	)	--<> is the same as !=
or comm = 0

" need to put all the and statements together, can also use () to ensure conditions are processed together"

" if it is changed to 1500 then the statement is wrong and would need to be changed"
SELECT * FROM emp WHERE (comm is null and sal > 1100 and sal < 5000 and sal <> 1500	) or comm = 0;
SELECT * FROM emp WHERE (comm is null or comm = 0) and sal > 1100 and sal < 5000 and sal <> 1500;

Return those employees that are salesman and that make either $300 in commision or greater than $1000 in commision.
SELECT * FROM emp WHERE job = 'SALESMAN' and comm = 300 or comm > 1000;
SELECT * FROM emp WHERE job = 'SALESMAN' and (comm = 300 or comm > 1000);

SELECT * FROM emp WHERE job = 'SALESMAN';
SELECT * FROM emp WHERE job LIKE 'S%';		-- like matches a pattern and is used with the wildcard % to match any other characters after S
SELECT * FROM emp WHERE job LIKE '%GER';	-- match any letters before ending with GER

-- Ordering, Concatenating, & Aliasing query results

SELECT * FROM emp;
SELECT ename, sal, comm FROM emp;
SELECT ename EMPLOYEE, sal SALARY, comm COMMISION FROM emp;	-- give meaningful names to the columns
SELECT ename EMPLOYEE NAME, sal SALARY, comm COMMISION FROM emp;
SELECT ename EMPLOYEE_NAME, sal SALARY, comm COMMISION FROM emp;
SELECT ename "EMPLOYEE NAME", sal SALARY, comm COMMISION FROM emp;	-- alias' use double quotes instead of single
SELECT ename "employee NAME", sal SALARY, comm COMMISION FROM emp;
SELECT ename AS "EMPLOYEE NAME", sal AS SALARY, comm AS COMMISION FROM emp; 	--use AS to match SQL standard and make easier to read
|| = concatination
SELECT 'Hello my name is ' || ename FROM emp;
SELECT 'Hello my name is ' || ename FROM emp WHERE job = 'MANAGER';
SELECT 'Hello my name is ' || ename AS "CONCATENATED VALUE" FROM emp WHERE job = 'MANAGER';

SELECT ename || ' makes $' || sal || ' per month' as "amount employee makes per month" FROM emp;

SELECT ename || ' makes $' || sal || ' per month' as "employee income"
FROM emp;

"ORDER BY "
SELECT ename, sal FROM emp;
SELECT ename, sal FROM emp order by ename;
SELECT ename, sal FROM emp order by sal;
SELECT ename, sal FROM emp order by sal desc;	-- order largest to smallest
SELECT ename, sal FROM emp order by sal asc;	-- order smallest to largest

SELECT deptno, sal, ename FROM emp;
SELECT deptno, sal, ename FROM emp order by deptno;
SELECT deptno, sal, ename FROM emp order by deptno, sal;

-- Assignment: Practice with single table queries


############################################
Instructor answers
############################################

Instructor Example
Imtiaz Ahmad
Write a query that retrieves suppliers that work in either Georgia or California.

SELECT *
FROM suppliers
WHERE state = 'Georgia'
OR state = 'California';
Write a query that retrieves suppliers with the characters "wo"  and the character "I" or "i" in their name.

SELECT *
FROM suppliers
WHERE supplier_name like '%wo%'
AND (supplier_name like '%i%' OR supplier_name like '%I%');
Write a query that retrieves suppliers on which a minimum of 37,000 and a maximum of 80,000 was spent.

SELECT *
FROM suppliers
WHERE total_spent >= 37000
AND total_spent <= 80000;
You may also use the BETWEEN operator to solve this problem.



Write a query that returns the supplier names and the state in which they operate meeting the following conditions:

belong in the state Georgia or Alaska
the supplier id is 100 or greater than 600
the amount spent is less than 100,000 or the amount spent is 220,000
SELECT supplier_name, state
FROM suppliers
WHERE state IN ('Georgia', 'Alaska')
AND supplier_id 100 OR supplier_id > 600
AND total_spent < 100000 OR total_spent = 220000;
TRUE or FALSE Question:

The keywords such as SELECT and WHERE must always be capital in the SQL Query.

FALSE

TRUE or FALSE Question:

The database works on first processing the filtering conditions and then processes the FROM condition.

FALSE

TRUE or FALSE Question:

Having just the filter condition shown below in a SQL query will return all of the records FROM the table.

WHERE 1 = 1



TRUE

Explanation: A 1=1 in a filter condition will always evaluate to true. If there are no other filter conditions in a SQL query, all records will be returned. 1=1 will always evaluate to true.

TRUE or FALSE question:

NULL can not be compared using an equal sign.

TRUE

TRUE or FALSE question:

The ORDER BY clause is processed before the FROM clause in a SQL statement and it's used to sort the columns in an ascending or descending fashion.

FALSE.

Explanation: The ORDER BY Clause is not processed before the FROM clause. In-fact it's one of the last clauses processed by the database query engine.

############################################
My Answers
############################################

Your Submission
ML
Michael Litsey
Posted 3 minutes ago
Write a query that retrieves suppliers that work in either Georgia or California.

SELECT *

FROM suppliers

WHERE STATE = 'Georgia'

or STATE = 'California';

Write a query that retrieves suppliers with the characters "wo"  and the character "I" or "i" in their name.

SELECT *

FROM suppliers

WHERE supplier_id like '%wo%'

and ( supplier_id like '%I%'

or supplier_id like '%i%');

Write a query that retrieves suppliers on which a minimum of 37,000 and a maximum of 80,000 was spent.

SELECT *

FROM suppliers

WHERE total_spent between 37000 and 80000;

Write a query that returns the supplier names and the state in which they operate meeting the following conditions:

belong in the state Georgia or Alaska
the supplier id is 100 or greater than 600
the amount spent is less than 100,000 or the amount spent is 220,000
SELECT *

FROM suppliers

WHERE (STATE = 'Georgia' or STATE = 'California')

and (supplier_id =100 or supplier_id > 600)

and (total_spent < 100000 or total_spent = 220000);



TRUE or FALSE Question:

The keywords such as SELECT and WHERE must always be capital in the SQL Query.

false

TRUE or FALSE Question:

"The database works on first processing the filtering conditions and then processes the FROM condition. "

false

TRUE or FALSE Question:

Having just the filter condition shown below in a SQL query will return all of the records FROM the table.

WHERE 1 = 1



false

TRUE or FALSE question:

NULL can not be compared using an equal sign.

ture

TRUE or FALSE question:

The ORDER BY clause is processed before the FROM clause in a SQL statement and it's used to sort the columns in an ascending or descending fashion. '

false

############################################

############################################
-- Single row functions (SRF) and using the DUAL table
############################################

CONCAT('Hello ', 'There') 	-- concat function

SELECT 'my name is ' || ename FROM emp;
SELECT concat('my name is ', ename) FROM emp;
SELECT concat('my name is ', ename) as sentence FROM emp;

UPPER('hello') 	-- upper function

SELECT upper('hello') FROM emp;
upper('hello') 	-- won't work because always need a SELECT and FROM in the statement
SELECT upper('hello') FROM dept;

			-- test functions using the DUAL table
SELECT upper('hello') FROM DUAL;
SELECT LOWER('HELLO') FROM DUAL;
SELECT * FROM DUAL;
SELECT 'pizza' FROM dual;
SELECT 'pizza' as food FROM dual;
SELECT 'pizza' as food, 'fanta' FROM dual;
SELECT 'pizza' as food, 'fanta' as drink FROM dual;
SELECT 'pizza' as food, 'fanta' as drink concat('hello', ' John') FROM dual;
SELECT 'pizza' as food, 'fanta' as drink concat('hello', ' John') as "This is a func" FROM dual;

SELECT lower(ename) FROM emp;
SELECT concat(lower(ename), ' is the name') FROM emp;
SELECT concat(lower(ename), ' is the name') FROM emp WHERE deptno = 20;
SELECT concat(lower(ename), upper(' is the name')) FROM emp WHERE deptno = 20;
SELECT concat(lower(ename), upper(' is the name')) || concat(' and their job is: ', job) FROM emp WHERE deptno = 20;
SELECT concat( concat(lower(ename), upper(' is the name')), concat(' and their job is: ', job)) FROM emp WHERE deptno = 20;
SELECT concat( concat(lower(ename), upper(' is the name')), concat(' and their job is: ', job)) as "function call" FROM emp WHERE deptno = 20;

############################################
-- Using functions in WHERE and Character based SRFs
############################################

SELECT * FROM emp WHERE lower(ename) = 'martin'
SELECT * FROM emp WHERE job = lower('MANAGER'); -- NO DATA FOUND
SELECT * FROM emp WHERE job = upper('MANAGER');
SELECT * FROM emp WHERE job = upper('manager');

INITCAP('hello there') = Hello There
SELECT initcap('hello my name is michael') FROM dual;
SELECT initcap('hello my name is michael') as sentence FROM dual;

LENGTH('Tiger') = 5
SELECT length('hello my name is michael') as length FROM dual;
SELECT length(ename) as length FROM emp;
SELECT ename, length(ename) as length FROM emp;
SELECT ename, length(ename) as length FROM emp WHERE length(ename) = 6;

SUBSTR('Hello', 2, 3) = ell	-- function(string, starting position, # of characters to extract)
SELECT substr('hello', 2, 2) FROM dual;
SELECT 'hello', substr('hello', 2) FROM dual;	-- subtracts FROM second character to end of string
SELECT 'Hello my name is', substr('Hello my name is', 10) FROM dual;
SELECT 'Hello my name is', substr('Hello my name is', 10, 5) FROM dual;
SELECT 'Hello my name is', length(substr('Hello my name is', 10, 5)) FROM dual;

LPAD('Day',6,'$') = '$$$Day'	-- adds characters to the left side of string
LPAD('Day',6) = '   Day'	-- function(string, total length of string after adding characters, character to add)
SELECT lpad('hello', 10, '&') FROM dual;
SELECT lpad('hello', 100, '&') FROM dual;
SELECT rpad('hello', 100, '&') FROM dual;	-- adds to the right
LTRIM	-- removes extra characters FROM left
SELECT ltrim('hello', 'h') FROM dual;
SELECT ltrim('hellohhhhhhhh', 'h') FROM dual;
RTRIM 	-- removes extra characters FROM right
SELECT rtrim('hellohhhhhhh', 'h') FROM dual;

############################################
Numeric and Date Data type SRFs
############################################

ROUND(100.346, 2) = 100.35 	-- FUNCTION(NUMBER, DIGITIS AFTER DECIMAL)
SELECT round(107.088, 2) FROM dual;
SELECT round(107.088, 3) FROM dual;
SELECT round(107.0887, 3) FROM dual;
SELECT round(107.0887) FROM dual;	-- gives whole number
SELECT round(107.9) FROM dual;

TRUNC(100.887, 2) = 100.88 	-- function(number, digits to leave after decimal) does not round up or down just drops extra digits
SELECT trunc(107.98947283472390) FROM dual; 	-- drops to whole number
SELECT trunc(107.98947283472390, 3) FROM dual;

SYSDATE
SELECT sysdate FROM dual;

SYSTIMESTAMP
SELECT systimestamp FROM dual;

ADD_MONTHS('7/13/2014', 8) 	-- FUNCTION(DATE, MONTHS TO ADD TO GIVEN DATE)
SELECT add_months('11/17/2012', 3) FROM dual;
SELECT add_months('11/17/2012', -3) FROM dual;
SELECT add_months('11/17/2012', +3) FROM dual;
SELECT add_months('11/17/2012', +100) FROM dual;

MONTHS_BETWEEN(dateA, dateB)
SELECT months_between('12/15/2012', '12/4/2013') FROM dual;
SELECT months_between('12/4/2013', '12/15/2012') FROM dual;
SELECT months_between('12/4/2013', '12/4/2012') FROM dual;

TRUNC(date, 'MONTH')
SELECT trunc(systimestamp) FROM dual;
SELECT systimestamp FROM dual;
SELECT trunc(systimestamp, 'MONTH') FROM dual;
SELECT trunc(systimestamp, 'YEAR') FROM dual;
SELECT trunc(hiredate, 'MONTH') FROM emp;
SELECT hiredate, trunc(hiredate, 'MONTH') FROM emp;
SELECT ename, hiredate, trunc(hiredate, 'MONTH') FROM emp;
SELECT ename, hiredate, trunc(hiredate, 'MONTH') FROM emp WHERE trunc(hiredate, 'YEAR') = '01/01/1982';

############################################
CONVERSION SRFs AND DATE FORMATTING
############################################

TO_CHAR(sysdate, 'Month DD, YYYY') = May 31, 2016
TO_CHAR(123, '$999.99') = $123.00
SELECT sysdate FROM dual;
SELECT to_char(sysdate, 'yyyy-mm-dd') FROM dual;
SELECT to_char(sysdate, 'yyyy/mm/dd') FROM dual;
SELECT to_char(sysdate, 'ddth "of" month, yyyy') FROM dual;
SELECT to_char(sysdate, 'ddth "of" Month, yyyy') FROM dual;
SELECT to_char(sal, '$999,999.99') FROM emp;
SELECT ename, sal, to_char(sal, '$999,999.99') as salaries FROM emp;

TO_DATE('str', 'fmt')
SELECT to_date('2012-08-27', 'yyyy-mm-dd') FROM dual;
SELECT add_months(to_date('2012-08-27', 'yyyy-mm-dd'), 2) FROM dual;
SELECT to_char(to_date('2012-08-27', 'yyyy-mm-dd'), 'yyyy-mm-dd') FROM dual;
SELECT to_date('3 of June, 2012', 'dd "of" Month, YYYY') FROM dual;

LAST_DAY(d)
"last_day is a date function that requires a date as an argument.
It returns the last day of the month in which the given date falls.
The argument is required for this function to work properly."

NEXT_DAY(d, c)
"The first argument is the date and the second argument is a text reference to a day of the week.
Both arguments are required for this function to work properly.
This function returns a valid date representing the first occurrence of the c day following the date represented in d. "

############################################
Concluding SRFs and NULL / NULLIF FUNCTIONs
############################################

SELECT ename, job, sal, comm FROM emp WHERE empno in (7839, 7698, 7566, 7654);
SELECT ename, job, sal, NVL(comm, 0) FROM emp WHERE empno in (7839, 7698, 7566, 7654);
SELECT ename, job, sal, NVL(comm, 'No Data Found') FROM emp WHERE empno in (7839, 7698, 7566, 7654);
SELECT ename, job, sal, to_char(comm) FROM emp WHERE empno in (7839, 7698, 7566, 7654);
SELECT ename, job, sal, nvl(to_char(comm), 'No data found') FROM emp WHERE empno in (7839, 7698, 7566, 7654);
SELECT ename, job, sal, nvl(to_char(comm), 'No data found') as Commission FROM emp WHERE empno in (7839, 7698, 7566, 7654);

NULLIF(arg1, arg2)
SELECT ename, length(ename) FROM emp;
SELECT ename, length(ename), nullif(length(ename), 5) FROM emp;
SELECT ename, length(ename), nvl(nullif(length(ename), 5)), 'length equal to 5') FROM emp;
SELECT ename, length(ename), nvl(nullif(to_char(length(ename)), to_char(5)), 'length is 5') FROM emp;
SELECT ename, length(ename), nvl(to_char(nullif(length(ename)), 5)), 'length equal to 5') FROM emp;     -- method i figured out
SELECT ename, length(ename), nvl(to_char(nullif(length(ename)), 5)), 'length equal to 5') FROM emp WHERE sal > 2000;
SELECT ename, length(ename), nvl(to_char(nullif(length(ename)), 5)), 'length equal to 5'), sal FROM emp WHERE sal > 2000;
SELECT ename, length(ename), nvl(to_char(nullif(length(ename)), 5)), 'length equal to 5') as Result, sal FROM emp WHERE sal > 2000;

############################################
Assignment 2: Practice with Single Row Functions
############################################

Questions for this Assignment

1. Considering the data exists in the city table, write a query that will return records similar to what is shown below for those cities that have the COUNTRYCODE of 'cbd' :

"NEW YORK CITY has the population of 8,500,000"

"LOS ANGELES has the population of 632,000"

Note: I would like you to use functions in the SELECT statement to solve this problem.

SELECT * FROM city;
SELECT name, population FROM city;
SELECT name, 'has the population of ', population FROM city;
SELECT concat(name, concat(' has the population of ', to_char(population, '999,999,999'))) as Population FROM city; -- answer
SELECT concat(name, concat(' has the population of ', to_char(population, '999,999,999'))) as Population FROM city WHERE countrycode = 'cbd';

2. Write a query that would show the first three letters and the last three letters of the DISTRICT capitalized and separated by a dash.

Note: I would like you to use functions in the SELECT statement to solve this problem.

SELECT district FROM city;
SELECT upper(district) as District FROM city;
SELECT substr(upper(district), 1, 3) as District FROM city;
SELECT upper(substr(district, -3)) as District FROM city;
SELECT upper(substr(district, 1, 3)) || '-' || upper(substr(district, -3)) as District FROM city; -- answer


3. Review the following SQL statement:

SELECT MONTHS_BETWEEN(LAST_DAY('15-JAN-12') + 1, '01-APR-12') FROM DUAL;

Considering the database is configured for the given date format, what will be the result of executing the query?
-2
SELECT months_between(last_day(to_date('15-jan-12', 'dd-Mon-yy')) +1, to_date('01-apr-12', 'dd-Mon-yy')) FROM DUAL;

4. TRUE or FALSE Question:

Giving the date arguments in chronological order to the MONTHS_BETWEEN function will result in an error.
FALSE

5. Which of the following is true regarding character functions?

A). They always accept characters as parameters and nothing else.
B). They always return a character value.   -- answer
C). They are generally used to process text data.
D). They generally have the letters CHAR someWHERE in the function name.

6. Which of the following is true regarding functions in SQL?

A). They never return a value.
B). They often return a value.
C). They always return a value.
D). There is no consistent answer to whether they return a value or not.

7. Review the SQL Statement:

SELECT SUBSTR('2009', 1, 2) || LTRIM('1124', '1') FROM DUAL;

What will be the result of executing the SQL Statement?

A). 2024    -- this is the answer
B). 221
C). 20124
D). A syntax error

8. TRUE or FALSE Question:

Review the syntax of how the NULLIF function is used:

NULLIF( expr1, expr2 )
The NULLIF function returns expr1 if expr1 and expr2 are not equal. -- FALSE

9. TRUE or FALSE Question:

The TO_CHAR function converts data FROM various data types to character data. It can accept characters, a number or a date as valid arguments.

############################################
Answer key
############################################
Instructor Example
Imtiaz Ahmad
Considering the data exists in the city table, write a query that will return records similar to what is shown below for those cities that have the COUNTRYCODE of 'cbd' :

"NEW YORK CITY has the population of 8,500,000"

"LOS ANGELES has the population of 632,000"

Note: I'd like you to use functions in the SELECT statement to solve this problem.

SELECT CONCAT(CONCAT(UPPER(name), ' has the population of '), population)
FROM city
WHERE LOWER(countrycode) = 'cbd';
Write a query that would show the first three letters and the last three letters of the DISTRICT capitalized and separated by a dash.

Note: I'd like you to use functions in the SELECT statement to solve this problem.



SELECT CONCAT(CONCAT(UPPER(SUBSTR(district, 1, 3)), ' - '),
       UPPER(SUBSTR(district, LENGTH(district) - 2)))
FROM city;
Review the following SQL statement:

SELECT MONTHS_BETWEEN(LAST_DAY('15-JAN-12') + 1, '01-APR-12') FROM DUAL;

Considering the database is configured for the given date format, what will be the result of executing the query?



-2

The reason -2 will be returned is that the LAST_DAY function will transform the value of '15-JAN-12' TO '31-JAN-12' and then the result of that will be added to 1. So the first argument of the MONTHS_BETWEEN function ends up being '01-FEB-12'. Difference between the 2 dates results in a -2.

TRUE or FALSE Question:

Giving the date arguments in chronological order to the MONTHS_BETWEEN function will result in an error.

FALSE.

You may give the 2 dates in any order you please. If the dates are in chronological order, the result will be a negative number. If the dates are in reverse chronological order, the answer will be a positive number.

Which of the following is true regarding character functions?

A). They always accept characters as parameters and nothing else.

B). They always return a character value.

C). They are generally used to process text data.

D). They generally have the letters CHAR someWHERE in the function name.

Answer: C

Which of the following is true regarding functions in SQL?

A). They never return a value.

B). They often return a value.

C). They always return a value.

D). There is no consistent answer to whether they return a value or not.

Answer: C.

Review the SQL Statement:

SELECT SUBSTR('2009', 1, 2) || LTRIM('1124', '1') FROM DUAL;

What will be the result of executing the SQL Statement?

A). 2024

B). 221

C). 20124

D). A syntax error

Answer: A.

TRUE or FALSE Question:

Review the syntax of how the NULLIF function is used:

NULLIF( expr1, expr2 )
The NULLIF function returns expr1 if expr1 and expr2 are not equal.

TRUE.



TRUE or FALSE Question:

The TO_CHAR function converts data FROM various data types to character data. It can accept characters, a number or a date as valid arguments.

TRUE.

Your Submission
ML
Michael Litsey
Posted a minute ago
Considering the data exists in the city table, write a query that will return records similar to what is shown below for those cities that have the COUNTRYCODE of 'cbd' :

"NEW YORK CITY has the population of 8,500,000"

"LOS ANGELES has the population of 632,000"

Note: I'd like you to use functions in the SELECT statement to solve this problem.

SELECT concat(name, concat(' has the population of ', to_char(population, '999,999,999'))) as Population FROM city;

Write a query that would show the first three letters and the last three letters of the DISTRICT capitalized and separated by a dash.

Note: I'd like you to use functions in the SELECT statement to solve this problem.



SELECT upper(substr(district, 1, 3)) || '-' || upper(substr(district, -3)) as District FROM city;

Review the following SQL statement:

SELECT MONTHS_BETWEEN(LAST_DAY('15-JAN-12') + 1, '01-APR-12') FROM DUAL;

Considering the database is configured for the given date format, what will be the result of executing the query?



-2 would be the answer if it runs correctly, but i keep getting invalid month.

i changed the code to this for it to work in Apex.

SELECT months_between(last_day(to_date('15-jan-12', 'dd-Mon-yy')) +1, to_date('01-apr-12', 'dd-Mon-yy')) FROM DUAL;

TRUE or FALSE Question:

Giving the date arguments in chronological order to the MONTHS_BETWEEN function will result in an error.

false, it will be a negative number

Which of the following is true regarding character functions?

A). They always accept characters as parameters and nothing else.

B). They always return a character value.

C). They are generally used to process text data.

D). They generally have the letters CHAR someWHERE in the function name.

B). They always return a character value.

Which of the following is true regarding functions in SQL?

A). They never return a value.

B). They often return a value.

C). They always return a value.

D). There is no consistent answer to whether they return a value or not.

D). There is no consistent answer to whether they return a value or not.

Review the SQL Statement:

SELECT SUBSTR('2009', 1, 2) || LTRIM('1124', '1') FROM DUAL;

What will be the result of executing the SQL Statement?

A). 2024

B). 221

C). 20124

D). A syntax error

A). 2024

TRUE or FALSE Question:

Review the syntax of how the NULLIF function is used:

NULLIF( expr1, expr2 )
The NULLIF function returns expr1 if expr1 and expr2 are not equal.

FALSE, it compares the 2 expressions and if they are the same returns null

TRUE or FALSE Question:

The TO_CHAR function converts data FROM various data types to character data. It can accept characters, a number or a date as valid arguments.

false, it accepts numbers and dates to convert to a string

############################################
Grouping FUNCTIONs, MIN, MAX, AVG, COUNT, ETC.
############################################

SELECT * FROM emp;
SELECT max(sal) as max_sal FROM emp;
SELECT min(sal) as min_sal FROM emp;
SELECT sum(sal) as sum_sal FROM emp;

SELECT max(sal) as max_manager FROM emp WHERE LOWER(job) LIKE '%MANAGER%';

SELECT avg(sal) as avg_sal FROM emp;
SELECT count(ename) as count FROM emp;
SELECT count(empno) as count FROM emp;
SELECT count(*) as count FROM emp;
SELECT count(comm) as count FROM emp;

SELECT sum(sal) / count(*) FROM emp;
SELECT sum(sal) / count(*) as computed_avg, avg(sal) as native_avg FROM emp;
SELECT sum(sal) as sum, avg(sal) as avg, max(sal) as max, min(sal) as min, count(*) FROM emp;
SELECT avg(sal) FROM emp WHERE job like 'CLERK';
SELECT avg(sal) FROM emp WHERE job like 'SALESMAN';
SELECT avg(sal) FROM emp WHERE job like 'MANAGER';

############################################
GROUP BY clause & HAVING clause
############################################

SELECT avg(sal), job FROM emp group by job;
SELECT to_char(avg(sal), '$999,999.99') as avg_sal, job FROM emp group by job;
SELECT job FROM emp group by job;
SELECT job FROM emp;
SELECT count(*), job FROM emp group by job;
SELECT to_char(min(sal), '$999,999.99') as avg_sal, job FROM emp group by job;
SELECT distinct job FROM emp;

SELECT count(*), job
FROM emp
-- WHERE count(*) = 2 	"the -- comments out the line"
group by job;

SELECT count(*), job FROM emp WHERE count(*) = 2 group by job;

SELECT count(*), job
FROM emp
group by job
having count(*) = 2;

-- syntax order for single table

SELECT
FROM
WHERE -- single row
and / or
group by -- multi row
having -- multi row
and / or
order by

-- end of syntax order


SELECT count(*), deptno FROM emp group by deptno having count(*) > 3;

############################################
more practice with Group by clause
############################################

SELECT job, count(*) FROM emp group by job;
SELECT job, count(*) FROM emp group by job, deptno;
SELECT job, deptno FROM emp;
SELECT job, deptno, count(*) FROM emp group by job, deptno;

SELECT col_1, col_2, col_3, group_function(aggregate_expression)
FROM tables
[ WHERE conditions ]
group by col_1, col_2, col_3, ... col_n
[ order by conditions ]

############################################
SELECT within SELECT (nested queries / subqueries)
############################################

SELECT * FROM dept;
SELECT * FROM dept WHERE deptno = 30;
SELECT * FROM dept WHERE deptno = (SELECT deptno FROM dept WHERE deptno = 30);
SELECT * FROM dept WHERE deptno < (SELECT deptno FROM dept WHERE deptno = 30);
SELECT * FROM dept WHERE deptno < (SELECT deptno FROM dept WHERE deptno = 30) and dname = 'ACCOUNTING';
SELECT * FROM ( SELECT * FROM dept);
SELECT * FROM ( SELECT * FROM emp);
SELECT * FROM emp WHERE deptno = (SELECT deptno FROM dept WHERE loc = 'CHICAGO');
SELECT * FROM emp WHERE deptno = (SELECT deptno FROM dept);
SELECT * FROM emp WHERE deptno = (SELECT deptno FROM dept WHERE DEPTNO IN (10,20));
SELECT * FROM emp WHERE deptno in (SELECT deptno FROM dept WHERE DEPTNO IN (10,20));
SELECT * FROM emp WHERE deptno in (SELECT deptno, loc, dname FROM dept WHERE DEPTNO IN (10,20)); -- error

SELECT job, ename, (SELECT job FROM emp) FROM emp; -- error
SELECT job, ename, (SELECT job FROM emp WHERE ename = 'KING') FROM emp;
SELECT job, ename, (SELECT 'Hello' FROM emp ) FROM emp; --error
SELECT job, ename, (SELECT * FROM dual ) FROM emp;
SELECT job, ename, (SELECT 'Hello there' FROM dual ) FROM emp;
SELECT job, ename, (SELECT 'Hello there' FROM dual ) FROM emp WHERE job = (SELECT job FROM emp);	--ERROR
SELECT job, ename, (SELECT 'Hello there' FROM dual ) FROM emp WHERE job = (SELECT job FROM emp WHERE job = 'PRESIDENT');

############################################
Relating tables together using JOIN
############################################

SELECT * FROM emp;
SELECT * FROM dept;
SELECT * FROM emp, dept WHERE emp.deptno = dept.deptno;
SELECT * FROM emp, dept WHERE emp.deptno = dept.deptno and loc = 'DALLAS';
SELECT * FROM emp, dept WHERE emp.deptno = dept.deptno and dept.loc = 'DALLAS';
SELECT emp.ename, emp.job, emp.sal FROM emp, dept WHERE emp.deptno = dept.deptno and dept.loc = 'DALLAS';
SELECT emp.ename, emp.job, emp.sal FROM emp, dept WHERE deptno = deptno and dept.loc = 'DALLAS';	-- ERROR
SELECT ename, job, sal FROM emp, dept WHERE emp.deptno = dept.deptno and loc = 'DALLAS'; 	-- works but not explicit (EIBTI)
SELECT ename AS first_name, job, sal FROM emp, dept WHERE emp.deptno = dept.deptno and loc = 'DALLAS';
SELECT ename AS first_name, job, sal FROM emp e, dept d WHERE emp.deptno = dept.deptno and loc = 'DALLAS';	-- ERROR
SELECT ename AS first_name, job, sal FROM emp e, dept d WHERE e.deptno = d.deptno and loc = 'DALLAS';
SELECT EMP.ename AS first_name, job, sal FROM emp e, dept d WHERE e.deptno = d.deptno and loc = 'DALLAS';	--ERROR
SELECT e.ename AS first_name, job, sal FROM emp e, dept d WHERE e.deptno = d.deptno and loc = 'DALLAS';
SELECT e.ename AS first_name, job, sal FROM (SELECT * FROM emp) e, dept d WHERE e.deptno = d.deptno and loc = 'DALLAS';
SELECT e.ename AS first_name, job, sal FROM (SELECT * FROM emp) e, (SELECT * FROM dept) d WHERE e.deptno = d.deptno and loc = 'DALLAS';
SELECT e.ename AS first_name, job, sal, e.deptno FROM (SELECT * FROM emp WHERE job in ('MANAGER', 'CLERK')) e, (SELECT * FROM dept) d WHERE e.deptno = d.deptno and loc = 'DALLAS';
SELECT e.ename AS first_name, job, sal, e.deptno FROM (SELECT * FROM emp WHERE job in ('MANAGER', 'CLERK')) e, (SELECT * FROM dept WHERE loc = 'DALLAS') d WHERE e.deptno = d.deptno;

#######################################################################
#21 Joins continued INNER & OUTER Joins
#######################################################################

SELECT * FROM emp, dept WHERE emp.deptno = dept.deptno;
SELECT * FROM dept; 	-- notice deptno 40 doesnt' show up in above query

INNER JOIN = join on common values

SELECT * FROM emp INNER JOIN dept ON emp.deptno = dept.deptno;
SELECT * FROM emp RIGHT JOIN dept ON emp.deptno = dept.deptno;

RIGHT JOIN = give all data FROM table on the right and only those that match FROM the left

SELECT * FROM emp LEFT JOIN dept ON emp.deptno = dept.deptno;

LEFT JOIN = give all data FROM table on the left and only those that match FROM the right

SELECT * FROM dept LEFT JOIN emp ON emp.deptno = dept.deptno;	-- switches the order of output and what is displayed
SELECT * FROM dept RIGHT JOIN emp ON emp.deptno = dept.deptno;
SELECT * FROM dept RIGHT OUTER JOIN emp ON emp.deptno = dept.deptno;
SELECT * FROM dept LEFT OUTER JOIN emp ON emp.deptno = dept.deptno;
SELECT * FROM emp, dept WHERE emp.deptno = dept.deptno; 	-- this is an inner join
SELECT * FROM emp, dept WHERE emp.deptno(+) = dept.deptno; 	-- this is a right outer join only works in oracle
SELECT * FROM emp, dept WHERE emp.deptno = dept.deptno(+); 	-- this is a left outer join only works in oracle

FULL OUTER JOIN = shows all data FROM both tables, including null values

SELECT * FROM dept FULL OUTER JOIN emp ON emp.deptno = dept.deptno;
SELECT * FROM emp FULL OUTER JOIN dept ON emp.deptno = dept.deptno;
SELECT * FROM (SELECT * FROM emp) FULL OUTER JOIN dept ON emp.deptno = dept.deptno; 	-- ERROR
SELECT * FROM (SELECT * FROM emp) AS emp FULL OUTER JOIN dept ON emp.deptno = dept.deptno; 	-- ERROR
SELECT * FROM (SELECT * FROM emp) emp FULL OUTER JOIN dept ON emp.deptno = dept.deptno;
SELECT * FROM (SELECT * FROM emp) e FULL OUTER JOIN dept ON e.deptno = dept.deptno;
SELECT * FROM (SELECT * FROM emp) e FULL OUTER JOIN (SELECT * FROM dept) d ON e.deptno = d.deptno;
SELECT * FROM (SELECT * FROM emp) e, (SELECT * FROM dept) d WHERE e.deptno = d.deptno;
SELECT * FROM (SELECT * FROM emp WHERE job = 'SALESMAN') e FULL OUTER JOIN dept ON e.deptno = dept.deptno;
SELECT * FROM (SELECT * FROM emp WHERE job = 'SALESMAN') e LEFT OUTER JOIN dept ON e.deptno = dept.deptno;

#######################################################################
#22 More Joins With Correlated Subqueries
#######################################################################

SELECT * FROM (SELECT * FROM dept LEFT OUTER JOIN (SELECT * FROM emp WHERE job = 'SALESMAN') e ON e.deptno = dept.deptno);
SELECT empno, ename, job, mgr, hiredate, sal, comm, emp_deptno, dept_deptno, dname, loc FROM (SELECT empno, ename, job, mgr, hiredate, sal, comm, e.deptno as emp_deptno, d.deptno as dept_deptno, dname, loc FROM (SELECT * FROM dept) d LEFT OUTER JOIN (SELECT * FROM emp WHERE job = 'SALESMAN') e ON e.deptno = d.deptno);
SELECT empno, ename, job, mgr, hiredate, sal, comm, emp_deptno as deptno, dept_deptno as deptno, dname, loc FROM (SELECT empno, ename, job, mgr, hiredate, sal, comm, e.deptno as emp_deptno, d.deptno as dept_deptno, dname, loc FROM (SELECT * FROM dept) d LEFT OUTER JOIN (SELECT * FROM emp WHERE job = 'SALESMAN') e ON e.deptno = d.deptno);
SELECT empno, ename, job, mgr, hiredate, sal, comm, e.deptno as deptno, d.deptno as deptno, dname, loc FROM (SELECT * FROM dept) d LEFT OUTER JOIN (SELECT * FROM emp WHERE job = 'SALESMAN') e ON e.deptno = d.deptno;
SELECT e.*, d.deptno as deptno, dname, loc FROM (SELECT * FROM dept) d LEFT OUTER JOIN (SELECT * FROM emp WHERE job = 'SALESMAN') e ON e.deptno = d.deptno;
SELECT e.*, d.* FROM (SELECT * FROM dept) d LEFT OUTER JOIN (SELECT * FROM emp WHERE job = 'SALESMAN') e ON e.deptno = d.deptno;

EXISTS	-- not efficient, try not to run, best used with correlated subqueries
WHERE EXISTS (SELECT * FROM ......)

SELECT * FROM emp WHERE EXISTS (SELECT 'random' FROM dual);
SELECT * FROM emp WHERE NOT EXISTS (SELECT 'random' FROM dual);
SELECT * FROM emp WHERE EXISTS (SELECT null FROM dual);
SELECT * FROM emp WHERE EXISTS (SELECT * FROM emp WHERE job = 'PROGRAMMER');
SELECT * FROM emp WHERE NOT EXISTS (SELECT * FROM emp WHERE job = 'PROGRAMMER');

CORRELATED SUBQUERY
SELECT d.* FROM dept d WHERE EXISTS (SELECT * FROM emp WHERE d.deptno = emp.deptno);
SELECT d.* FROM dept d WHERE NOT EXISTS (SELECT * FROM emp WHERE d.deptno = emp.deptno);
SELECT d.*, emp.ename, emp.sal FROM dept d WHERE NOT EXISTS (SELECT * FROM emp WHERE d.deptno = emp.deptno); 	-- does not work, can't select data from subqueries
SELECT d.* FROM dept d WHERE NOT EXISTS (SELECT * FROM emp WHERE d.deptno = emp.deptno) AND loc = 'CHICAGO';
SELECT d.* FROM dept d WHERE EXISTS (SELECT * FROM emp WHERE d.deptno = emp.deptno) AND loc = 'CHICAGO';
SELECT d.* FROM dept d WHERE NOT EXISTS (SELECT * FROM emp WHERE d.deptno = emp.deptno) OR loc = 'CHICAGO';

#######################################################################
#23 Creating your own tables & design considerations
#######################################################################

CREATE TABLE stores
(
  store_id number not null,
  city varchar2(50)
);

#######################################################################
#24 Inserting data into our table
#######################################################################

INSERT INTO stores(store_id, city) VALUES (1,'San Francisco');
INSERT INTO stores(store_id, city) VALUES (2,'New York City');
INSERT INTO stores(store_id, city) VALUES (3,'Chicago');

INSERT ALL
  INTO stores(store_id, city) VALUES (4, 'Philadelphia')
  INTO stores(store_id, city) VALUES (5, 'Boston')
  INTO stores(store_id, city) VALUES (6, 'Seattle')
SELECT * FROM DUAL;

INSERT ALL
  INTO stores(store_id, city) VALUES (4, 'Philadelphia')
  INTO stores(store_id, city) VALUES (5, 'Boston')
  INTO stores(store_id, city) VALUES (6, 'Seattle')
SELECT * FROM DUAL;

INSERT ALL
  INTO stores(store_id, city) VALUES (4, 'Philadelphia')
  INTO stores(store_id, city) VALUES (5, 'Boston')
  INTO stores(store_id, city) VALUES (6, 'Seattle')
SELECT * FROM DUAL;

SELECT store_id, count(*) FROM stores group by store_id order by 1;

INSERT ALL
  INTO stores(store_id, city) VALUES (NULL, 'Philadelphia')
  INTO stores(store_id, city) VALUES (NULL, 'Boston')
  INTO stores(store_id, city) VALUES (NULL, 'Seattle')
SELECT * FROM DUAL;

#######################################################################
#25 create table with primary key constraint
#######################################################################

CREATE TABLE products
(
  product_id number not null,
  name varchar2(50),
  product_cost number(5,2),
  product_retail number(5,2),
  product_type varchar2(10),
  store_id number not null,
  CONSTRAINT product_pk PRIMARY KEY (product_id)
);

INSERT INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1001,'Colgate Toothpaste',2.25,5.47,'hygeine',2)
INSERT INTO products VALUES(1002,'Colgate Toothpaste',2.25,5.47,'hygeine',2)
INSERT INTO products VALUES(1003,'Listerine Mouthwash',1.75,4.81,'hygeine',3)

INSERT ALL
  INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1004,'T-Shirt',1.75,7.77,'Clothing',2)
  INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1005,'T-Shirt',1.65,7.85,'Clothing',2)
  INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1006,'T-Shirt',1.73,7.80,'Clothing',3)
  INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1007,'Shorts',0.73,5.60,'Clothing',3)
  INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1008,'Dress Shoes',17.85,87.67,'Clothing',2)
  INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1009,'Garden Chair',12.01,27.87,'Home & Gardening',2)
  INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1010,'Grass Fertilizer',3.20,8.70,'Home & Gardening',2)
SELECT * FROM DUAL;

SELECT * FROM products;

INSERT ALL
  INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1004,'T-Shirt',1.75,7.77,'Clothing',2)
  INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1005,'T-Shirt',1.65,7.85,'Clothing',2)
  INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1006,'T-Shirt',1.73,7.80,'Clothing',3)
  INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1007,'Shorts',0.73,5.60,'Clothing',3)
  INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1008,'Dress Shoes',17.85,87.67,'Clothing',2)
  INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1009,'Garden Chair',12.01,27.87,'Home & Gar',2)
  INTO products(product_id, name, product_cost, product_retail, product_type, store_id) VALUES(1010,'Grass Fertilizer',3.20,8.70,'Home & Gar',2)
SELECT * FROM DUAL;

#######################################################################
#26 alter table and modify column attributes
#######################################################################

SELECT * FROM products;
INSERT INTO products VALUES(1011,'',4.00,8.00,'Clothing',3);
DESCRIBE products;
ALTER TABLE products MODIFY name varchar2(50) not null;     -- ERROR
DELETE FROM products WHERE product_id = 1011;
ALTER TABLE products MODIFY name varchar2(50) not null;
DESCRIBE products;
INSERT INTO products VALUES(1011,'',4.00,8.00,'Clothing',3);    --ERROR
DESCRIBE product_pk;
ALTER TABLE products MODIFY (product_cost number(5,2) not null, product_retail number(5,2) not null);
DESCRIBE products;
ALTER TABLE products RENAME COLUMN name TO product_name;
select * from products;

#######################################################################
#27 create table with select & update existing data
#######################################################################

CREATE TABLE employees AS SELECT empno, ename, job, hiredate, sal, comm FROM emp;
SELECT * FROM employees;
DESCRIBE employees;
DESC emp;
ALTER TABLE employees ADD store_id number not null;     --ERROR
SELECT * FROM employees;
ALTER TABLE employees ADD store_id number;
SELECT * FROM employees;

UPDATE your_table SET <column> = <value> WHERE <some criteria>;

SELECT * FROM employees WHERE ename IN ('KING','BLAKE','CLARK');
UPDATE employees SET store_id = 3 WHERE ename IN ('KING','BLAKE','CLARK');
SELECT * FROM employees;
SALESMAN = 2
CLERK = 4
ANALYST = 4
JONES = 1
UPDATE employees SET store_id = 2 WHERE job = 'SALESMAN';
UPDATE employees SET store_id = 4 WHERE job = 'CLERK';
UPDATE employees SET store_id = 4 WHERE job = 'ANALYST';
UPDATE employees SET store_id = 1 WHERE ename = 'JONES';
SELECT * FROM employees;
ALTER TABLE employees MODIFY store_id number not null;
UPDATE employees SET store_id = null WHERE ename = 'JONES';     --ERROR

#######################################################################
#28 delete, truncate, & drop commands
#######################################################################

SELECT * FROM dept;
SELECT * FROM dept WHERE deptno = 40;
DELETE FROM dept WHERE deptno = 40;
DELETE FROM dept;   -- ERROR
SELECT * FROM emp;
ALTER TABLE emp DROP CONSTRAINT <constraint name>;
DROP TABLE dept;

SELECT * FROM emp;
TRUKNCATE TABLE emp;  -- eliminates all data in the table without dropping the table
SELECT * FROM emp;
SELECT * FROM dept;   -- ERROR
DROP TABLE emp;

#######################################################################
#29 Database Indexes
#######################################################################

CREATE [UNIQUE] INDEX index_name ON table_name (column1, column2...) [COMPUTE STATISTICS];

SELECT * FROM employees
CREATE INDEX emp_name_idx ON employees (ename);
SELECT * FROM employees WHERE ename = 'JOHN';
CREATE INDEX emp_name_job_date_idx ON employees(ename, job, hiredate);
SELECT * FROM employees WHERE ename = 'JOHN' AND hiredate = '' AND  job = '';

CREATE UNIQUE INDEX emp_job_idx ON employees(job);  -- ERROR
CREATE INDEX emp_job_idx ON employees(job);
DROP INDEX emp_job_idx;

DROP INDEX emp_name_job_date_idx;
CREATE INDEX emp_name_job_date_idx ON employees(ename, job, hiredate) COMPUTE STATISTICS;

ALTER INDEX emp_name_idx REBUILD COMPUTE STATISTICS;

SELECT * FROM stores;

-- Delete extra data, create primary key column on store_id, create unique index

#######################################################################
#30 System Tables, Pseudo Columns, & Deleting Duplicate Data
#######################################################################

SELECT * FROM stores;
SELECT store_id, city, count(*) FROM stores GROUP BY store_id, city ORDER BY count(*);

rowid -- Pseudo Column, can be used in any query

SELECT rowid, store_id, city FROM stores;
SELECT MIN(rowid) FROM stores GROUP BY store_id, city;
DELETE FROM stores WHERE rowid NOT IN (SELECT MIN(rowid) FROM stores GROUP BY store_id, city);
SELECT store_id, city, count(*) FROM stores GROUP BY store_id, city ORDER BY count(*);
ALTER TABLE stores ADD CONSTRAINT store_id_pk PRIMARY KEY (store_id);
CREATE UNIQUE INDEX store_id_idx ON stores(store_id) COMPUTE STATISTICS;  -- ERROR, already created when making primary key.

SELECT * FROM all_tables;
SELECT * FROM all_tables WHERE rownum < 10;
SELECT * FROM all_tables WHERE table_name = 'EMPLOYEES' AND rownum < 10;
SELECT * FROM all_tab_COLUMNS WHERE table_name = 'EMPLOYEES' AND rownum < 10;
SELECT * FROM all_tab_COLUMNS WHERE table_name = 'EMPLOYEES';
SELECT * FROM all_objects WHERE rownum < 50;
SELECT * FROM all_objects WHERE object_type = 'TABLE' AND rownum < 50;
SELECT * FROM all_objects WHERE object_type = 'INDEX' AND rownum < 50;
SELECT * FROM all_objects WHERE object_type = 'INDEX' AND lower(object_name) = 'emp_name_idx' AND rownum < 50;
SELECT * FROM user_tab_COLUMNS;

CREATE PUBLIC SYNONYM emp_table FOR employees;
CREATE SYNONYM emp_table FOR employees;
SELECT * FROM emp_table;
SELECT rownum, ename, sal FROM employees;

#######################################################################
#31 Other objects & commands views union/all etc.
#######################################################################

SELECT * FROM employees WHERE job = 'MANAGER';
CREATE VIEW managers_v AS SELECT * FROM employees WHERE job = 'MANAGER';
SELECT * FROM managers_v;
SELECT * FROM user_objects WHERE object_type = 'VIEW';
SELECT * FROM all_objects WHERE owner = 'SQL_TRAINING' AND object_type = 'TABLE';
SELECT * FROM all_objects WHERE object_type = 'VIEW' and rownum < 10;
SELECT * FROM sys.v_$version;
-- DROP VIEW managers_v;

query that gives highest paid in each store then make it a view

SELECT store_id, max(sal) sal FROM employees GROUP BY store_id;
select * from employees e1 INNER JOIN (SELECT store_id, max(sal) sal FROM employees GROUP BY store_id) e2 ON e1.store_id = e2.store_id AND e1.sal = e2.sal;
select * from employees e1 INNER JOIN (SELECT store_id, max(sal) sal FROM employees GROUP BY store_id) e2 ON e1.store_id = e2.store_id AND e1.sal = e2.sal WHERE ename != 'FORD';
CREATE VIEW super_employees AS select * from employees e1 INNER JOIN (SELECT store_id, max(sal) sal FROM employees GROUP BY store_id) e2 ON e1.store_id = e2.store_id AND e1.sal = e2.sal;
CREATE VIEW super_employees AS select e1.* from employees e1 INNER JOIN (SELECT store_id, max(sal) sal FROM employees GROUP BY store_id) e2 ON e1.store_id = e2.store_id AND e1.sal = e2.sal;
SELECT * FROM super_employees;

SELECT * FROM super_employees UNION SELECT * FROM employees;
UNION -- gets data from both tables but not duplicates, columns must match
SELECT * FROM super_employees UNION SELECT empno, ename, job, hiredate FROM employees;  -- ERROR
SELECT * FROM super_employees UNION ALL SELECT * FROM employees;  -- keeps duplicates

SELECT * FROM super_employees;
SELECT * FROM super_employees MINUS SELECT * FROM employees WHERE job = 'SALESMAN';
MINUS -- removes bottom query from top query

CREATE OR REPLACE VIEW super_employees AS select e1.* from employees e1 INNER JOIN (SELECT store_id, max(sal) sal FROM employees GROUP BY store_id) e2 ON e1.store_id = e2.store_id AND e1.sal = e2.sal WHERE ename != 'FORD';
DROP VIEW super_employees;
CREATE OR REPLACE VIEW super_employees AS select e1.* from employees e1 INNER JOIN (SELECT store_id, max(sal) sal FROM employees GROUP BY store_id) e2 ON e1.store_id = e2.store_id AND e1.sal = e2.sal WHERE ename != 'FORD';

#######################################################################
#32 Granting and Revoking Privileges
#######################################################################
