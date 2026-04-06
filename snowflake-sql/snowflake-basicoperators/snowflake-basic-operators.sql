-- =========================================================
-- SNOWFLAKE DQL - BASIC OPERATORS
-- =========================================================

-- Step 1: Set context
USE WAREHOUSE TINITIATEDEV;
USE DATABASE tinitiate;
USE SCHEMA tinitiate.employees;

-- =========================================================
-- EQUALITY (=)
-- Filters rows where values are equal
-- Used to compare values in a column.
-- = retrieves matching records

-- =========================================================
SELECT *
FROM emp
WHERE job = 'manager';

-- =========================================================
-- INEQUALITY (<>)
-- Filters rows where values are not equal
-- <> retrieves non-matching records
-- =========================================================
SELECT *
FROM emp
WHERE job <> 'manager';

-- =========================================================
-- IN OPERATOR
-- Filters rows matching any value in a list
-- Used to filter records based on multiple values.
-- IN → includes values
-- =========================================================
SELECT *
FROM emp
WHERE deptno IN (10, 20);

-- =========================================================
-- NOT IN OPERATOR
-- Excludes rows matching values in a list
-- NOT IN → excludes values
-- =========================================================
SELECT *
FROM emp
WHERE deptno NOT IN (10, 20);

-- =========================================================
-- LIKE OPERATOR (Pattern Matching)
-- Used for pattern-based searching.
-- % → multiple characters
-- _ → single character
-- =========================================================

-- Starts with 'S'
SELECT * FROM emp WHERE ename LIKE 'S%';

-- Exactly 5 characters starting with 'S'
SELECT * FROM emp WHERE ename LIKE 'S____';

-- Second character is 'e'
SELECT * FROM emp WHERE ename LIKE '_e%';

-- Ends with 'd' (4-letter names)
SELECT * FROM emp WHERE ename LIKE '___d';

-- Contains 'a'
SELECT * FROM emp WHERE ename LIKE '%a%';

-- Pattern match (_a_es)
SELECT * FROM emp WHERE ename LIKE '_a_es';

-- =========================================================
-- NOT LIKE
-- =========================================================
SELECT *
FROM emp
WHERE ename NOT LIKE 'S%';

-- =========================================================
-- BETWEEN
-- Filters values within a range (inclusive)
-- =========================================================
SELECT *
FROM emp
WHERE hiredate BETWEEN '1982-01-01' AND '1983-01-01';

-- =========================================================
-- GREATER THAN (>)
-- =========================================================
SELECT *
FROM emp
WHERE sal > 2500;

-- =========================================================
-- GREATER THAN OR EQUAL (>=)
-- =========================================================
SELECT *
FROM emp
WHERE hiredate >= '1982-01-01';

-- =========================================================
-- LESS THAN (<)
-- =========================================================
SELECT *
FROM emp
WHERE sal < 1500;

-- =========================================================
-- LESS THAN OR EQUAL (<=)
-- =========================================================
SELECT *
FROM emp
WHERE hiredate <= '1982-01-01';

-- =========================================================
-- EXISTS
-- Checks if related records exist
-- =========================================================
SELECT *
FROM emp e
WHERE EXISTS (
    SELECT 1
    FROM emp_projects ep
    WHERE e.empno = ep.empno
);

-- =========================================================
-- NOT EXISTS
-- Checks if related records do NOT exist
-- =========================================================
SELECT *
FROM emp e
WHERE NOT EXISTS (
    SELECT 1
    FROM emp_projects ep
    WHERE e.empno = ep.empno
);