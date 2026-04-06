-- Step 1: Drop database if it already exists (optional but ensures clean setup)
DROP DATABASE IF EXISTS tinitiate;

-- Step 2: Create a fresh database
CREATE DATABASE tinitiate;

-- Step 3: Use the database
USE DATABASE tinitiate;

-- Step 4: Drop roles if they exist
DROP ROLE IF EXISTS tirole;
DROP ROLE IF EXISTS developer_role;

-- Step 5: Recreate roles
CREATE ROLE tirole;
CREATE ROLE developer_role;

-- Step 6: Drop users if they exist
DROP USER IF EXISTS tiuser;
DROP USER IF EXISTS developer;

-- Step 7: Recreate users
CREATE USER tiuser PASSWORD = 'Tinitiate!23';
CREATE USER developer PASSWORD = 'Tinitiate!23';

-- Step 8: Assign roles to users
GRANT ROLE tirole TO USER tiuser;
GRANT ROLE developer_role TO USER developer;

-- Step 9: Ensure correct database context
USE DATABASE tinitiate;

-- Step 10: Drop schema if it exists
DROP SCHEMA IF EXISTS employees;

-- Step 11: Recreate schema
CREATE SCHEMA employees;

-- Step 12: Grant ownership of schema to tirole
GRANT OWNERSHIP ON SCHEMA employees TO ROLE tirole;

-- Step 13: (Optional Best Practice) Grant usage permissions
GRANT USAGE ON DATABASE tinitiate TO ROLE tirole;
GRANT USAGE ON DATABASE tinitiate TO ROLE developer_role;

GRANT USAGE ON SCHEMA employees TO ROLE developer_role;