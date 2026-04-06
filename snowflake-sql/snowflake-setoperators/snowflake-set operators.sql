-- =========================================================
-- SNOWFLAKE DQL - SET OPERATIONS
-- =========================================================

-- Step 1: Set context
USE WAREHOUSE tinitiatedev;
USE DATABASE tinitiate;
USE SCHEMA tinitiate.employees;

-- =========================================================
-- UNION
-- The UNION operator combines results from multiple queries and removes duplicate rows.
-- 
-- =========================================================

-- Employees from dept 10 and 20 (no duplicates)
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10

UNION

SELECT empno, ename, deptno
FROM emp
WHERE deptno = 20;

-- =========================================================
-- UNION ALL
-- The UNION ALL operator combines results without removing duplicates.
-- =========================================================

SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10

UNION ALL

SELECT empno, ename, deptno
FROM emp
WHERE deptno = 20;

-- =========================================================
-- INTERSECT
-- The INTERSECT operator returns only the common rows present in both queries.
-- =========================================================

SELECT empno, ename, deptno
FROM emp
WHERE deptno IN (10, 20)

INTERSECT

SELECT empno, ename, deptno
FROM emp
WHERE sal > 2000;

-- =========================================================
-- MINUS / EXCEPT
-- The EXCEPT (or MINUS) operator returns rows from the first query that are not present in the second query.
-- =========================================================

-- Using EXCEPT (recommended)
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10

EXCEPT

SELECT empno, ename, deptno
FROM emp
WHERE sal > 2000;

-- Using MINUS (also supported)
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10

MINUS

SELECT empno, ename, deptno
FROM emp
WHERE sal > 2000;

-- =========================================================
-- ORDER BY WITH SET OPERATIONS
-- =========================================================

SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10

UNION

SELECT empno, ename, deptno
FROM emp
WHERE deptno = 20

ORDER BY deptno;

-- =========================================================
-- LIMIT WITH SET OPERATIONS
-- =========================================================

SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10

UNION ALL

SELECT empno, ename, deptno
FROM emp
WHERE deptno = 20

LIMIT 5;