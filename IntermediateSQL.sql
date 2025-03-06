-- CASE statements allow conditional logic in SQL queries, 
-- similar to IF-ELSE statements in programming.

-- Display all employee demographics
SELECT * FROM employee_demographics;

-- Categorize employees based on age groups
SELECT first_name, last_name, 
CASE
    WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Old'
    ELSE 'Senior'
END AS age_group
FROM employee_demographics;

-- Perform salary adjustments based on salary thresholds
SELECT first_name, last_name, salary,
CASE
    WHEN salary > 45000 THEN salary * 1.05  -- 5% raise
    ELSE salary * 1.07  -- 7% raise
END AS new_salary
FROM employee_salary;

-- Apply department-based bonuses
SELECT first_name, last_name, salary,
CASE
    WHEN dept_id = 6 THEN salary * 0.10  -- 10% bonus for Finance Dept
    ELSE 0
END AS bonus
FROM employee_salary;

-- Combining salary adjustments and bonuses in a single query
SELECT first_name, last_name, salary,
CASE
    WHEN salary > 45000 THEN salary * 1.05
    ELSE salary * 1.07
END AS new_salary,
CASE
    WHEN dept_id = 6 THEN salary * 0.10
    ELSE 0
END AS bonus
FROM employee_salary;


-- JOINS in SQL

-- Joins combine data from two or more tables based on a related column.

-- Display all employee demographics and salary details
SELECT * FROM employee_demographics;
SELECT * FROM employee_salary;

-- INNER JOIN: Returns only matching rows from both tables
SELECT * 
FROM employee_demographics dem
INNER JOIN employee_salary sal 
ON dem.employee_id = sal.employee_id;

-- LEFT JOIN: Returns all rows from the left table, and matching rows from the right table (NULL if no match)
SELECT * 
FROM employee_salary sal
LEFT JOIN employee_demographics dem 
ON dem.employee_id = sal.employee_id;

-- RIGHT JOIN: Returns all rows from the right table, and matching rows from the left table
SELECT * 
FROM employee_salary sal
RIGHT JOIN employee_demographics dem 
ON dem.employee_id = sal.employee_id;

-- SELF JOIN: A table joins itself, useful for hierarchical data or comparisons
-- Example: Assigning a Secret Santa where each employee's Santa is the next employee
SELECT emp1.employee_id AS santa_id, emp1.first_name AS santa_name, 
       emp2.employee_id AS employee_id, emp2.first_name AS employee_name
FROM employee_salary emp1
JOIN employee_salary emp2 
ON emp1.employee_id + 1 = emp2.employee_id;

-- JOINING MULTIPLE TABLES
SELECT * 
FROM employee_demographics dem
INNER JOIN employee_salary sal 
ON dem.employee_id = sal.employee_id
LEFT JOIN parks_departments dept 
ON dept.department_id = sal.dept_id;


-- STRING FUNCTIONS IN SQL

-- Display all customers
SELECT * FROM bakery.customers;

-- LENGTH: Returns the length of a string
SELECT LENGTH('sky');
SELECT first_name, LENGTH(first_name) FROM employee_demographics;

-- UPPER & LOWER: Convert text to uppercase or lowercase
SELECT UPPER('sky'), LOWER('SKY');
SELECT first_name, UPPER(first_name), LOWER(first_name) FROM employee_demographics;

-- TRIM, LTRIM, RTRIM: Remove whitespace from strings
SELECT TRIM('  sky  '), LTRIM('  SQL  '), RTRIM('  SQL  ');

-- LEFT & RIGHT: Extract characters from the left or right side
SELECT LEFT('Alexander', 4), RIGHT('Alexander', 6);
SELECT first_name, LEFT(first_name, 4), RIGHT(first_name, 4) FROM employee_demographics;

-- SUBSTRING: Extract a portion of a string (starting position, length)
SELECT SUBSTRING('Alexander', 2, 3);
SELECT birth_date, SUBSTRING(birth_date, 1, 4) AS birth_year FROM employee_demographics;

-- REPLACE: Replace occurrences of a character or substring
SELECT REPLACE('Alexander', 'a', 'z');
SELECT REPLACE(first_name, 'a', 'z') FROM employee_demographics;

-- LOCATE: Find the position of a substring in a string
SELECT LOCATE('x', 'Alexander');
SELECT first_name, LOCATE('a', first_name) FROM employee_demographics;

-- CONCAT: Combine multiple strings
SELECT CONCAT('Alex', ' Freberg');
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM employee_demographics;


-- Subqueries allow queries within queries, enabling more flexible data retrieval.

-- Display all employee demographics
SELECT * FROM employee_demographics;

-- Retrieve employees working in the Parks and Rec Department using a subquery
SELECT * 
FROM employee_demographics
WHERE employee_id IN 
    (SELECT employee_id 
     FROM employee_salary 
     WHERE dept_id = 1);

-- Note: A subquery must return only one column when used with IN.

-- Compare each employee's salary with the average salary using a subquery
SELECT first_name, salary, 
    (SELECT AVG(salary) FROM employee_salary) AS avg_salary
FROM employee_salary;

-- Using a subquery in the FROM clause to create an aggregated dataset
SELECT gender, AVG(min_age) 
FROM (
    SELECT gender, MIN(age) AS min_age, MAX(age) AS max_age, 
           COUNT(age) AS count_age, AVG(age) AS avg_age
    FROM employee_demographics
    GROUP BY gender
) AS Agg_Table
GROUP BY gender;


-- UNION combines rows from multiple queries into a single result set.
-- Unlike JOINs, which merge columns, UNION stacks data vertically.

-- Example of UNION (Mixing unrelated data, not recommended)
SELECT first_name, last_name FROM employee_demographics
UNION
SELECT occupation, salary FROM employee_salary;

-- Combining similar data while removing duplicates (UNION removes duplicates by default)
SELECT first_name, last_name FROM employee_demographics
UNION
SELECT first_name, last_name FROM employee_salary;

-- Explicitly using UNION DISTINCT (same as UNION)
SELECT first_name, last_name FROM employee_demographics
UNION DISTINCT
SELECT first_name, last_name FROM employee_salary;

-- Using UNION ALL to include duplicates
SELECT first_name, last_name FROM employee_demographics
UNION ALL
SELECT first_name, last_name FROM employee_salary;

-- Practical use case: Identifying employees for budget cuts

-- Employees over 50
SELECT first_name, last_name, 'Old' AS label
FROM employee_demographics
WHERE age > 50;

-- Categorizing employees by age and salary
SELECT first_name, last_name, 'Old Lady' AS label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Old Man'
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Highly Paid Employee'
FROM employee_salary
WHERE salary >= 70000
ORDER BY first_name;


-- WINDOW FUNCTIONS
-- Window functions allow calculations across a partition of rows without collapsing them into a single row (unlike GROUP BY).
-- They are useful for ranking, running totals, and aggregated calculations without losing row-level data.

-- Sample dataset
SELECT * FROM employee_demographics;

-- GROUP BY Example: Average salary by gender
SELECT gender, ROUND(AVG(salary),1)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender;

-- WINDOW FUNCTION Example: Average salary across all employees (without collapsing rows)
SELECT dem.employee_id, dem.first_name, gender, salary,
AVG(salary) OVER() AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;

-- Using PARTITION BY: Average salary per gender while keeping individual records
SELECT dem.employee_id, dem.first_name, gender, salary,
AVG(salary) OVER(PARTITION BY gender) AS avg_salary_by_gender
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;

-- Using SUM with ORDER BY to create a rolling total by gender
SELECT dem.employee_id, dem.first_name, gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY employee_id) AS rolling_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;

-- RANKING FUNCTIONS
-- ROW_NUMBER: Assigns a unique row number within each partition
SELECT dem.employee_id, dem.first_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;

-- RANK: Assigns the same rank to duplicate values but skips numbers
SELECT dem.employee_id, dem.first_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_1
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;

-- DENSE_RANK: Similar to RANK but without skipping numbers
SELECT dem.employee_id, dem.first_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_1,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_2
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
