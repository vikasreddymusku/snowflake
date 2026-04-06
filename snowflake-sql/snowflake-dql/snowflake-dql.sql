-- =========================================================
-- SNOWFLAKE DQL SCRIPT
-- Based on the GitHub file you shared
-- =========================================================

-- Step 1: Set context
USE WAREHOUSE TINITIATEDEV;
USE DATABASE tinitiate;
USE SCHEMA tinitiate.employees;

-- =========================================================
-- SELECT STATEMENTS
-- =========================================================

-- Retrieve all columns from the EMP table
SELECT * 
FROM emp;

-- Retrieve specific columns from the EMP table
SELECT empno, ename, job
FROM emp;

-- Retrieve distinct job titles
SELECT DISTINCT job
FROM emp;

-- Retrieve distinct job titles with alias
SELECT DISTINCT job AS employeejob
FROM emp;

-- =========================================================
-- WHERE CLAUSE
-- =========================================================

-- Retrieve employees with job title = 'manager'
SELECT *
FROM emp
WHERE job = 'manager';

-- Retrieve employees hired after 1982-01-01
SELECT *
FROM emp
WHERE hiredate > '1982-01-01';

-- Retrieve employees with salary greater than 2000
SELECT *
FROM emp
WHERE sal > 2000;

-- =========================================================
-- GROUP BY CLAUSE
-- =========================================================

-- Calculate total salary by department
SELECT deptno, SUM(sal) AS total_salary
FROM emp
GROUP BY deptno;

-- Count employees by job title
SELECT job, COUNT(*) AS num_employees
FROM emp
GROUP BY job;

-- Calculate average commission by department
SELECT deptno, AVG(commission) AS avg_commission
FROM emp
GROUP BY deptno;

-- =========================================================
-- HAVING CLAUSE
-- =========================================================

-- Retrieve departments with more than 2 employees
SELECT deptno, COUNT(*) AS num_employees
FROM emp
GROUP BY deptno
HAVING COUNT(*) > 2;

-- Retrieve job titles with average salary greater than 2500
SELECT job, AVG(sal) AS avg_salary
FROM emp
GROUP BY job
HAVING AVG(sal) > 2500;

-- Retrieve departments where total salary exceeds 10000
SELECT deptno, SUM(sal) AS total_salary
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 10000;

-- =========================================================
-- ORDER BY CLAUSE
-- =========================================================

-- Retrieve employees sorted by salary descending
SELECT *
FROM emp
ORDER BY sal DESC;

-- Retrieve employees sorted by hire date ascending
SELECT *
FROM emp
ORDER BY hiredate ASC;

-- Retrieve employees sorted by dept ascending, salary descending
SELECT *
FROM emp
ORDER BY deptno ASC, sal DESC;

-- =========================================================
-- LIMIT
-- The LIMIT clause restricts the number of rows returned.
-- =========================================================

-- Retrieve first 5 employees
SELECT *
FROM emp
LIMIT 5;

-- Retrieve top 10 highest-paid employees
SELECT *
FROM emp
ORDER BY sal DESC
LIMIT 10;