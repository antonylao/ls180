/*3.13. Converting a 1:M Relationship to a M:M Relationship*/

-- 1) Import this file: films7.sql (https://raw.githubusercontent.com/launchschool/sql_course_data/master/sql-and-relational-databases/relational-data-and-joins/converting-a-1m-relationship-to-a-mm-relationship/films7.sql) into a database using psql.
createdb ls180_lesson3_13
psql -d ls180_lesson3_13 < dump_files/films7.sql
-- 2) Write the SQL statement needed to create a join table that will allow a film to have multiple directors, and directors to have multiple films. Include an id column in this table, and add foreign key constraints to the other columns.
CREATE TABLE directors_films (
    id serial PRIMARY KEY,
    director_id integer NOT NULL REFERENCES directors (id) ON DELETE CASCADE,
    film_id integer NOT NULL REFERENCES films (id) ON DELETE CASCADE,
    UNIQUE (director_id, film_id)
);
-- 3) Write the SQL statements needed to insert data into the new join table to represent the existing one-to-many relationships.
SELECT id AS film_id, director_id FROM films;
/*
 film_id | director_id
---------+-------------
       1 |           1
       2 |           2
       3 |           3
       4 |           4
       5 |           5
       6 |           6
       7 |           3
       8 |           7
       9 |           8
      10 |           4
(10 rows)
*/
INSERT INTO directors_films (film_id, director_id)
VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 3), (8, 7), (9, 8), (10, 4);
/*or*/
INSERT INTO directors_films (film_id, director_id)
  (SELECT id AS film_id, director_id FROM films);

-- 4) Write a SQL statement to remove any unneeded columns from films.
/*remove director_id */
ALTER TABLE films
 DROP COLUMN director_id;
-- 5) Write a SQL statement that will return the following result:
  /*
             title           |         name
  ---------------------------+----------------------
   12 Angry Men              | Sidney Lumet
   1984                      | Michael Anderson
   Casablanca                | Michael Curtiz
   Die Hard                  | John McTiernan
   Let the Right One In      | Michael Anderson
   The Birdcage              | Mike Nichols
   The Conversation          | Francis Ford Coppola
   The Godfather             | Francis Ford Coppola
   Tinker Tailor Soldier Spy | Tomas Alfredson
   Wayne's World             | Penelope Spheeris
  (10 rows)
  */
SELECT films.title, directors.name
  FROM films
       INNER JOIN directors_films
       ON films.id = directors_films.film_id
       INNER JOIN directors
       ON directors.id = directors_films.director_id
 ORDER BY films.title;

-- 6) Write SQL statements to insert data for the following films into the database:
  /*
  Film 	Year 	Genre 	Duration 	Directors
  Fargo 	1996 	comedy 	98 	Joel Coen
  No Country for Old Men 	2007 	western 	122 	Joel Coen, Ethan Coen
  Sin City 	2005 	crime 	124 	Frank Miller, Robert Rodriguez
  Spy Kids 	2001 	scifi 	88 	Robert Rodriguez
  */
/* insert first data into tables without foreign keys */
/* A. insert directors */
  /* a. Find out which directors to insert */
CREATE TABLE temp_directors (
    id serial,
    name text
);
INSERT INTO temp_directors (name) VALUES ('Joel Coen'), ('Joel Coen'), ('Ethan Coen'), ('Frank Miller'), ('Robert Rodriguez'), ('Robert Rodriguez');

DELETE FROM directors
  WHERE id BETWEEN 9 AND 12
ALTER SEQUENCE directors_id_seq RESTART WITH 9;

/* we use group by instead of SELECT DISTINCT for ordering like in LS solution */
SELECT name AS new_directors
  FROM temp_directors
 WHERE name NOT IN (SELECT name FROM directors)
 GROUP BY new_directors
 ORDER BY MIN(id);
/*
  new_directors
------------------
 Frank Miller
 Robert Rodriguez
 Joel Coen
 Ethan Coen
*/
  /* b. insert into directors table the new directors */
INSERT INTO directors (name)
       (SELECT name AS new_directors
          FROM temp_directors
         WHERE name NOT IN (SELECT name FROM directors)
         GROUP BY new_directors
         ORDER BY MIN(id)
       );
  /* c. Delete the temp table */
DROP TABLE temp_directors;
/* B. Insert films */
  /*
  Film 	Year 	Genre 	Duration 	Directors
  Fargo 	1996 	comedy 	98 	Joel Coen
  No Country for Old Men 	2007 	western 	122 	Joel Coen, Ethan Coen
  Sin City 	2005 	crime 	124 	Frank Miller, Robert Rodriguez
  Spy Kids 	2001 	scifi 	88 	Robert Rodriguez
  */
INSERT INTO films (title, year, genre, duration)
VALUES ('Fargo', 1996, 'comedy', 98), --id 11
       ('No Country for Old Men', 2007, 'western', 122),
       ('Sin City', 2005, 'crime', 124),
       ('Spy Kids', 2001, 'scifi', 88); --id 14
/*C. Insert rows in join table */
/* 9 | Joel Coen ; 10 | Ethan Coen ; 11 | Frank Miller ; 12 | Robert Rodriguez */
INSERT INTO directors_films (film_id, director_id)
VALUES (11, 9),
       (12, 9), (12, 10),
       (13, 11), (13, 12),
       (14, 12);
-- 7) Write a SQL statement that determines how many films each director in the database has directed. Sort the results by number of films (greatest first) and then name (in alphabetical order).
/*assumes that every director has at least one film*/
SELECT directors.name, COUNT(directors_films.id) AS films
  FROM directors
       INNER JOIN directors_films
       ON directors.id = directors_films.director_id
 GROUP BY directors.id
 ORDER BY COUNT(directors_films.id) DESC, directors.name;