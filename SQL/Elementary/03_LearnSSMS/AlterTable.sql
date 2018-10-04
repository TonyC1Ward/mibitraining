/*
    Alter Table

    Martin Fish
    8 Aug 2018

*/

USE [Dev_Martin_DataWarehouse]

-- Add a column in a table
ALTER TABLE employees
	ADD LastName varchar(100);

-- Add multiple columns in a table
ALTER TABLE  employees
	ADD  LastName varchar(100)
		,FirstName varchar(100);

-- Modify column in table
ALTER TABLE employees
	ALTER COLUMN LastName varchar(75) NOT NULL; -- Changes the column to be a datatype of varchar(75) and to not allow nulls

-- Drop column in a table
ALTER TABLE employees
	DROP COLUMN LastName;	-- Removes the column LastName from the table


