-- =========================================================
-- SNOWFLAKE DQL - AGGREGATE FUNCTIONS
-- =========================================================

-- Step 1: Set context
USE WAREHOUSE TINITIATEDEV;
USE DATABASE tinitiate;
USE SCHEMA tinitiate.employees;

-- =========================================================
-- COUNT
-- Counts rows in a result set
-- COUNT returns the number of rows in a dataset or within each group. 
-- It is useful for measuring record volume, department headcount, or year-wise hiring counts.
-- =========================================================

-- Count total employees
SELECT COUNT(*) AS total_employees
FROM emp;

-- Count employees in each department
SELECT deptno, COUNT(*) AS num_employees
FROM emp
GROUP BY deptno;

-- Count employees hired after 1980 in each department
-- and show only departments with more than 3 employees
SELECT deptno, COUNT(*) AS num_employees
FROM emp
WHERE YEAR(hiredate) > 1980
GROUP BY deptno
HAVING COUNT(*) > 3;

-- Count employees hired in each year
SELECT YEAR(hiredate) AS hire_year, COUNT(*) AS num_employees
FROM emp
GROUP BY YEAR(hiredate);

-- =========================================================
-- SUM
-- Calculates total of a numeric column
-- SUM calculates the total of numeric values such as salary or commission. 
-- It is often used for departmental budgeting and compensation analysis.
-- =========================================================

-- Total salary of all employees
SELECT SUM(sal) AS total_salary
FROM emp;

-- Total salary by department
SELECT deptno, SUM(sal) AS total_salary
FROM emp
GROUP BY deptno;

-- Total salary by department in descending order
SELECT deptno, SUM(sal) AS total_salary
FROM emp
GROUP BY deptno
ORDER BY total_salary DESC;

-- Total commission by department
SELECT deptno, SUM(commission) AS total_commission
FROM emp
GROUP BY deptno;

-- Departments with total commission greater than 500
SELECT deptno, SUM(commission) AS total_commission
FROM emp
GROUP BY deptno
HAVING SUM(commission) > 500
ORDER BY total_commission DESC;

-- =========================================================
-- AVG
-- Calculates average of a numeric column
-- AVG computes the mean value of a numeric column. 
-- It is commonly used to analyze average salary by role, department, or hiring period.
-- =========================================================

-- Average salary of all employees
SELECT AVG(sal) AS avg_salary
FROM emp;

-- Average salary by job
SELECT job, AVG(sal) AS avg_salary
FROM emp
GROUP BY job;

-- Average salary of employees hired after 1982
SELECT AVG(sal) AS avg_salary
FROM emp
WHERE YEAR(hiredate) > 1982;

-- Departments with average salary greater than 2500
SELECT deptno
FROM emp
GROUP BY deptno
HAVING AVG(sal) > 2500;

-- Job positions ordered by highest average salary
SELECT job, AVG(sal) AS avg_salary
FROM emp
GROUP BY job
ORDER BY avg_salary DESC;

-- =========================================================
-- MAX
-- Retrieves maximum value
-- MAX identify the highest values in a column. 
-- These are useful for finding top earners and salary ranges within each department
-- =========================================================

-- Highest salary overall
SELECT MAX(sal) AS max_salary
FROM emp;

-- Employee(s) with highest salary
SELECT *
FROM emp
WHERE sal = (SELECT MAX(sal) FROM emp);

-- Employee(s) with highest salary in each department
SELECT e.*
FROM emp e
JOIN (
    SELECT deptno, MAX(sal) AS max_salary
    FROM emp
    GROUP BY deptno
) AS max_salaries
    ON e.deptno = max_salaries.deptno
   AND e.sal = max_salaries.max_salary;

-- =========================================================
-- MIN
-- Retrieves minimum value
-- MIN identify the lowest values in a column. 
-- These are useful for finding lowest earners, and salary ranges within each department
-- =========================================================

-- Lowest salary overall
SELECT MIN(sal) AS min_salary
FROM emp;

-- Employee(s) with lowest non-null commission
SELECT *
FROM emp
WHERE commission = (
    SELECT MIN(commission)
    FROM emp
    WHERE commission IS NOT NULL
);

-- Employee(s) with lowest salary in each department
SELECT e.*
FROM emp e
JOIN (
    SELECT deptno, MIN(sal) AS min_salary
    FROM emp
    GROUP BY deptno
) AS min_salaries
    ON e.deptno = min_salaries.deptno
   AND e.sal = min_salaries.min_salary;

-- Department(s) with lowest average salary
SELECT dname, avg_salary
FROM (
    SELECT d.dname, AVG(e.sal) AS avg_salary
    FROM emp e
    JOIN dept d
      ON e.deptno = d.deptno
    GROUP BY d.dname
) AS dept_avg_salary
WHERE avg_salary = (
    SELECT MIN(avg_salary)
    FROM (
        SELECT AVG(sal) AS avg_salary
        FROM emp
        GROUP BY deptno
    ) AS dept_avg
);

-- =========================================================
-- MAX and MIN together
-- =========================================================

-- Highest and lowest salary in each department
SELECT deptno,
       MAX(sal) AS max_salary,
       MIN(sal) AS min_salary
FROM emp
GROUP BY deptno;