-- =========================================================
-- SNOWFLAKE DQL - JOINS
-- =========================================================

-- Step 1: Set context
USE WAREHOUSE tinitiatedev;
USE DATABASE tinitiate;
USE SCHEMA tinitiate.employees;

-- =========================================================
-- INNER JOIN
-- Returns only matching rows from both tables
-- =========================================================

-- Retrieve employee information along with department name
SELECT e.*, d.dname
FROM emp e
INNER JOIN dept d
    ON e.deptno = d.deptno;

-- =========================================================
-- LEFT JOIN (LEFT OUTER JOIN)
-- Returns all rows from the left table and matching rows
-- from the right table. Non-matches return NULLs.
-- =========================================================

-- Retrieve all employees along with department name,
-- including employees without a matching department
SELECT e.*, d.dname
FROM emp e
LEFT JOIN dept d
    ON e.deptno = d.deptno;

-- =========================================================
-- RIGHT JOIN (RIGHT OUTER JOIN)
-- Returns all rows from the right table and matching rows
-- from the left table. Non-matches return NULLs.
-- =========================================================

-- Retrieve all departments along with employee details,
-- including departments without employees
SELECT e.*, d.dname
FROM emp e
RIGHT JOIN dept d
    ON e.deptno = d.deptno;

-- =========================================================
-- FULL JOIN (FULL OUTER JOIN)
-- Returns all rows from both tables, including non-matches
-- =========================================================

-- Retrieve all employees and departments,
-- including unmatched rows on both sides
SELECT e.*, d.dname
FROM emp e
FULL JOIN dept d
    ON e.deptno = d.deptno;

-- =========================================================
-- CROSS JOIN
-- Returns all possible combinations of rows from both tables
-- =========================================================

-- Retrieve Cartesian product of employee and department tables
SELECT e.*, d.*
FROM emp e
CROSS JOIN dept d;