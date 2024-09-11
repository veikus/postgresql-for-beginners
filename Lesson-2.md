# Lesson 2: CRUD operations. INSERT operation

The INSERT statement adds one or more new rows of data to a specific table in your database. Each row represents
a new record, and each column holds specific data relevant to that record.

[Official documentation for INSERT](https://www.postgresql.org/docs/16/sql-insert.html)

The basic syntax of the INSERT statement is:

```sql
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);
```

Example:

```sql
INSERT INTO users (email, name)
VALUES 
  ('robocop@newnewyorkpolice.com', 'Officer URL'),
  ('smitty@newnewyorkpolice.com', 'Officer Smitty');
```

You can also insert values without column names, but you had to insert them in correct order

```sql
INSERT INTO users
VALUES (1000, 'zapp@doop.org', 'Captain Zapp Brannigan');
```

We have manually inserted the id value. It’s not recommended to do this, as it can lead to conflicts and errors
in future. It's better not to insert id value and let PostgreSQL handle it.

### Default values

If a column has a default value or allows NULL, you can choose not to insert data into that column.
PostgreSQL will use the default value or NULL for that column:

```sql
INSERT INTO users (email)
VALUES ('mom@momcorp.com');
```

In this case id will have a default value from a serial sequence and name will be NULL.

### Handling Conflicts with ON CONFLICT

Sometimes, you might want to insert data but avoid inserting duplicates.
Before we continue, let's make an email column unique and try to insert a new user. And add a new column "job_title".

```sql
ALTER TABLE users ADD CONSTRAINT email_unique UNIQUE (email);
ALTER TABLE users ADD COLUMN job_title VARCHAR(255);
```

Now let's try to insert a new value with the same email and see what happens:

```sql
INSERT INTO users (email)
VALUES ('zapp@doop.org')
ON CONFLICT (id) DO NOTHING;
```

We will see an error:

```text
VALUES ('zapp@doop.org');
ERROR:  duplicate key value violates unique constraint "email_unique"
DETAIL:  Key (email)=(zapp@doop.org) already exists.
```

PostgreSQL offers the ON CONFLICT clause to handle this. Let's add it and see the difference:

```sql
INSERT INTO users (email)
VALUES ('zapp@doop.org')
ON CONFLICT (email) DO NOTHING;
```

Postgres will skip the INSERT and do nothing.

```text
INSERT 0 0
```

Alternatively, you can update the existing row instead of skipping:

```sql
INSERT INTO users (email, job_title)
VALUES ('zapp@doop.org', 'Captain')
ON CONFLICT (email) 
DO UPDATE SET job_title = EXCLUDED.job_title;
```

Here, if a conflict on email occurs, the job_title value will be updated to 'Captain'.

```text
  id  |              email              |              name              | job_title
------+---------------------------------+--------------------------------+-----------
    2 | kissmyshiny@planetexpress.com   | Bender Bending Rodríguez       |
    3 | captain.leela@planetexpress.com | Turanga Leela                  |
    4 | philip.j.fry@planetexpress.com  | Philip J. Fry                  |
    5 | professor@planetexpress.com     | Professor Hubert J. Farnsworth |
    6 | dr.zoidberg@planetexpress.com   | Dr. John A. Zoidberg           |
    7 | amy.wong@planetexpress.com      | Amy Wong                       |
    8 | hermes.conrad@planetexpress.com | Hermes Conrad                  |
    9 | robocop@newnewyorkpolice.com    | Officer URL                    |
   10 | smitty@newnewyorkpolice.com     | Officer Smitty                 |
   11 | mom@momcorp.com                 |                                |
 1000 | zapp@doop.org                   | Captain Zapp Brannigan         | Captain
(11 rows)
```

The same applies to a conflicts on id. If you try to insert a new user with the same id, you can skip it or update.

```sql
INSERT INTO users (id, email, job_title)
VALUES (1000, 'zapper@doop.org', 'Twenty-Five Star General')
ON CONFLICT (id) 
DO UPDATE SET email = EXCLUDED.email, job_title = EXCLUDED.job_title;
```

### Default values

Sometimes we just need to create a new line with default values. If all columns have a default values or allow NULL we
can use this syntax to create a new row.

Let’s create a new table and insert a new row.

```sql
CREATE TABLE events (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  name VARCHAR(255) DEFAULT 'Unnamed Event',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

```sql
INSERT INTO events DEFAULT VALUES;
```

It will create a new event:

```text
 id | user_id |     name      |        created_at
----+---------+---------------+---------------------------
  1 |         | Unnamed Event | 2024-09-11 10:31:53.12577
(1 row)
```

### Returning values

Let’s imagine that we need to create a new row and get it’s ID and timestamp. We can create it with 2 requests or use
RETURNING:

```sql
INSERT INTO events (user_id, name)
VALUES (2, 'Party')
RETURNING id, created_at;
```

It will create a new event and return it’s id and created_at date:

```text
RETURNING id, created_at;
 id |         created_at
----+----------------------------
  2 | 2024-09-11 10:35:24.667882
(1 row)
```

That's all on INSERT operation.