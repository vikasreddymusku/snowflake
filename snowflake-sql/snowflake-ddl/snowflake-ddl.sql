-- =========================================================
-- SNOWFLAKE RBAC + SCHEMA + TABLE SETUP
-- =========================================================

-- Step 1: Switch to ACCOUNTADMIN role
-- Ensures full administrative privileges for ownership and access control operations
USE ROLE ACCOUNTADMIN;

-- Step 2: Set the working database context
-- All objects will be created inside the 'tinitiate' database
USE DATABASE tinitiate;

-- Step 3: Take ownership of the schema
-- Required when schema was created by another role
-- COPY CURRENT GRANTS ensures existing permissions are preserved
GRANT OWNERSHIP ON SCHEMA tinitiate.employees TO ROLE ACCOUNTADMIN COPY CURRENT GRANTS;

-- Step 4: Set the working schema
-- All tables will be created under this schema
USE SCHEMA tinitiate.employees;

-- =========================================================
-- TABLE CREATION
-- =========================================================

-- Step 5: Create Department table
-- Stores master data for departments
CREATE OR REPLACE TABLE dept (
    deptid NUMBER(38,0) NOT NULL,
    dname  VARCHAR(100),
    CONSTRAINT pk_dept PRIMARY KEY (deptid)
);

-- Step 6: Create Employees table
-- Stores employee details and links to department
CREATE OR REPLACE TABLE employees (
    empid  NUMBER(38,0) NOT NULL,
    ename  VARCHAR(100),
    sal    NUMBER(7,2),
    deptid NUMBER(38,0),
    CONSTRAINT pk_emp PRIMARY KEY (empid),
    CONSTRAINT fk_emp_dept FOREIGN KEY (deptid) REFERENCES dept(deptid)
);

-- Step 7: Create Projects table
-- Stores project-level details including budget
CREATE OR REPLACE TABLE projects (
    projectid     NUMBER(38,0) NOT NULL,
    projectname   VARCHAR(100),
    projectbudget NUMBER(12,2),
    CONSTRAINT pk_projects PRIMARY KEY (projectid)
);

-- Step 8: Create Employee-Project mapping table
-- Tracks which employee is assigned to which project along with duration
CREATE OR REPLACE TABLE empprojects (
    ep_id      NUMBER(38,0) NOT NULL,
    empid      NUMBER(38,0),
    projectid  NUMBER(38,0),
    startdate  DATE,
    enddate    DATE,
    CONSTRAINT pk_empprojects PRIMARY KEY (ep_id),
    CONSTRAINT fk_empprojects_emp FOREIGN KEY (empid) REFERENCES employees(empid),
    CONSTRAINT fk_empprojects_project FOREIGN KEY (projectid) REFERENCES projects(projectid)
);

-- =========================================================
-- ACCESS CONTROL (RBAC)
-- =========================================================

-- Step 9: Grant schema usage
-- Allows roles to access objects within the schema
GRANT USAGE ON SCHEMA tinitiate.employees TO ROLE tirole;
GRANT USAGE ON SCHEMA tinitiate.employees TO ROLE developer_role;

-- Step 10: Grant table-level privileges (existing tables)
-- tirole gets full DML access, developer_role gets read-only access
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA tinitiate.employees TO ROLE tirole;
GRANT SELECT ON ALL TABLES IN SCHEMA tinitiate.employees TO ROLE developer_role;

-- Step 11: Grant future table privileges
-- Ensures any new tables automatically inherit permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA tinitiate.employees TO ROLE tirole;
GRANT SELECT ON FUTURE TABLES IN SCHEMA tinitiate.employees TO ROLE developer_role;

-- =========================================================
-- ALTER TABLE OPERATIONS (Schema Evolution)
-- =========================================================

-- ---------------------------------------------------------
-- Step 1: Modify EMPLOYEES table
-- Add a new column "hire_date" to track employee joining date
-- ---------------------------------------------------------
ALTER TABLE employees ADD COLUMN hire_date DATE;

-- Rollback: Remove the column if not needed
-- Useful for testing or reverting schema changes
ALTER TABLE employees DROP COLUMN hire_date;

-- ---------------------------------------------------------
-- Step 2: Modify PROJECTS table
-- Change data type of "projectbudget" for precision consistency
-- ---------------------------------------------------------
ALTER TABLE projects 
ALTER COLUMN projectbudget SET DATA TYPE DECIMAL(12,2);

-- Rollback: Revert to original datatype
ALTER TABLE projects 
ALTER COLUMN projectbudget SET DATA TYPE NUMBER(12,2);

-- ---------------------------------------------------------
-- Step 3: Modify EMPPROJECTS table
-- Remove "enddate" column if no longer required
-- ---------------------------------------------------------
ALTER TABLE empprojects DROP COLUMN enddate;

-- Rollback: Add the column back if needed
ALTER TABLE empprojects ADD COLUMN enddate DATE;

-- =========================================================
-- DROP & RECREATE TABLE (DEPT)
-- =========================================================

-- ---------------------------------------------------------
-- Step 1: Drop the DEPT table
-- Removes the table and all its data permanently
-- IF EXISTS prevents error if the table does not exist
-- ---------------------------------------------------------
DROP TABLE IF EXISTS dept;

-- ---------------------------------------------------------
-- Step 2: Recreate the DEPT table
-- Defines structure for storing department information
-- ---------------------------------------------------------
CREATE OR REPLACE TABLE dept (
    deptid NUMBER(38,0),     -- Unique identifier for department
    dname  VARCHAR(100)      -- Department name
);