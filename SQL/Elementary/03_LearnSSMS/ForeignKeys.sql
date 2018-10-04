/*
    Foreign Keys and Relationships
  
	How to create links between two tables (or foreign key constraints)

    Martin Fish
    8 Aug 2018

*/

-- For this example we will create two tables: one to hold authors, and one to hold books:
USE [Dev_Martin_DataWarehouse]

-- Create table of Authors
CREATE TABLE Author
(
	 AuthorId int IDENTITY(1,1) PRIMARY KEY
	,FirstName varchar(100)
	,LastName varchar(100)
)

-- Add in a couple of authors
INSERT INTO Author(Firstname, Lastname)
	VALUES ('Stieg', 'Larsson')
 INSERT INTO Author(Firstname, Lastname)
	VALUES ('JRR', 'Tolkien')

-- Create a table of books
CREATE TABLE Books
(
	 BookId int IDENTITY(1,1) PRIMARY KEY
	,BookName varchar(100) not null
	,AuthorId int
)

-- Add a few books
INSERT INTO Books(BookName, AuthorId)
	VALUES ('The Hobbit', 2)
INSERT INTO Books(BookName, AuthorId)
	VALUES ('The Girl With The Dragon Tattoo', 1)
INSERT INTO Books(BookName, AuthorId)
	VALUES ('The Girl Who Played With Fire', 1)
INSERT INTO Books(BookName, AuthorId)
	VALUES ('The Lord of the Rings', 2)
INSERT INTO Books(BookName, AuthorId)
	VALUES ('The Girl Who Kicked the Hornets Nest', 1)

-- The SQL above will give us two tables, as yet unlinked. Here is how we could link the two tables above:

-- Create relationship between the two tables, enforcing referential integrity and cascade update/delete
ALTER TABLE Books
	ADD CONSTRAINT fk_Books_Author
	FOREIGN KEY (AuthorId)
	REFERENCES Author(AuthorId)

-- Optional extra settings to enforce cascade
-- Cascade and delete
ON UPDATE CASCADE								-- This means that you can't enter a book with an author id which doesnt exist in the table of authors.
ON DELETE CASCADE								-- (You can't have orphan records)

