-- =========================================================
-- DML OPERATIONS IN SNOWFLAKE
-- INSERT, UPDATE, DELETE
-- =========================================================

-- Step 1: Set correct context
USE WAREHOUSE TINITIATEDEV;
USE DATABASE tinitiate;
USE SCHEMA tinitiate.employees;

-- ---------------------------------------------------------
-- INSERT STATEMENTS
-- ---------------------------------------------------------

-- Insert data using column names in the same order as table definition
INSERT INTO dept (deptid, dname)
VALUES (1000, 'PRODUCTION');

INSERT INTO employees (empid, ename, sal, deptid)
VALUES (101, 'John Doe', 5000.00, 1000);

-- Insert data using column names with positional values
INSERT INTO dept (deptid, dname)
VALUES (2000, 'FOUNDRY');

-- Insert data with columns in a different order
INSERT INTO dept (dname, deptid)
VALUES ('STORES', 3000);

-- Insert multiple rows in a single statement
INSERT INTO dept (deptid, dname)
VALUES
    (111, 'TECHNOLOGY'),
    (211, 'FACTORY'),
    (311, 'RETAIL');

-- ---------------------------------------------------------
-- INSERT USING SELECT
-- Copy data from one table into another
-- ---------------------------------------------------------

-- Create a backup/copy table
CREATE OR REPLACE TABLE dept1 (
    deptid NUMBER(38,0),
    dname  VARCHAR(100)
);

-- Copy data from DEPT into DEPT1
INSERT INTO dept1 (deptid, dname)
SELECT deptid, dname
FROM dept;

-- ---------------------------------------------------------
-- SNOWFLAKE CONSTRAINT BEHAVIOR EXAMPLES
-- ---------------------------------------------------------

-- Example: Primary Key violation
-- Snowflake allows insertion because PRIMARY KEY is informational only
INSERT INTO dept (deptid, dname)
VALUES (3000, 'MARKETING');

-- Example: Long string value
-- Snowflake VARCHAR can store long strings unless a limit is explicitly exceeded
INSERT INTO dept (deptid, dname)
VALUES (
    6,
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
);

-- Example: Foreign Key violation
-- Snowflake allows insertion because FOREIGN KEY is informational only
INSERT INTO employees (empid, ename, sal, deptid)
VALUES (15, '4F', 12000.00, 5000);

-- ---------------------------------------------------------
-- UPDATE STATEMENTS
-- ---------------------------------------------------------

-- Update salary of an employee
UPDATE employees
SET sal = 6200.00
WHERE empid = 101;

-- Update project end date for a given employee/project assignment
UPDATE empprojects
SET enddate = '2024-06-01'
WHERE projectid = 1
  AND empid = 101;

-- ---------------------------------------------------------
-- DELETE STATEMENTS
-- ---------------------------------------------------------

-- Delete a department
DELETE FROM dept
WHERE deptid = 3000;

-- Remove an employee
DELETE FROM employees
WHERE empid = 101;


