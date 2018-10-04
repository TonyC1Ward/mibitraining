/*
    Understand the difference between Delete and Drop

    Martin Fish
    8 Aug 2018

*/

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Delete Records From a Table
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE [Dev_Martin_DataWarehouse]

DELETE FROM [dbo].[ProductionCompany]		-- Safer to drag and drop table name from object explorer rather than typing to ensure the right table is used!
WHERE Name = 'Google';						-- BE CAREFUL! 
											-- Notice the WHERE clause in the delete statement which specifies which records should be deleted.
											-- If you omit the WHERE clause, all records in the table will be deleted! 

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Deleting all records from a table
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
DELETE FROM [dbo].[ProductionCompany];		-- This WILL delete all records in the table! Note, delete without the WHERE clause has the same result as using truncate.

TRUNCATE TABLE [dbo].[ProductionCompany];	-- Truncate is more efficient and uses less system resources. Empties the table (deletes all rows).

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Drop Table
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE [dbo].[ProductionCompany];		-- Drop removes a table from the database. 

----------------------------------------------------------------------------------------------------------------------------------------------------------------------