# Lesson 3: CRUD operations. SELECT operation

The SELECT statement retrieves data from one or more tables in your database. You can filter, sort, and limit
the results to get the data you need.

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