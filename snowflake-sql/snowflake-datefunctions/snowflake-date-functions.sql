-- =========================================================
-- SNOWFLAKE DQL - DATE FUNCTIONS
-- =========================================================

-- Step 1: Set context
USE WAREHOUSE TINITIATEDEV;
USE DATABASE tinitiate;
USE SCHEMA tinitiate.employees;

-- =========================================================
-- CURRENT DATE / TIME FUNCTIONS
-- Functions like CURRENT_DATE, CURRENT_TIME, and CURRENT_TIMESTAMP return the system’s current date and time.
-- =========================================================

-- Current date
SELECT CURRENT_DATE;

-- Current timestamp
SELECT CURRENT_TIMESTAMP;

-- Current time
SELECT CURRENT_TIME;

-- =========================================================
-- DATE ADD / DATE SUBTRACT
-- Adds or subtracts time intervals
-- DATEADD → Adds or subtracts time intervals
-- =========================================================

-- Add 10 days to current date
SELECT DATEADD(day, 10, CURRENT_DATE) AS future_date;

-- Subtract 5 months from current date
SELECT DATEADD(month, -5, CURRENT_DATE) AS past_date;

-- =========================================================
-- DATEDIFF
-- Returns difference between two dates
-- DATEDIFF → Calculates difference between two dates
-- =========================================================

SELECT DATEDIFF(day, '2024-01-01', '2024-02-01') AS days_diff;

SELECT DATEDIFF(month, '2023-01-01', '2024-01-01') AS months_diff;

-- =========================================================
-- DATE_PART / EXTRACT
-- Extract parts of a date
-- Used to extract specific components such as year, month, or day from a date.
-- =========================================================

SELECT empno, hiredate,
       DATE_PART(year, hiredate)   AS year,
       DATE_PART(month, hiredate)  AS month,
       DATE_PART(day, hiredate)    AS day
FROM emp;

-- Alternative using EXTRACT
SELECT empno, hiredate,
       EXTRACT(year FROM hiredate) AS year_extracted
FROM emp;

-- =========================================================
-- YEAR, MONTH, DAY FUNCTIONS
-- Shortcut functions to extract date parts directly.
-- =========================================================

SELECT empno, hiredate,
       YEAR(hiredate)  AS year,
       MONTH(hiredate) AS month,
       DAY(hiredate)   AS day
FROM emp;

-- =========================================================
-- DATE_TRUNC
-- Truncates date to specified level
-- Used to truncate a date to a specific level (month, year, etc.).
-- =========================================================

SELECT hiredate,
       DATE_TRUNC(month, hiredate) AS month_start,
       DATE_TRUNC(year, hiredate)  AS year_start
FROM emp;

-- =========================================================
-- LAST_DAY
-- Returns the last day of a given month.
-- =========================================================

SELECT hiredate,
       LAST_DAY(hiredate) AS last_day_of_month
FROM emp;

-- =========================================================
-- TO_DATE → Converts string to date
-- =========================================================

SELECT TO_DATE('2024-07-30', 'YYYY-MM-DD') AS converted_date;

-- =========================================================
-- DATE FORMATTING
-- TO_CHAR → Formats date into readable string
-- =========================================================

SELECT hiredate,
       TO_CHAR(hiredate, 'YYYY-MM') AS formatted_date
FROM emp;

-- =========================================================
-- NEXT_DAY / PREVIOUS_DAY
-- Returns the next or previous occurrence of a specific weekday.
-- =========================================================

SELECT NEXT_DAY(CURRENT_DATE, 'MONDAY') AS next_monday;

SELECT PREVIOUS_DAY(CURRENT_DATE, 'FRIDAY') AS last_friday;