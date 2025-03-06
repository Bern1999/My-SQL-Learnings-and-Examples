-- Common Table Expressions (CTE) allow defining a temporary result set 
-- that can be referenced within a main query.

-- Basic CTE example
WITH CTE_Example AS 
(
    SELECT gender, SUM(salary), MIN(salary), MAX(salary), COUNT(salary), AVG(salary)
    FROM employee_demographics dem
    JOIN employee_salary sal
        ON dem.employee_id = sal.employee_id
    GROUP BY gender
)
SELECT * FROM CTE_Example;

-- Performing calculations using CTE results
WITH CTE_Example AS 
(
    SELECT gender, SUM(salary) AS total_salary, COUNT(salary) AS salary_count
    FROM employee_demographics dem
    JOIN employee_salary sal
        ON dem.employee_id = sal.employee_id
    GROUP BY gender
)
SELECT gender, ROUND(AVG(total_salary / salary_count), 2) 
FROM CTE_Example 
GROUP BY gender;

-- Creating multiple CTEs in one WITH statement and joining them
WITH CTE_Example AS 
(
    SELECT employee_id, gender, birth_date
    FROM employee_demographics 
    WHERE birth_date > '1985-01-01'
), 
CTE_Example2 AS 
(
    SELECT employee_id, salary
    FROM parks_and_recreation.employee_salary
    WHERE salary >= 50000
)
SELECT * 
FROM CTE_Example cte1
LEFT JOIN CTE_Example2 cte2
    ON cte1.employee_id = cte2.employee_id;

-- Renaming columns within a CTE for easier reference
WITH CTE_Example (gender, sum_salary, min_salary, max_salary, count_salary) AS 
(
    SELECT gender, SUM(salary), MIN(salary), MAX(salary), COUNT(salary)
    FROM employee_demographics dem
    JOIN employee_salary sal
        ON dem.employee_id = sal.employee_id
    GROUP BY gender
)
SELECT gender, ROUND(AVG(sum_salary / count_salary), 2) 
FROM CTE_Example 
GROUP BY gender;

-- Stored Procedures: A stored procedure is a reusable SQL code block that can be executed with a single call.

-- Simple Stored Procedure
DELIMITER $$ 
CREATE PROCEDURE large_salaries() 
BEGIN
    SELECT * 
    FROM employee_salary 
    WHERE salary >= 60000;
END $$ 
DELIMITER ;

-- Call the stored procedure
CALL large_salaries();

-- Creating a stored procedure with multiple queries
DELIMITER $$ 
CREATE PROCEDURE large_salaries2() 
BEGIN
    SELECT * FROM employee_salary WHERE salary >= 60000;
    SELECT * FROM employee_salary WHERE salary >= 50000;
END $$ 
DELIMITER ;

CALL large_salaries2();

-- Dropping and recreating a stored procedure safely
USE `parks_and_recreation`;
DROP PROCEDURE IF EXISTS `large_salaries3`;
DELIMITER $$ 
CREATE PROCEDURE large_salaries3() 
BEGIN
    SELECT * FROM employee_salary WHERE salary >= 60000;
    SELECT * FROM employee_salary WHERE salary >= 50000;
END $$ 
DELIMITER ;

CALL large_salaries3();

-- Stored Procedure with a Parameter
DELIMITER $$ 
CREATE PROCEDURE large_salaries3(employee_id_param INT) 
BEGIN
    SELECT * 
    FROM employee_salary 
    WHERE salary >= 60000
    AND employee_id = employee_id_param;
END $$ 
DELIMITER ;

CALL large_salaries3(1);

-- Temporary Tables: These tables exist only during the session that created them.
-- They are useful for storing intermediate query results or manipulating data before inserting into a permanent table.

-- Method 1: Creating and inserting into a temporary table manually
CREATE TEMPORARY TABLE temp_table (
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    favorite_movie VARCHAR(100)
);

-- Insert data into the temporary table
INSERT INTO temp_table 
VALUES ('Bern', 'Brua', 'Harry Potter: Order of the Phoenix');

-- Query the temporary table
SELECT * FROM temp_table;

-- Method 2: Creating a temporary table directly from a query
CREATE TEMPORARY TABLE salary_over_50k 
SELECT * FROM employee_salary 
WHERE salary > 50000;

-- Query the temporary table
SELECT * FROM salary_over_50k;

-- Triggers: A trigger is a block of SQL code that executes automatically when an event (INSERT, UPDATE, DELETE) occurs on a table.

-- Example: Creating a Trigger to insert employee data into employee_demographics when added to employee_salary
USE parks_and_recreation;
DELIMITER $$

CREATE TRIGGER employee_insert_trigger
    AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
    INSERT INTO employee_demographics (employee_id, first_name, last_name) 
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$

DELIMITER ;

-- Testing the trigger
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'Jean-Ralphio', 'Saperstein', 'Entertainment 720 CEO', 1000000, NULL);

-- Verify the update in employee_demographics
SELECT * FROM employee_demographics;

-- Delete test data
DELETE FROM employee_salary WHERE employee_id = 13;

-- ------------------------------
-- Events: A scheduled task that executes at a specific time or interval.

-- Example: Automatically deleting retired employees (age >= 60) every 30 seconds
DROP EVENT IF EXISTS delete_retirees;
DELIMITER $$

CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO BEGIN
    DELETE FROM parks_and_recreation.employee_demographics
    WHERE age >= 60;
END $$

DELIMITER ;

-- View scheduled events
SHOW EVENTS;

-- Verify if retirees have been removed
SELECT * FROM parks_and_recreation.employee_demographics;
