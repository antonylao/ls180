/*3.8. One-to-Many Relationships*/

-- 0) Import this file: one-to-many.sql (https://raw.githubusercontent.com/launchschool/sql_course_data/master/sql-and-relational-databases/relational-data-and-joins/one-to-many-relationships/one-to-many.sql) in a new database
createdb ls180_lesson3_8
psql -d ls180_lesson3_8 < dump_files/one-to-many.sql

-- 1) Write a SQL statement to add the following call data to the database:
  /*
  when 	duration 	first_name 	last_name 	number
  2016-01-18 14:47:00 	632 	William 	Swift 	7204890809
  */
/* William Swift's contact_id : 6 */
INSERT INTO calls ("when", duration, contact_id)
  VALUES ('2016-01-18 14:47:00', 632, 6);

-- 2) Write a SQL statement to retrieve the call times, duration, and first name for all calls not made to William Swift.
/* William Swift's contact_id : 6 */
SELECT calls."when" AS call_time, calls.duration, contacts.first_name
  FROM calls
       INNER JOIN contacts
       ON contacts.id = calls.contact_id
  WHERE contacts.id <> 6;

-- 3) Write SQL statements to add the following call data to the database:
  /*
  when 	duration 	first_name 	last_name 	number
  2016-01-17 11:52:00 	175 	Merve 	Elk 	6343511126
  2016-01-18 21:22:00 	79 	Sawa 	Fyodorov 	6125594874
  */
/* Merve Elk and Sawa Fyodorov : not in contacts table => add them first */
INSERT INTO contacts (first_name, last_name, "number")
       VALUES ('Merve', 'Elk', '6343511126'),
              ('Sawa', 'Fyodorov', '6125594874');
/* contact_ids should be: 26 for Merve, 27 for Sawa */
INSERT INTO calls ("when", duration, contact_id)
       VALUES ('2016-01-17 11:52:00', 175, 26),
              ('2016-01-18 21:22:00', 79, 27);

-- 4) Add a constraint to contacts that prevents a duplicate value being added in the column number.
ALTER TABLE contacts
  ADD CONSTRAINT number_unique UNIQUE ("number");
-- 5) Write a SQL statement that attempts to insert a duplicate number for a new contact but fails. What error is shown?
INSERT INTO contacts (first_name, last_name, "number")
  VALUES ('Nivi', 'Petrussen', '6125594874');
/* ERROR:  duplicate key value violates unique constraint "number_unique"
   DETAIL:  Key (number)=(6125594874) already exists. */

-- 6) Why does "when" need to be quoted in many of the queries in this lesson?
/* Answer: Because it is a reserved keywords. "" makes when a delimited (or quoted) identifier, which ensures it is not interpreted as a keyword */

-- 7) Draw an entity-relationship diagram for the data we've been working with in this assignment.
/* Answer: A call has a required single contact, a contact has optionally many calls */