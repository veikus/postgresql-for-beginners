# Lesson 3: CRUD operations. SELECT operation

The SELECT statement is the most commonly used SQL command. It allows you to retrieve data from one or more tables in
your database. With SELECT, you can filter, sort, and limit the results to obtain exactly the data you need. It is
widely used in reporting, data analysis, and web applications to retrieve information stored in the database.

[Official documentation for SELECT](https://www.postgresql.org/docs/16/sql-select.html)

The basic syntax of the SELECT statement is:

```sql
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

Example:

```sql
SELECT email, job_title
FROM users
WHERE id = 1000;
```

## Retrieving all columns

To retrieve all columns from a table, you can use the * wildcard:

```sql
SELECT *
FROM users;
```

This will return all columns and all rows in the users table.

*Note: Using SELECT * is often discouraged in production environments, especially when working with large tables. It
retrieves all columns, which may include unnecessary data and affect performance. It’s better to explicitly specify the
columns you need when possible.*

## Retrieving Specific Columns

If you only need specific columns, list them explicitly:

```sql
SELECT id, email FROM users;
```

This query retrieves only the id and email columns from the users table.

## Filtering Rows with WHERE

The WHERE clause is used to filter the rows returned by a query. For example:

```sql
SELECT *
FROM users
WHERE email = 'kissmyshiny@planetexpress.com';
```

This query returns only the rows where the email column matches 'kissmyshiny@planetexpress.com'.

In addition to simple conditions like = or !=, you can use comparison operators (>, <, >=, <=) and pattern matching with
LIKE.

For example, to find all users with an email from "Planet Express", use LIKE:

```sql
SELECT * 
FROM users 
WHERE email LIKE '%@planetexpress.com';
```

This query returns all rows where the email column contains “@planetexpress.com”.

## Using Logical Operators

You can use logical operators such as AND, OR, and NOT to combine multiple conditions in the WHERE clause:

```sql
SELECT * FROM events
WHERE created_at >= '2024-09-11' AND user_id = 2;
```

This will return only 1 record that matches both conditions.

```text
 id | user_id | name  |         created_at
----+---------+-------+----------------------------
  2 |       2 | Party | 2024-09-11 10:35:24.667882
```

## Sorting Results with ORDER BY

The ORDER BY clause is used to sort the results of a query. For example:

```sql
SELECT * FROM users
ORDER BY email ASC;
```

This query returns all users sorted by email in ascending order.

In addition to sorting in ascending order (ASC), you can sort in descending order (DESC):

```sql
SELECT * FROM users
ORDER BY id DESC;
```

This query returns all users sorted by id in descending order, meaning the largest id will appear first.

## Limiting Results with LIMIT

The LIMIT clause is used to restrict the number of rows returned by a query. For example:

```sql
SELECT * FROM users
ORDER BY email ASC
LIMIT 2;
```

This query returns only 2 rows from the users table.

## Limiting and Offsetting Results

```sql
SELECT * FROM users
ORDER BY email ASC
LIMIT 2 OFFSET 1;
```

This query returns 2 rows from the users table, starting from the second row.

## Aggregating data

You can use aggregate functions to perform calculations on the data in your tables. Let's add a new column to the users
table with a company name:

```sql
ALTER TABLE users ADD COLUMN company_name VARCHAR(255);
UPDATE users SET company_name = 'Planet Express' WHERE email LIKE '%@planetexpress.com';
UPDATE users SET company_name = 'MomCorp' WHERE email LIKE '%@momcorp.com';
UPDATE users SET company_name = 'DOOP' WHERE email LIKE '%@doop.org';
UPDATE users SET company_name = 'NNYPD' WHERE email LIKE '%@newnewyorkpolice.com';
```

Now you can use aggregate functions to count the number of users in each company:

```sql
SELECT company_name, COUNT(*)
FROM users
GROUP BY company_name;
```

This query returns the number of users in each company.

```text
  company_name  | count
----------------+-------
 NNYPD          |     2
 DOOP           |     1
 Planet Express |     7
 MomCorp        |     1
(4 rows)
```

You can filter aggregated results using the HAVING clause:

```sql
SELECT company_name, COUNT(*)
FROM users
GROUP BY company_name
HAVING COUNT(*) > 1;
```

This query returns only companies with more than 1 users.

```text
  company_name  | count
----------------+-------
 NNYPD          |     2
 Planet Express |     7
(2 rows)
```

In addition to COUNT(), PostgreSQL provides other useful aggregate functions such as SUM(), AVG(), MIN(), and MAX().
These are often used in reporting or to calculate statistics on numeric columns.

## Joining tables

Before diving into the types of joins, it’s important to understand why joins are used. In relational databases, data is
often stored across multiple tables. A JOIN allows you to retrieve related data from these different tables by combining
them on a shared key (often a foreign key).

```sql
SELECT * FROM events
JOIN users ON events.user_id = users.id;
```

This query returns all events with user data.

```text
 id | user_id | name  |         created_at         | id |             email             |           name           | job_title |  company_name
----+---------+-------+----------------------------+----+-------------------------------+--------------------------+-----------+----------------
  2 |       2 | Party | 2024-09-11 10:35:24.667882 |  2 | kissmyshiny@planetexpress.com | Bender Bending Rodríguez |           | Planet Express
(1 row)
```

You can also use aliases to make the query more readable:

```sql
SELECT e.id, e.name, e.created_at, u.email, u.name AS user_name
FROM events e
JOIN users u ON e.user_id = u.id;
```

This is also useful when you have same column names in different tables.

There are also different types of joins: INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN. Each type of join has its own
use case.

**INNER JOIN**
An INNER JOIN returns only the records that have matching values in both tables.
In other words, it combines rows from two or more tables based on a related column between them,
but only where the condition is met.

It's a default join type, so you can omit the INNER keyword:

```sql
SELECT e.id, e.name, e.created_at, u.email, u.name AS user_name
FROM events e
INNER JOIN users u ON e.user_id = u.id;
```

This will return only the events that have a corresponding user in the users table.
If an event doesn’t have an associated user, it won’t appear in the result.

**LEFT JOIN**

A LEFT JOIN returns all records from the left table (the first table mentioned), and the matched records from the right
table. If there is no match, the result is NULL on the right side.

```sql
SELECT e.id, e.name, e.created_at, u.email, u.name AS user_name
FROM events e
LEFT JOIN users u ON e.user_id = u.id;
```

This will return all events, even if there is no associated user. For events without a user, the columns from the users
table will contain NULL.

**RIGHT JOIN**
A RIGHT JOIN returns all records from the right table (the second table mentioned), and the matched records from the
left table. If there is no match, the result is NULL on the left side.

```sql
SELECT e.id, e.name, e.created_at, u.email, u.name AS user_name
FROM events e
RIGHT JOIN users u ON e.user_id = u.id;
```

This will return all users, even if they haven’t created any events. If a user has no events, the columns from the
events table will contain NULL.

**FULL JOIN**
A FULL JOIN returns all records when there is a match in either the left or right table. It combines the results of both
LEFT JOIN and RIGHT JOIN.

```sql
SELECT e.id, e.name, e.created_at, u.email, u.name AS user_name
FROM events e
FULL JOIN users u ON e.user_id = u.id;
```

This will return all events and all users, with NULL values wherever there isn’t a match.

**CROSS JOIN**
A CROSS JOIN returns the Cartesian product of the two tables. This means it combines each row of the first table with
all rows of the second table.

```sql
SELECT e.id, e.name, u.name AS user_name
FROM events e
CROSS JOIN users u;
```

## Using Subqueries

A subquery is a query nested inside another query. You can use subqueries to filter, sort, or aggregate data.

For example, to find all users who have created an event:

```sql
SELECT *
FROM users
WHERE id IN (SELECT user_id FROM events);
```

This query returns all users who have created an event.
The same result can be achieved with a JOIN:

```sql
SELECT u.*
FROM users u
JOIN events e ON u.id = e.user_id;
```

Both queries return the same result.

```text
playground=# SELECT *
FROM users
WHERE id IN (SELECT user_id FROM events);
 id |             email             |           name           | job_title |  company_name
----+-------------------------------+--------------------------+-----------+----------------
  2 | kissmyshiny@planetexpress.com | Bender Bending Rodríguez |           | Planet Express
(1 row)


playground=# SELECT u.*
FROM users u
JOIN events e ON u.id = e.user_id;
 id |             email             |           name           | job_title |  company_name
----+-------------------------------+--------------------------+-----------+----------------
  2 | kissmyshiny@planetexpress.com | Bender Bending Rodríguez |           | Planet Express
(1 row)
```

**Types of Subqueries:** Subqueries can return different types of results:

* Scalar subquery: Returns a single value.
* Table subquery: Returns multiple rows and columns.
* Set subquery: Returns a set of values that can be used with IN.

[//]: <> (TODO: Find a better example)

For example, a scalar subquery could be used to retrieve a specific value:

```sql
SELECT * FROM users WHERE
id = (SELECT user_id FROM events WHERE name = 'Party' LIMIT 1)
```

This query returns the user who created the event named 'Party'.

## Using DISTINCT to Remove Duplicates

If you need to remove duplicate rows from your results, use the DISTINCT keyword:

```sql
SELECT DISTINCT company_name
FROM users;
```

This query returns only unique company names from the users table.

```text
  company_name
----------------
 NNYPD
 DOOP
 Planet Express
 MomCorp
(4 rows)
```