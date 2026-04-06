-- =========================================================
-- SNOWFLAKE DQL - STRING FUNCTIONS
-- =========================================================

-- Step 1: Set context
USE WAREHOUSE TINITIATEDEV;
USE DATABASE tinitiate;
USE SCHEMA tinitiate.employees;

-- =========================================================
-- LENGTH
-- Returns the number of characters in a string
-- =========================================================
SELECT LENGTH(ename) AS name_length
FROM emp;

SELECT ename, LENGTH(ename) AS name_length
FROM emp;


-- =========================================================
-- SUBSTR / SUBSTRING
-- Extracts part of a string
-- =========================================================
SELECT SUBSTR(ename, 1, 3) AS first_three_chars
FROM emp;

-- =========================================================
-- CONCATENATION OPERATOR (||)
-- Combines multiple strings into one
-- =========================================================
SELECT ename || ' - ' || job AS employee_job
FROM emp;

-- =========================================================
-- LOWER
-- Converts text to lowercase
-- =========================================================
SELECT LOWER(dname) AS department_name_lower
FROM dept;

-- =========================================================
-- UPPER
-- Converts text to uppercase
-- =========================================================
SELECT UPPER(job) AS job_upper
FROM emp;

-- =========================================================
-- TRIM
-- Removes leading and trailing spaces
-- =========================================================
SELECT TRIM(loc) AS trimmed_location
FROM dept;

SELECT TRIM('    tinitiate.com     ') AS trimmed_string;

-- =========================================================
-- LTRIM
-- Removes leading spaces
-- =========================================================
SELECT LTRIM(loc) AS left_trimmed_location
FROM dept;

SELECT LTRIM('    tinitiate.com     ') AS trimmed_lstring;

-- =========================================================
-- RTRIM
-- Removes trailing spaces
-- =========================================================
SELECT RTRIM(loc) AS right_trimmed_location
FROM dept;

SELECT RTRIM('    tinitiate.com     ') AS trimmed_rstring;

-- =========================================================
-- POSITION
-- Returns position of substring inside a string
-- =========================================================
SELECT POSITION('e' IN ename) AS position_of_e
FROM emp;

-- =========================================================
-- LEFT
-- Extracts characters from the left side
-- =========================================================
SELECT LEFT(dname, 3) AS left_three_chars
FROM dept;

-- =========================================================
-- RIGHT
-- Extracts characters from the right side
-- =========================================================
SELECT RIGHT(loc, 3) AS right_three_chars
FROM dept;

-- =========================================================
-- REVERSE
-- Reverses the string
-- =========================================================
SELECT REVERSE(ename) AS reversed_name
FROM emp;

-- =========================================================
-- REPLACE
-- Replaces substring with another substring
-- =========================================================
SELECT REPLACE(dname, 'a', 'X') AS replaced_department
FROM dept;

-- =========================================================
-- CASE
-- Applies conditional transformation
-- =========================================================
SELECT ename,
       CASE job
           WHEN 'clerk' THEN 'Clerk'
           WHEN 'salesman' THEN 'Salesman'
           ELSE 'Unknown'
       END AS job_title
FROM emp;

-- =========================================================
-- NVL
-- Replaces NULL with a given value
-- =========================================================
SELECT ename,
       NVL(commission, 0) AS comm
FROM emp;

-- =========================================================
-- COALESCE
-- Returns the first non-NULL value
-- =========================================================
SELECT ename,
       COALESCE(commission, mgr, 0) AS compensation
FROM emp;

-- =========================================================
-- SPLIT
-- Splits a string into an array using a delimiter
-- =========================================================
SELECT SPLIT('apple,banana,cherry', ',') AS fruits;

SELECT SPLIT('this is a test', ' ') AS words;

SELECT SPLIT('2024-07-30', '-') AS date_parts;

-- =========================================================
-- INITCAP
-- Capitalizes first letter of each word
-- =========================================================
SELECT INITCAP('snowflake database') AS capitalized_text;

SELECT INITCAP('hello') AS capitalized_word;