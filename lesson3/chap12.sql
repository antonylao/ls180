/*3.12. Many-to-Many Relationships*/

-- 0) Import this file: many_to_many.sql (https://raw.githubusercontent.com/launchschool/sql_course_data/master/sql-and-relational-databases/relational-data-and-joins/many-to-many-relationships/many_to_many.sql)
createdb ls180_lesson3_12
psql -d ls180_lesson3_12 < dump_files/many_to_many.sql
-- 1) The books_categories table from this database was created with foreign keys that don't have the NOT NULL and ON DELETE CASCADE constraints. Go ahead and add them now.
ALTER TABLE books_categories
ALTER COLUMN book_id SET NOT NULL,
ALTER COLUMN category_id SET NOT NULL;

ALTER TABLE books_categories
 DROP CONSTRAINT books_categories_book_id_fkey,
  ADD CONSTRAINT books_categories_book_id_fkey
      FOREIGN KEY (book_id)
      REFERENCES books (id)
      ON DELETE CASCADE,
 DROP CONSTRAINT books_categories_category_id_fkey,
  ADD CONSTRAINT books_categories_category_id_fkey
      FOREIGN KEY (category_id)
      REFERENCES categories (id)
      ON DELETE CASCADE;

-- 2) Write a SQL statement that will return the following result:
  /*
   id |     author      |           categories
  ----+-----------------+--------------------------------
    1 | Charles Dickens | Fiction, Classics
    2 | J. K. Rowling   | Fiction, Fantasy
    3 | Walter Isaacson | Nonfiction, Biography, Physics
  (3 rows)
  */
SELECT books.id,
       books.author,
       string_agg(categories.name, ', ') AS categories
  FROM books
       INNER JOIN books_categories
       ON books.id = books_categories.book_id
       INNER JOIN categories
       ON categories.id = books_categories.category_id
 GROUP BY books.id
 ORDER BY books.id;

-- 3) Write SQL statements to insert the following new books into the database. What do you need to do to ensure this data fits in the database?
  /*
  Author 	Title 	Categories
  Lynn Sherr 	Sally Ride: America's First Woman in Space 	Biography, Nonfiction, Space Exploration
  Charlotte Brontë 	Jane Eyre 	Fiction, Classics
  Meeru Dhalwala and Vikram Vij 	Vij's: Elegant and Inspired Indian Cuisine 	Cookbook, Nonfiction, South Asia
  */
/* Answer: we need to ensure the new categories and books are added before adding the rows in books_categories*/

/* A. Add the new categories */
  /* a. find the categories to add */
CREATE TABLE temp_categories (
  name varchar(32)
);
INSERT INTO temp_categories VALUES ('Biography'), ('Nonfiction'), ('Space Exploration'), ('Fiction'), ('Classics'), ('Cookbook'), ('Nonfiction'), ('South Asia');
SELECT DISTINCT name FROM temp_categories WHERE name NOT IN (SELECT name FROM categories);
/*
       name
-------------------
 Space Exploration
 Cookbook
 South Asia
(3 rows)
*/
  /* b. Add the categories */
INSERT INTO categories (name)
            SELECT DISTINCT name FROM temp_categories WHERE name NOT IN (SELECT name FROM categories);
  /* c. Drop temp table */
DROP TABLE temp_categories;

/* B. Add the new books */
  /*
  Author 	Title 	Categories
  Lynn Sherr 	Sally Ride: America's First Woman in Space 	Biography, Nonfiction, Space Exploration
  Charlotte Brontë 	Jane Eyre 	Fiction, Classics
  Meeru Dhalwala and Vikram Vij 	Vij's: Elegant and Inspired Indian Cuisine 	Cookbook, Nonfiction, South Asia
  */
INSERT INTO books (author, title)
  VALUES ('Lynn Sherr', 'Sally Ride: America''s First Woman in Space'),
  ('Charlotte Brontë', 'Jane Eyre'),
  ('Meeru Dhalwala and Vikram Vij', 'Vij''s: Elegant and Inspired Indian Cuisine');
/* ERROR:  value too long for type character varying(32) */
--for 'Sally Ride: America''s First Woman in Space' and 'Vij''s: Elegant and Inspired Indian Cuisine'
--=> change type
ALTER TABLE books
ALTER COLUMN title
             TYPE text;
INSERT INTO books (author, title)
  VALUES ('Lynn Sherr', 'Sally Ride: America''s First Woman in Space'),
  ('Charlotte Brontë', 'Jane Eyre'),
  ('Meeru Dhalwala and Vikram Vij', 'Vij''s: Elegant and Inspired Indian Cuisine');

/* C. Add the relationships between books and categories */
/*
  books id:
4 | Sally Ride: America's First Woman in Space; 5 | Jane Eyre; 6 | Vij's: Elegant and Inspired Indian Cuisine
  categories id:
1 | Nonfiction; 2 | Fiction; 3 | Fantasy; 4 | Classics; 5 | Biography; 6 | Physics; 7 | Space Exploration;
8 | Cookbook; 9 | South Asia
*/
INSERT INTO books_categories
  (book_id, category_id)
  VALUES (4, 5), (4, 1), (4, 7),
         (5, 2), (5, 4),
         (6, 8), (6, 1), (6, 9);

-- 4) Write a SQL statement to add a uniqueness constraint on the combination of columns book_id and category_id of the books_categories table. This constraint should be a table constraint; so, it should check for uniqueness on the combination of book_id and category_id across all rows of the books_categories table.
ALTER TABLE books_categories
  ADD --CONSTRAINT fkey_combination_unique
      UNIQUE (book_id, category_id);

-- 5) Write a SQL statement that will return the following result:
  /*
        name        | book_count |                                 book_titles
  ------------------+------------+-----------------------------------------------------------------------------
  Biography         |          2 | Einstein: His Life and Universe, Sally Ride: America's First Woman in Space
  Classics          |          2 | A Tale of Two Cities, Jane Eyre
  Cookbook          |          1 | Vij's: Elegant and Inspired Indian Cuisine
  Fantasy           |          1 | Harry Potter
  Fiction           |          3 | Jane Eyre, Harry Potter, A Tale of Two Cities
  Nonfiction        |          3 | Sally Ride: America's First Woman in Space, Einstein: His Life and Universe, Vij's: Elegant and Inspired Indian Cuisine
  Physics           |          1 | Einstein: His Life and Universe
  South Asia        |          1 | Vij's: Elegant and Inspired Indian Cuisine
  Space Exploration |          1 | Sally Ride: America's First Woman in Space
  */
SELECT categories.name,
       COUNT(books.id) AS book_count,
       STRING_AGG(books.title, ', ') AS book_titles
  FROM categories
       LEFT OUTER JOIN books_categories
       ON categories.id = books_categories.category_id
       LEFT OUTER JOIN books
       ON books.id = books_categories.book_id
  GROUP BY categories.id
  ORDER BY categories.name;
