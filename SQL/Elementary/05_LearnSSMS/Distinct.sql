/*
    Distinct

    Martin Fish
    9 Aug 2018

*/

USE [TSQLV4];
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT title		-- Returns only unique results, no duplicates. e.g. 9 employees in the table but only 4 different job titles are returned.
FROM [HR].[Employees];

------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT title		
FROM [HR].[Employees]
WHERE title <> 'Sales Representative';



