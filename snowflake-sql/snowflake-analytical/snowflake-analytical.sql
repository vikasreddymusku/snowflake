-- =========================================================
-- SNOWFLAKE DQL - ANALYTICAL FUNCTIONS
-- =========================================================

-- Step 1: Set context
USE WAREHOUSE TINITIATEDEV;
USE DATABASE tinitiate;
USE SCHEMA tinitiate.employees;

-- =========================================================
-- WINDOWED AGGREGATE FUNCTIONS
-- Aggregate functions such as MAX, MIN, SUM, AVG, and COUNT can also be used as analytical functions. 
-- This lets you show each employee row together with department-level totals, averages, and counts without collapsing the result set.
-- =========================================================

-- Regular aggregate summary by department
SELECT deptno,
       COUNT(sal) AS count_dept_sal,
       MAX(sal)   AS max_dept_sal,
       MIN(sal)   AS min_dept_sal,
       SUM(sal)   AS tot_dept_sal,
       AVG(sal)   AS avg_dept_sal
FROM emp e
GROUP BY deptno;

-- Aggregate functions as analytical functions over all rows / by department
SELECT e.*,
       MAX(sal) OVER ()                      AS max_sal,
       MAX(sal) OVER (PARTITION BY deptno)   AS max_dept_sal,
       MIN(sal) OVER (PARTITION BY deptno)   AS min_dept_sal,
       SUM(sal) OVER (PARTITION BY deptno)   AS tot_dept_sal,
       AVG(sal) OVER (PARTITION BY deptno)   AS avg_dept_sal,
       COUNT(1) OVER (PARTITION BY deptno)   AS emp_count_by_dept
FROM emp e;

-- =========================================================
-- ROW_NUMBER()
-- Assigns a unique sequential number
-- ROW_NUMBER() assigns a unique sequential number to each row, either across the full dataset or within a partition. 
-- It is commonly used to pick the top row in each group, such as the highest-paid employee in each department.
-- =========================================================

-- Row number across all employees
SELECT empno, ename,
       ROW_NUMBER() OVER (ORDER BY empno) AS row_num
FROM emp;

-- Row number within each department
SELECT empno, ename, deptno,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY empno) AS row_num
FROM emp;

-- Row number by salary within each department
SELECT deptno, ename, sal,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) AS row_num
FROM emp;

-- Highest salary employee in each department
SELECT deptno, ename, sal
FROM (
    SELECT deptno, ename, sal,
           ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) AS row_num
    FROM emp
) ranked
WHERE row_num = 1;

-- Multi-ordered row numbering
SELECT ROW_NUMBER() OVER (ORDER BY sal)      AS sal_rn_asc,
       ROW_NUMBER() OVER (ORDER BY sal DESC) AS sal_rn_desc,
       ROW_NUMBER() OVER (ORDER BY empno)    AS empno_rn,
       e.*
FROM emp e
ORDER BY deptno;

-- Multi-partitioned row numbering
SELECT ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal)      AS sal_rn_asc,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) AS sal_rn_desc,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY empno)    AS empno_rn,
       e.*
FROM emp e
ORDER BY deptno;

-- =========================================================
-- RANK()
-- Same rank for ties, with gaps
-- RANK() gives tied rows the same rank and leaves gaps after ties, while  
-- They are useful for salary rankings across the company or within each department.
-- =========================================================

SELECT ename, sal,
       RANK() OVER (ORDER BY sal DESC) AS rank
FROM emp;

SELECT deptno, ename, sal,
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS rank
FROM emp;

-- =========================================================
-- DENSE_RANK()
-- Same rank for ties, without gaps
-- DENSE_RANK() also gives tied rows the same rank but without gaps.
-- They are useful for salary rankings across the company or within each department.
-- =========================================================

SELECT ename, sal,
       DENSE_RANK() OVER (ORDER BY sal DESC) AS dense_rank
FROM emp;

SELECT deptno, ename, sal,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS dense_rank
FROM emp;

-- Rank, dense_rank, and row_number together
SELECT e.*,
       RANK()       OVER (ORDER BY sal DESC) AS rank,
       DENSE_RANK() OVER (ORDER BY sal DESC) AS dense_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC) AS rn
FROM emp e;

-- Rank, dense_rank, and row_number within department
SELECT e.*,
       RANK()       OVER (PARTITION BY deptno ORDER BY sal DESC) AS rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS dense_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) AS rn
FROM emp e;

-- =========================================================
-- NTILE(n)
-- Divides rows into groups
-- NTILE(n) divides an ordered result set into roughly equal groups, such as quartiles. 
-- It is useful for segmentation and percentile-style analysis
-- =========================================================

SELECT ename, sal,
       NTILE(4) OVER (ORDER BY sal DESC) AS quartile
FROM emp;

SELECT deptno, ename, sal,
       NTILE(4) OVER (PARTITION BY deptno ORDER BY sal DESC) AS quartile
FROM emp;

-- =========================================================
-- LAG()
-- Access previous row value
-- LAG() returns a value from a previous row. 
-- They are often used to compare current values with prior or next records, including within partitions like department.
-- =========================================================

SELECT ename, sal,
       LAG(sal) OVER (ORDER BY sal) AS prev_sal
FROM emp;

SELECT empno, ename, hiredate, sal,
       LAG(sal) OVER (ORDER BY hiredate) AS prev_sal
FROM emp;

-- =========================================================
-- LEAD()
-- Access next row value
-- LEAD() returns a value from a following row based on the defined order.
-- =========================================================

SELECT ename, sal,
       LEAD(sal) OVER (ORDER BY sal) AS next_sal
FROM emp;

SELECT empno, ename, hiredate, sal,
       LEAD(sal) OVER (ORDER BY hiredate) AS next_sal
FROM emp;

-- Lag and lead together
SELECT empno, sal,
       LEAD(sal) OVER (ORDER BY sal) AS next_salary,
       LAG(sal)  OVER (ORDER BY sal) AS previous_salary
FROM emp;

-- Difference with previous and next salary within department
SELECT deptno, ename, sal,
       sal - LAG(sal) OVER (PARTITION BY deptno ORDER BY sal) AS sal_diff_with_prev,
       LEAD(sal) OVER (PARTITION BY deptno ORDER BY sal) - sal AS sal_diff_with_next
FROM emp;

-- =========================================================
-- FIRST_VALUE()
-- Returns first value in ordered set
-- FIRST_VALUE() returns the first value in an ordered window
-- =========================================================

SELECT ename, sal,
       FIRST_VALUE(sal) OVER (ORDER BY sal) AS first_sal
FROM emp;

SELECT empno, ename, deptno, sal,
       sal - FIRST_VALUE(sal) OVER (PARTITION BY deptno ORDER BY hiredate)
           AS sal_diff_with_first
FROM emp;

-- =========================================================
-- LAST_VALUE()
-- LAST_VALUE() returns the last value. For LAST_VALUE(), using an explicit window frame is important 
-- when you want the true last row in the partition rather than the default frame behavior. 
-- The source examples explicitly use ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING for that purpose.
-- =========================================================

SELECT ename, sal,
       LAST_VALUE(sal) OVER (
           ORDER BY sal
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS last_sal
FROM emp;

SELECT empno, ename, deptno, sal,
       sal - LAST_VALUE(sal) OVER (
           PARTITION BY deptno
           ORDER BY hiredate
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS sal_diff_with_last
FROM emp;

-- Difference from first and last salary within department
SELECT deptno, ename, sal,
       sal - FIRST_VALUE(sal) OVER (
           PARTITION BY deptno
           ORDER BY sal
       ) AS sal_diff_with_first,
       LAST_VALUE(sal) OVER (
           PARTITION BY deptno
           ORDER BY sal
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) - sal AS sal_diff_with_last
FROM emp;