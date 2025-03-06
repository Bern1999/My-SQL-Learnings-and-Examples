-- WHERE - to filter records based on specific conditions. It allows you to retrieve only the rows that meet the specified criteria.

-- Filtering salaries greater than 50,000 (excludes 50,000)
SELECT * FROM employee_salary WHERE salary > 50000;

-- Filtering salaries greater than or equal to 50,000 (includes 50,000)
SELECT * FROM employee_salary WHERE salary >= 50000;

-- Selecting only female employees
SELECT * FROM employee_demographics WHERE gender = 'Female';

-- Selecting employees who are NOT female
SELECT * FROM employee_demographics WHERE gender != 'Female';

-- Selecting employees born after January 1, 1985
SELECT * FROM employee_demographics WHERE birth_date > '1985-01-01';

-- GROUP BY

-- GROUP BY groups rows with the same values in specified columns 
-- and allows aggregate functions to be applied.

-- Display all employee demographics
SELECT * FROM employee_demographics;

-- Group employees by gender
SELECT gender 
FROM employee_demographics 
GROUP BY gender;

-- Incorrect usage: Selecting a non-grouped column without aggregation
SELECT first_name 
FROM employee_demographics 
GROUP BY gender;

-- Grouping employees by occupation
SELECT occupation 
FROM employee_salary 
GROUP BY occupation;
-- Note: There is only one row for each occupation.

-- Grouping by occupation and salary creates unique rows for each combination
SELECT occupation, salary 
FROM employee_salary 
GROUP BY occupation, salary;

-- Using GROUP BY with aggregate functions
SELECT gender, AVG(age) 
FROM employee_demographics 
GROUP BY gender;

-- Using multiple aggregate functions with GROUP BY
SELECT gender, MIN(age), MAX(age), COUNT(age), AVG(age) 
FROM employee_demographics 
GROUP BY gender;

-- ORDER BY

-- ORDER BY is used to sort query results in ascending (default) or descending order.

-- Sorting customers by first name (ascending)
SELECT * FROM customers ORDER BY first_name;

-- Sorting employee demographics by first name (ascending by default)
SELECT * FROM employee_demographics ORDER BY first_name;

-- Sorting employee demographics by first name in descending order
SELECT * FROM employee_demographics ORDER BY first_name DESC;

-- Sorting by multiple columns: First by gender, then by age (both ascending)
SELECT * FROM employee_demographics ORDER BY gender, age;

-- Sorting by multiple columns in descending order
SELECT * FROM employee_demographics ORDER BY gender DESC, age DESC;

-- Using column positions instead of column names (not recommended)

-- The HAVING clause is used to filter results after applying aggregate functions, 
-- unlike WHERE, which filters rows before aggregation.

-- Filtering grouped data where the average age is greater than 40
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;

-- Using an alias (AVG_age) for the average age and filtering based on it
SELECT gender, AVG(age) AS AVG_age
FROM employee_demographics
GROUP BY gender
HAVING AVG_age > 40;
SELECT * FROM employee_demographics ORDER BY 5 DESC, 4 DESC;
-- Note: Best practice is to use column names for clarity and maintainability.
