# Lesson 5: CRUD Operations. UPDATE Operation

The UPDATE statement is used to modify existing records in a table. This operation allows you to change specific rows or
all rows in a table, depending on the conditions provided. Since an UPDATE can potentially overwrite all data in a
table, use it carefully, especially when omitting the WHERE clause.

[Official documentation for UPDATE](https://www.postgresql.org/docs/16/sql-update.html)

The basic syntax of the UPDATE statement is:

```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

Example:

```sql
UPDATE users
SET job_title = 'Chief Officer'
WHERE email = 'robocop@newnewyorkpolice.com';
```

This query updates the job title of the user whose email matches 'robocop@newnewyorkpolice.com'.


## Updating multiple rows

You can update multiple rows by specifying a condition in the WHERE clause:

```sql
UPDATE users
SET job_title = 'Senior Engineer'
WHERE company_name = 'Planet Express';
```

This query updates the job title for all users working at “Planet Express.”


## Updating without a WHERE clause

If you omit the WHERE clause, all rows in the table will be updated. This can lead to unintended consequences, so always
double-check before running such a query (especially on production).

```sql
UPDATE users
SET job_title = 'General Employee';
```

This query will set the job_title for all users to “General Employee.”


## Updating multiple columns

You can update multiple columns in a single query:

```sql
UPDATE users
SET
  job_title = 'General Employee',
  company_name = 'Planet Express'
WHERE job_title = 'Intern';
```

This query will update the job_title and company_name for all users with the job_title “Intern.”


## Using Subqueries in UPDATE

A subquery can be used to set a column value based on data from another table. For example:

```sql
UPDATE users
SET company_name = (
  SELECT name
  FROM departments
  WHERE users.department_id = departments.id
);
```

This query updates the company_name of users based on the name of their associated department.


## Returning Updated Data

To see which rows were updated, you can use the RETURNING clause:

```sql
UPDATE users
SET job_title = 'Lead Developer'
WHERE email = 'charlie@company.com'
RETURNING id, email, job_title;
```

The RETURNING clause outputs the updated rows:

```
 id | email               | job_title
----+---------------------+--------------
  3 | charlie@company.com | Lead Developer
(1 row) 
```


## Conditional Updates

You can use CASE expressions to apply conditional updates within the SET clause:

```sql
UPDATE users
SET job_title = 
  CASE 
    WHEN job_title = 'Intern' THEN 'Junior Developer'
    WHEN job_title = 'Junior Developer' THEN 'Developer'
    ELSE job_title
  END;
```

This query promotes users based on their current job title, leaving others unchanged.


## Handling Conflicts in UPDATE

If you’re updating a unique field, you might encounter conflicts. You can handle these by ensuring the update criteria
avoid duplicates, or consider using UPSERT techniques (combining INSERT and UPDATE).

