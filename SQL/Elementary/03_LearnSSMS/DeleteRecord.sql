/*
    Delete a Table Record

    Martin Fish
    8 Aug 2018

*/

-- For this example we will create two tables: one to hold authors, and one to hold books:
USE [Dev_Martin_DataWarehouse]

DELETE FROM [dbo].[ProductionCompany] -- Safer to drag and drop table name from object explorer rather than typing to ensure the right table is used!
WHERE Name = 'Google'				  -- BE CAREFUL! 
									  -- Notice the WHERE clause in the delete statement which specifies which records should be deleted.
									  -- If you omit the WHERE clause, all records in the table will be deleted! 

