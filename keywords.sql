-- DISTINCT: Removes duplicate values from query results
SELECT DISTINCT department 
FROM employees;

-- JOIN: Combines data from multiple tables
-- INNER JOIN example: Retrieves employees with their salaries
SELECT employees.first_name, employees.last_name, employee_salary.salary
FROM employees
INNER JOIN employee_salary ON employees.id = employee_salary.employee_id;

-- LIMIT: Restricts the number of rows returned
-- Get the top 5 highest salaries
SELECT * 
FROM employee_salary 
ORDER BY salary DESC 
LIMIT 5;
