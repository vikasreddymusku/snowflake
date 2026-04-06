-- =========================================================
-- ADDING NOT NULL CONSTRAINTS (DATA INTEGRITY)
-- =========================================================

-- Step 1: Set correct context
USE DATABASE tinitiate;
USE SCHEMA tinitiate.employees;

-- ---------------------------------------------------------
-- Step 2: Apply NOT NULL constraint on key columns
-- Ensures critical fields cannot store NULL values
-- ---------------------------------------------------------

-- Enforce NOT NULL on employee ID
ALTER TABLE employees 
ALTER COLUMN empid SET NOT NULL;

-- Enforce NOT NULL on employee-project mapping ID
ALTER TABLE empprojects 
ALTER COLUMN ep_id SET NOT NULL;

-- Enforce NOT NULL on department ID
ALTER TABLE dept 
ALTER COLUMN deptid SET NOT NULL;

-- Enforce NOT NULL on project ID
ALTER TABLE projects 
ALTER COLUMN projectid SET NOT NULL;

-- ---------------------------------------------------------
-- Step 3: Example of defining NOT NULL during table creation
-- Best practice: define constraints at creation time
-- ---------------------------------------------------------

CREATE OR REPLACE TABLE staff (
    id NUMBER(38,0) PRIMARY KEY,   -- Unique identifier
    name VARCHAR(255) NOT NULL,    -- Mandatory field
    age NUMBER(38,0)               -- Optional field
);

-- =========================================================
-- UNIQUE CONSTRAINT (DATA UNIQUENESS)
-- =========================================================

-- ---------------------------------------------------------
-- Step 1: Add UNIQUE constraint on empid
-- Ensures no duplicate employee IDs are allowed
-- ---------------------------------------------------------
ALTER TABLE employees
ADD CONSTRAINT unique_empid UNIQUE (empid);

-- ---------------------------------------------------------
-- Step 2: Example of defining UNIQUE during table creation
-- Best practice: define constraints upfront
-- ---------------------------------------------------------
CREATE OR REPLACE TABLE students (
    student_id NUMBER(38,0) PRIMARY KEY,   -- Unique identifier
    email VARCHAR(100) UNIQUE,             -- Ensures unique email per student
    name VARCHAR(100)                      -- Student name
);

-- =========================================================
-- PRIMARY KEY CONSTRAINTS (TABLE IDENTIFICATION)
-- =========================================================

-- ---------------------------------------------------------
-- Step 1: Add PRIMARY KEY constraints to tables
-- Ensures each row is uniquely identifiable
-- ---------------------------------------------------------

-- Add primary key to DEPT table
ALTER TABLE dept
ADD CONSTRAINT pk_dept PRIMARY KEY (deptid);

-- Add primary key to EMPLOYEES table
ALTER TABLE employees
ADD CONSTRAINT pk_emp PRIMARY KEY (empid);

-- Add primary key to PROJECTS table
ALTER TABLE projects
ADD CONSTRAINT pk_projects PRIMARY KEY (projectid);

-- Add primary key to EMPPROJECTS table
ALTER TABLE empprojects
ADD CONSTRAINT pk_empprojects PRIMARY KEY (ep_id);

-- ---------------------------------------------------------
-- Step 2: Example of defining PRIMARY KEY during creation
-- Best practice: define constraints at table creation time
-- ---------------------------------------------------------

CREATE OR REPLACE TABLE customers (
    customer_id NUMBER(38,0) PRIMARY KEY,   -- Unique identifier
    order_date DATE                         -- Order date
);

-- =========================================================
-- FOREIGN KEY CONSTRAINTS (RELATIONSHIPS)
-- =========================================================

-- ---------------------------------------------------------
-- Step 1: Add Foreign Key on EMPLOYEES table
-- Links employee to department
-- ---------------------------------------------------------
ALTER TABLE employees
ADD CONSTRAINT fk_emp_dept 
FOREIGN KEY (deptid) REFERENCES dept(deptid);

-- ---------------------------------------------------------
-- Step 2: Add Foreign Keys on EMPPROJECTS table
-- Links employees and projects (many-to-many relationship)
-- ---------------------------------------------------------

-- Link to employees table
ALTER TABLE empprojects
ADD CONSTRAINT fk_empprojects_emp 
FOREIGN KEY (empid) REFERENCES employees(empid);

-- Link to projects table
ALTER TABLE empprojects
ADD CONSTRAINT fk_empprojects_project 
FOREIGN KEY (projectid) REFERENCES projects(projectid);

-- ---------------------------------------------------------
-- Step 3: Example of defining FOREIGN KEY during creation
-- Best practice: define constraints during table creation
-- ---------------------------------------------------------

CREATE OR REPLACE TABLE orders (
    order_id NUMBER(38,0) PRIMARY KEY,
    customer_id NUMBER(38,0) REFERENCES customers(customer_id),
    order_date DATE
);
