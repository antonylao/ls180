/*2.11.Using Keys*/

/*creates table regions : not used afterwards*/

-- 0) films3.sql (https://raw.githubusercontent.com/launchschool/sql_course_data/master/sql-and-relational-databases/schema-data-and-sql/using-keys/films3.sql) loaded into database at this point
-- 1) Write a SQL statement that makes a new sequence called "counter".
CREATE SEQUENCE counter;
-- 2) Write a SQL statement to retrieve the next value from the sequence created in #1.
SELECT nextval('counter');
-- 3) Write a SQL statement that removes a sequence called "counter".
DROP SEQUENCE counter;
-- 4) Is it possible to create a sequence that returns only even numbers? The documentation for sequence might be useful.
   CREATE SEQUENCE even_counter
INCREMENT BY 2
 MINVALUE 2;
-- 5) What will the name of the sequence created by the following SQL statement be?
--   CREATE TABLE regions (id serial PRIMARY KEY, name text, area integer);
/* Answer: regions_id_seq */
-- 6) Write a SQL statement to add an auto-incrementing integer primary key column to the films table.
ALTER TABLE films
  ADD COLUMN id serial PRIMARY KEY;
-- 7) What error do you receive if you attempt to update a row to have a value for id that is used by another row?
UPDATE films
   SET id = 3
 WHERE id = 4;
/*
ERROR:  duplicate key value violates unique constraint "films_pkey"
DETAIL:  Key (id)=(3) already exists.
*/
-- 8) What error do you receive if you attempt to add another primary key column to the films table?
ALTER TABLE films
  ADD COLUMN id2 text PRIMARY KEY;
/* ERROR:  multiple primary keys for table "films" are not allowed */
-- 9) Write a SQL statement that modifies the table films to remove its primary key while preserving the id column and the values it contains.
ALTER TABLE films
 DROP CONSTRAINT films_pkey;