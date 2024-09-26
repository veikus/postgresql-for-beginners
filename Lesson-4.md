# Lesson 4: Exercises on Conditions, Joins, and Subqueries

In this lesson, we’ll focus on practicing the concepts of conditions, joins, and subqueries through exercises. We’ll
first set up a new database, populate it with data, and then solve several exercises using various SQL queries.

## Setting Up the Database

Let’s create a new database called company_db and two tables: employees and departments. We will then insert some
initial data into these tables.

```sql
CREATE DATABASE company_db;

\c company_db;

CREATE TABLE departments (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  location VARCHAR(255)
);

CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  department_id INT REFERENCES departments(id),
  salary DECIMAL(10, 2),
  hire_date DATE
);

CREATE TABLE projects (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  start_date DATE,
  end_date DATE,
  department_id INT REFERENCES departments(id)
);

CREATE TABLE employee_projects (
  employee_id INT REFERENCES employees(id),
  project_id INT REFERENCES projects(id),
  role VARCHAR(255),
  PRIMARY KEY (employee_id, project_id)
);

INSERT INTO departments (name, location) 
VALUES 
  ('Engineering', 'New York'),
  ('Human Resources', 'London'),
  ('Marketing', 'San Francisco'),
  ('Sales', 'Chicago');

INSERT INTO employees (name, email, department_id, salary, hire_date)
VALUES
  ('Alice Johnson', 'alice@company.com', 1, 75000, '2020-01-15'),
  ('Bob Smith', 'bob@company.com', 2, 60000, '2019-03-12'),
  ('Charlie Lee', 'charlie@company.com', 1, 82000, '2021-08-22'),
  ('Diana Prince', 'diana@company.com', 3, 54000, '2018-07-30'),
  ('Eve Turner', 'eve@company.com', 4, 67000, '2017-05-11'),
  ('Frank White', 'frank@company.com', 2, 62000, '2020-11-03');
  
INSERT INTO projects (name, start_date, end_date, department_id)
VALUES 
  ('Website Redesign', '2023-02-01', '2023-09-30', 1),
  ('HR System Overhaul', '2022-10-01', '2023-12-31', 2),
  ('Marketing Campaign', '2023-01-15', NULL, 3),
  ('New Sales Strategy', '2023-03-01', NULL, 4);

INSERT INTO employee_projects (employee_id, project_id, role)
VALUES 
  (1, 1, 'Lead Developer'),
  (2, 2, 'Project Manager'),
  (3, 1, 'Backend Developer'),
  (4, 3, 'Marketing Specialist'),
  (5, 4, 'Sales Consultant'),
  (6, 2, 'HR Specialist');
```

## Exercise 1: Retrieve Top Paid Employees with ORDER BY and LIMIT

Write a query to retrieve the top 3 highest-paid employees, sorted by salary in descending order.

```sql
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 3;
```

## Exercise 2: Find Employees Earning Above Average Salary Using Subquery

Write a query to find all employees who earn more than the average salary of all employees.

```sql
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

## Exercise 3: Find Employees in the Same Department as Charlie Lee Using Subquery

Write a query to select all employees who work in the same department as ‘Charlie Lee’.

```sql
SELECT name, email
FROM employees
WHERE department_id = (SELECT department_id FROM employees WHERE name = 'Charlie Lee');
```

## Exercise 4: Find Employee with Highest Salary Using Subquery

Write a query to find the name of the employee who earns the highest salary in the company.

```sql
SELECT name
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);
```

## Exercise 5: Find Departments with High-Earning Employees Using EXISTS

Write a query to select all departments that have at least one employee earning more than $60,000.

```sql
SELECT name
FROM departments d
WHERE EXISTS (
  SELECT 1
  FROM employees e
  WHERE e.department_id = d.id AND e.salary > 60000
);
```

## Exercise 6: Retrieve Employees in Engineering Earning Above $70,000 Using JOIN

Write a query to select all employees who work in the Engineering department and earn more than $70,000.

```sql
SELECT e.name, e.salary, d.name AS department
FROM employees e
JOIN departments d ON e.department_id = d.id
WHERE d.name = 'Engineering' AND e.salary > 70000;
```

## Exercise 7: Find Employees Hired Before 2020 in Sales or HR Using JOIN

Write a query to select the name and email of all employees who were hired before 2020 and work in either the Sales or
Human Resources departments.

```sql
SELECT e.name, e.email, d.name AS department
FROM employees e
JOIN departments d ON e.department_id = d.id
WHERE e.hire_date < '2020-01-01' AND d.name IN ('Sales', 'Human Resources');
```

## Exercise 8: Calculate Average Salary Per Department Using Aggregates

Write a query to calculate the average salary of employees in each department.

```sql
SELECT d.name AS department, AVG(e.salary) AS average_salary
FROM employees e
JOIN departments d ON e.department_id = d.id
GROUP BY d.name;
```

## Exercise 9: Find Departments with More than Two Employees Using HAVING

Write a query to find all departments with more than 2 employees.

```sql
SELECT d.name AS department, COUNT(e.id) AS employee_count
FROM departments d
JOIN employees e ON e.department_id = d.id
GROUP BY d.name
HAVING COUNT(e.id) > 2;
```

## Exercise 10: Find Employees Assigned to More than One Project Using GROUP BY

Write a query to find all employees who are working on more than one project.

```sql
SELECT e.name, COUNT(ep.project_id) AS project_count
FROM employees e
JOIN employee_projects ep ON e.id = ep.employee_id
GROUP BY e.name
HAVING COUNT(ep.project_id) > 1;
```

## Exercise 11: Find Projects Without Any Employees Assigned Using LEFT JOIN

Write a query to find all projects that don’t have any employees assigned to them.

```sql
SELECT p.name AS project_name
FROM projects p
LEFT JOIN employee_projects ep ON p.id = ep.project_id
WHERE ep.employee_id IS NULL;
```

## Exercise 12: Find Employees Without a Department Using LEFT JOIN

Write a query to find all employees who are not assigned to any department.

```sql
SELECT e.name, e.email
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id
WHERE d.id IS NULL;
```

## Exercise 13: Find Employees Without a Project Using LEFT JOIN

Write a query to find all employees who are not assigned to any project.

```sql
SELECT e.name
FROM employees e
LEFT JOIN employee_projects ep ON e.id = ep.employee_id
WHERE ep.project_id IS NULL;
```

## Exercise 14: Calculate Total Employees Per Project Using Aggregates

Write a query to find the total number of employees working on each project.

```sql
SELECT p.name AS project_name, COUNT(ep.employee_id) AS total_employees
FROM projects p
LEFT JOIN employee_projects ep ON p.id = ep.project_id
GROUP BY p.name;
```

## Exercise 15: Retrieve Employees and Their Projects Using Multiple JOINs

Write a query to retrieve the list of employees along with the projects they are working on.

```sql
SELECT e.name AS employee_name, p.name AS project_name, ep.role
FROM employees e
JOIN employee_projects ep ON e.id = ep.employee_id
JOIN projects p ON ep.project_id = p.id;
```

## Exercise 16: Find Employees Working on Projects in Their Own Department

Write a query to find all employees who are working on projects within their own department.

```sql
SELECT e.name AS employee_name, p.name AS project_name, d.name AS department_name
FROM employees e
JOIN employee_projects ep ON e.id = ep.employee_id
JOIN projects p ON ep.project_id = p.id
JOIN departments d ON e.department_id = d.id
WHERE e.department_id = p.department_id;
```

## Exercise 17: Find Employees on Longest-Running Project Using Subqueries and JOINs

Write a query to find employees who are working on the longest-running project (the project with the largest date range
between start and end dates).

```sql
SELECT e.name
FROM employees e
JOIN employee_projects ep ON e.id = ep.employee_id
JOIN projects p ON ep.project_id = p.id
WHERE p.id = (
  SELECT id FROM projects
  WHERE end_date IS NOT NULL
  ORDER BY (end_date - start_date) DESC
  LIMIT 1
);
```

## Exercise 18: Find Department with Most Employees on Projects Using Nested Subqueries

Write a query to find the department that has the highest number of employees working on projects.

```sql
SELECT d.name
FROM departments d
JOIN employees e ON d.id = e.department_id
JOIN employee_projects ep ON e.id = ep.employee_id
GROUP BY d.name
ORDER BY COUNT(ep.project_id) DESC
LIMIT 1;
```

## Exercise 19: Find Departments with More than One Project and Employees Earning More than $60,000

Write a query to find all departments that have more than one project and at least one employee earning more than
60 000. Use both HAVING and WHERE clauses in a single query.

```sql
SELECT d.name AS department_name, COUNT(p.id) AS project_count
FROM departments d
JOIN projects p ON d.id = p.department_id
JOIN employees e ON d.id = e.department_id
WHERE e.salary > 60000
GROUP BY d.name
HAVING COUNT(p.id) > 1;
```