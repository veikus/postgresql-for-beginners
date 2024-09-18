/*
  You can use this file to get the same database state as the one used in the course.
  It's not exactly the same queries, but it will give you the same result.
*/

-- Lesson 1
CREATE DATABASE playground
  WITH
  OWNER = postgres
  ENCODING = 'UTF8'
  LOCALE_PROVIDER = 'libc'
  CONNECTION LIMIT = -1
  IS_TEMPLATE = False;

\c playground

CREATE TABLE users
(
  id SERIAL PRIMARY KEY,
  email TEXT,
  name TEXT
);

INSERT INTO users (email, name) VALUES
('kissmyshiny@planetexpress.com', 'Bender Bending Rodríguez'),
('captain.leela@planetexpress.com', 'Turanga Leela'),
('philip.j.fry@planetexpress.com', 'Philip J. Fry'),
('professor@planetexpress.com', 'Professor Hubert J. Farnsworth'),
('dr.zoidberg@planetexpress.com', 'Dr. John A. Zoidberg'),
('amy.wong@planetexpress.com', 'Amy Wong'),
('hermes.conrad@planetexpress.com', 'Hermes Conrad');

-- Lesson 2
INSERT INTO users (email, name)
VALUES
  ('robocop@newnewyorkpolice.com', 'Officer URL'),
  ('smitty@newnewyorkpolice.com', 'Officer Smitty');

INSERT INTO users
VALUES (1000, 'zapp@doop.org', 'Captain');

INSERT INTO users (email)
VALUES ('mom@momcorp.com');

ALTER TABLE users ADD CONSTRAINT email_unique UNIQUE (email);
ALTER TABLE users ADD COLUMN job_title VARCHAR(255);

CREATE TABLE events (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  name VARCHAR(255) DEFAULT 'Unnamed Event',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO events DEFAULT VALUES;
INSERT INTO events (user_id, name)
VALUES (2, 'Party')

-- Lesson 3
ALTER TABLE users ADD COLUMN company_name VARCHAR(255);
UPDATE users SET company_name = 'Planet Express' WHERE email LIKE '%@planetexpress.com';
UPDATE users SET company_name = 'MomCorp' WHERE email LIKE '%@momcorp.com';
UPDATE users SET company_name = 'DOOP' WHERE email LIKE '%@doop.org';
UPDATE users SET company_name = 'NNYPD' WHERE email LIKE '%@newnewyorkpolice.com';