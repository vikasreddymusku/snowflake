-- =========================================================
-- SNOWFLAKE DQL - COMMON TABLE EXPRESSIONS (CTEs)
-- =========================================================

-- Step 1: Set context
USE WAREHOUSE TINITIATEDEV;
USE DATABASE tinitiate;
USE SCHEMA tinitiate.employees;

-- =========================================================
-- BASIC CTE
-- Retrieve employees with job title 'manager'
-- =========================================================

WITH Managers AS (
    SELECT empno, ename, job, sal
    FROM emp
    WHERE job = 'manager'
)
SELECT *
FROM Managers;

-- =========================================================
-- CTE: Count employees in each department
-- =========================================================

WITH DeptEmployeeCount AS (
    SELECT deptno, COUNT(*) AS num_employees
    FROM emp
    GROUP BY deptno
)
SELECT d.deptno, d.dname, dec.num_employees
FROM dept d
JOIN DeptEmployeeCount dec
    ON d.deptno = dec.deptno;

-- =========================================================
-- CTE: Average salary by department
-- =========================================================

WITH AvgSalary AS (
    SELECT deptno, AVG(sal) AS avg_sal
    FROM emp
    GROUP BY deptno
)
SELECT d.deptno, d.dname, a.avg_sal
FROM dept d
JOIN AvgSalary a
    ON d.deptno = a.deptno;

-- =========================================================
-- CTE: Employees and their associated projects
-- =========================================================

WITH EmployeeProjects AS (
    SELECT e.empno, e.ename, ep.projectno, p.budget
    FROM emp e
    JOIN emp_projects ep
        ON e.empno = ep.empno
    JOIN projects p
        ON ep.projectno = p.projectno
)
SELECT empno, ename, projectno, budget
FROM EmployeeProjects;

-- =========================================================
-- CTE: Rank employees by salary within each department
-- =========================================================

WITH RankedEmployees AS (
    SELECT empno,
           ename,
           deptno,
           sal,
           ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) AS row_num,
           RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS rank,
           DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS dense_rank
    FROM emp
)
SELECT empno, ename, deptno, sal, row_num, rank, dense_rank
FROM RankedEmployees;

-- =========================================================
-- CTE: Running total of salaries within each department
-- =========================================================

WITH RunningTotal AS (
    SELECT empno,
           ename,
           deptno,
           sal,
           SUM(sal) OVER (
               PARTITION BY deptno
               ORDER BY empno
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS running_total
    FROM emp
)
SELECT empno, ename, deptno, sal, running_total
FROM RunningTotal;

-- =========================================================
-- MULTIPLE CTEs
-- Total salary and average salary by department
-- =========================================================

WITH TotalSalary AS (
    SELECT deptno, SUM(sal) AS total_sal
    FROM emp
    GROUP BY deptno
),
AvgSalary AS (
    SELECT deptno, AVG(sal) AS avg_sal
    FROM emp
    GROUP BY deptno
)
SELECT t.deptno, t.total_sal, a.avg_sal
FROM TotalSalary t
JOIN AvgSalary a
    ON t.deptno = a.deptno;

-- =========================================================
-- MULTIPLE CTEs
-- Total salary and total project budget by department
-- =========================================================

WITH TotalSalary AS (
    SELECT deptno, SUM(sal) AS total_sal
    FROM emp
    GROUP BY deptno
),
TotalBudget AS (
    SELECT e.deptno, SUM(p.budget) AS total_budget
    FROM emp e
    JOIN emp_projects ep
        ON e.empno = ep.empno
    JOIN projects p
        ON ep.projectno = p.projectno
    GROUP BY e.deptno
)
SELECT ts.deptno, ts.total_sal, tb.total_budget
FROM TotalSalary ts
JOIN TotalBudget tb
    ON ts.deptno = tb.deptno;

-- =========================================================
-- RECURSIVE CTE
-- Generate a sequence of numbers from 1 to 10
-- =========================================================

WITH RECURSIVE Sequence AS (
    SELECT 1 AS num
    UNION ALL
    SELECT num + 1
    FROM Sequence
    WHERE num < 10
)
SELECT num
FROM Sequence;

-- =========================================================
-- RECURSIVE CTE
-- Display employee management hierarchy
-- =========================================================

WITH RECURSIVE EmpHierarchy AS (
    -- Anchor member: top-level manager
    SELECT empno, ename, job, mgr
    FROM emp
    WHERE mgr IS NULL

    UNION ALL

    -- Recursive member: employees reporting to previous level
    SELECT e.empno, e.ename, e.job, e.mgr
    FROM emp e
    INNER JOIN EmpHierarchy eh
        ON e.mgr = eh.empno
)
SELECT *
FROM EmpHierarchy;