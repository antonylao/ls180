/*2.10.More Constraints*/

/*creates table video_games (only used as an example)*/

-- 1) Import this file: films2.sql (https://raw.githubusercontent.com/launchschool/sql_course_data/master/sql-and-relational-databases/schema-data-and-sql/more-constraints/films2.sql) into a PostgreSQL database.
psql -d ls180_lesson2 < dump_files/films2.sql
-- 2) Modify all of the columns to be NOT NULL.
ALTER TABLE films ALTER COLUMN title SET NOT NULL;
ALTER TABLE films ALTER COLUMN year SET NOT NULL;
ALTER TABLE films ALTER COLUMN genre SET NOT NULL;
ALTER TABLE films ALTER COLUMN director SET NOT NULL;
ALTER TABLE films ALTER COLUMN duration SET NOT NULL;
-- 3) How does modifying a column to be NOT NULL affect how it is displayed by \d films?
/* Answer: add 'not null' in Modifiers column */
-- 4) Add a constraint to the table films that ensures that all films have a unique title.
ALTER TABLE films
  ADD CONSTRAINT title_unique UNIQUE (title);
-- 5) How is the constraint added in #4 displayed by \d films?
/* Answer: as an index */
-- 6) Write a SQL statement to remove the constraint added in #4.
ALTER TABLE films
 DROP CONSTRAINT title_unique;
-- 7) Add a constraint to films that requires all rows to have a value for title that is at least 1 character long.
ALTER TABLE films
  ADD CONSTRAINT title_length CHECK (length(title) >= 1);
-- 8) What error is shown if the constraint created in #7 is violated? Write a SQL INSERT statement that demonstrates this.
/* Answer: new row for relation "films" violates check constraint "title_length"*/
INSERT INTO films (title, year, genre, director, duration) VALUES ('', 1901, 'action', 'JJ Abrams', 126);
-- 9) How is the constraint added in #7 displayed by \d films?
/* Answer: as a check constraint */
-- 10) Write a SQL statement to remove the constraint added in #7.
ALTER TABLE films
 DROP CONSTRAINT title_length;
-- 11) Add a constraint to the table films that ensures that all films have a year between 1900 and 2100.
ALTER TABLE films
  ADD CONSTRAINT year_range CHECK (year BETWEEN 1900 AND 2100);
-- 12) How is the constraint added in #11 displayed by \d films?
/* Answer: as a check constraint */
-- 13) Add a constraint to films that requires all rows to have a value for director that is at least 3 characters long and contains at least one space character ().
ALTER TABLE films
  ADD CONSTRAINT director_name CHECK (length(director) >= 3 AND director LIKE '% %');
--                                                       /*or*/ position(' ' in director) = 0;
-- 14) How does the constraint created in #13 appear in \d films?
/* Answer: as a check constraint */
-- 15) Write an UPDATE statement that attempts to change the director for "Die Hard" to "Johnny". Show the error that occurs when this statement is executed.
UPDATE films
   SET director = 'Johnny'
 WHERE title = 'Die Hard';
/*
ERROR:  new row for relation "films" violates check constraint "director_name"
DETAIL:  Failing row contains (Die Hard, 1988, action, Johnny, 132).
*/
-- 16) List three ways to use the schema to restrict what values can be stored in a column.
/* NOT NULL, CHECK, column data type */
-- 17) Is it possible to define a default value for a column that will be considered invalid by a constraint? Create a table that tests this.
/* Yes. For example, when not specifying a DEFAULT, it is set automatically to null. We can later add NOT NULL constraints but the default would still be null. */
CREATE TABLE video_games (
    name  text,
    price decimal(5, 2) DEFAULT -1,
    CONSTRAINT price_positive CHECK (price >= 0)
);
INSERT INTO video_games (name) VALUES ('FF6');
-- 18) How can you see a list of all of the constraints on a table?
\d table_name