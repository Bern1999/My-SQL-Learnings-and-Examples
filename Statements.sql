-- Selecting all records from a table
SELECT * FROM employees;

-- Inserting a new record into a table
INSERT INTO employees (id, name, position) VALUES (1, 'John Doe', 'Manager');

-- Updating a record in a table
UPDATE employees SET position = 'Senior Manager' WHERE id = 1;

-- Deleting a record from a table
DELETE FROM employees WHERE id = 1;
