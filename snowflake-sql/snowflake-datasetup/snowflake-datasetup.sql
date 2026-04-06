-- =========================================================
-- SNOWFLAKE DQL DATA SETUP
-- Based on the GitHub setup you shared
-- =========================================================

-- ---------------------------------------------------------
-- Step 1: Set admin context and compute
-- ---------------------------------------------------------
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE TINITIATEDEV;
USE DATABASE tinitiate;

-- ---------------------------------------------------------
-- Step 2: Grant required access to tirole
-- ---------------------------------------------------------
GRANT USAGE ON WAREHOUSE TINITIATEDEV TO ROLE tirole;
GRANT USAGE ON DATABASE tinitiate TO ROLE tirole;
GRANT USAGE ON SCHEMA tinitiate.employees TO ROLE tirole;

-- Optional: only run if this user exists in your account
-- GRANT ROLE tirole TO USER tinitiate;

-- ---------------------------------------------------------
-- Step 3: Switch to working schema
-- ---------------------------------------------------------
USE SCHEMA tinitiate.employees;

-- ---------------------------------------------------------
-- Step 4: Drop tables if they already exist
-- ---------------------------------------------------------
DROP TABLE IF EXISTS emp_projects;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS salgrade;
DROP TABLE IF EXISTS emp;
DROP TABLE IF EXISTS dept;

-- ---------------------------------------------------------
-- Step 5: Create DEPT table
-- ---------------------------------------------------------
CREATE OR REPLACE TABLE dept
(
    deptno INT NOT NULL,
    dname  VARCHAR(14),
    loc    VARCHAR(13),
    CONSTRAINT pk_dept PRIMARY KEY (deptno)
);

-- ---------------------------------------------------------
-- Step 6: Create EMP table
-- ---------------------------------------------------------
CREATE OR REPLACE TABLE emp
(
    empno      INT NOT NULL,
    ename      VARCHAR(10),
    job        VARCHAR(9),
    mgr        NUMERIC(4),
    hiredate   DATE,
    sal        NUMERIC(7,2),
    commission NUMERIC(7,2),
    deptno     INT NOT NULL,
    CONSTRAINT pk_empno PRIMARY KEY (empno),
    CONSTRAINT fk_deptno FOREIGN KEY (deptno) REFERENCES dept(deptno)
);

-- ---------------------------------------------------------
-- Step 7: Create SALGRADE table
-- ---------------------------------------------------------
CREATE OR REPLACE TABLE salgrade
(
    grade INT NOT NULL,
    losal INT,
    hisal INT,
    CONSTRAINT pk_grade PRIMARY KEY (grade)
);

-- ---------------------------------------------------------
-- Step 8: Create PROJECTS table
-- ---------------------------------------------------------
CREATE OR REPLACE TABLE projects
(
    projectno          INT NOT NULL,
    budget             NUMERIC(7,2),
    monthly_commission NUMERIC(7,2),
    CONSTRAINT pk_projectno PRIMARY KEY (projectno)
);

-- ---------------------------------------------------------
-- Step 9: Create EMP_PROJECTS table
-- ---------------------------------------------------------
CREATE OR REPLACE TABLE emp_projects
(
    emp_projectno INT NOT NULL,
    empno         INT NOT NULL,
    projectno     INT NOT NULL,
    start_date    DATE,
    end_date      DATE,
    CONSTRAINT pk_emp_projectno PRIMARY KEY (emp_projectno),
    CONSTRAINT fk_empno FOREIGN KEY (empno) REFERENCES emp(empno),
    CONSTRAINT fk_projectno FOREIGN KEY (projectno) REFERENCES projects(projectno)
);

-- ---------------------------------------------------------
-- Step 10: Insert data into DEPT
-- ---------------------------------------------------------
INSERT INTO dept (deptno, dname, loc) VALUES
    (10, 'accounting', 'new york'),
    (20, 'research',   'dallas'),
    (30, 'sales',      'chicago'),
    (40, 'operations', 'boston');

-- ---------------------------------------------------------
-- Step 11: Insert data into EMP
-- ---------------------------------------------------------
INSERT INTO emp (
    empno, ename, job, mgr, hiredate, sal, commission, deptno
) VALUES
    (7369, 'smith',   'clerk',     7902, '1980-12-17',  800,  NULL, 20),
    (7499, 'allen',   'salesman',  7698, '1981-02-20', 1600,  NULL, 30),
    (7521, 'ward',    'salesman',  7698, '1981-02-22', 1250,  NULL, 30),
    (7566, 'jones',   'manager',   7839, '1981-04-02', 2975,  NULL, 20),
    (7654, 'martin',  'salesman',  7698, '1981-09-28', 1250, 1400, 30),
    (7698, 'blake',   'manager',   7839, '1981-05-01', 2850,  NULL, 30),
    (7782, 'clark',   'manager',   7839, '1981-06-09', 2450,  NULL, 10),
    (7788, 'scott',   'analyst',   7566, '1982-12-09', 3000,  NULL, 20),
    (7839, 'king',    'president', NULL, '1981-11-17', 5000,  NULL, 10),
    (7844, 'turner',  'salesman',  7698, '1981-09-08', 1500,     0, 30),
    (7876, 'adams',   'clerk',     7788, '1983-01-12', 1100,  NULL, 20),
    (7900, 'james',   'clerk',     7698, '1981-12-03',  950,  NULL, 30),
    (7902, 'ford',    'analyst',   7566, '1981-12-03', 3000,  NULL, 20),
    (7934, 'miller',  'clerk',     7782, '1982-01-23', 1300,  NULL, 10),
    (8000, 'newhire', 'clerk',     7782, '1982-01-23', 1300,  NULL, 10);

-- ---------------------------------------------------------
-- Step 12: Insert data into SALGRADE
-- ---------------------------------------------------------
INSERT INTO salgrade (grade, losal, hisal) VALUES
    (1,  700, 1200),
    (2, 1201, 1400),
    (3, 1401, 2000),
    (4, 2001, 3000),
    (5, 3001, 9999);

-- ---------------------------------------------------------
-- Step 13: Insert data into PROJECTS
-- ---------------------------------------------------------
INSERT INTO projects (projectno, budget, monthly_commission) VALUES
    (1, 10000, 100),
    (2, 20000, 200),
    (3, 30000, 300);

-- ---------------------------------------------------------
-- Step 14: Insert data into EMP_PROJECTS
-- ---------------------------------------------------------
INSERT INTO emp_projects (
    emp_projectno, empno, projectno, start_date, end_date
) VALUES
    (1,  7369, 1, '1984-01-01', '1984-12-31'),
    (2,  7499, 2, '1984-01-01', '1984-12-31'),
    (3,  7521, 3, '1984-01-01', '1984-12-31'),
    (4,  7566, 1, '1984-01-01', '1984-12-31'),
    (5,  7654, 1, '1984-01-01', '1984-12-31'),
    (6,  7698, 2, '1984-01-01', '1984-12-31'),
    (7,  7782, 2, '1984-01-01', '1984-12-31'),
    (8,  7788, 2, '1984-01-01', '1984-12-31'),
    (9,  7839, 3, '1984-01-01', '1984-12-31'),
    (10, 7844, 3, '1984-01-01', '1984-12-31'),
    (11, 7876, 3, '1984-01-01', '1984-12-31'),
    (12, 7900, 2, '1984-01-01', '1984-12-31'),
    (13, 7902, 1, '1984-01-01', '1984-12-31'),
    (14, 7934, 1, '1984-01-01', '1984-12-31');

-- ---------------------------------------------------------
-- Step 15: Quick validation
-- ---------------------------------------------------------
SELECT 'DEPT' AS table_name, COUNT(*) AS row_count FROM dept
UNION ALL
SELECT 'EMP', COUNT(*) FROM emp
UNION ALL
SELECT 'SALGRADE', COUNT(*) FROM salgrade
UNION ALL
SELECT 'PROJECTS', COUNT(*) FROM projects
UNION ALL
SELECT 'EMP_PROJECTS', COUNT(*) FROM emp_projects;