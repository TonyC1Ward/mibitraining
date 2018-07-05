USE AdventureWorks2012;
GO

--------------------------------------------------------------------------------------------------------------------------------------------
-- SELECT Clause
--------------------------------------------------------------------------------------------------------------------------------------------

SELECT '1' AS [col1],
        'A' AS [col2];

EXEC sp_help 'Person.Person';

--------------------------------------------------------------------------------------------------------------------------------------------
-- Column Aliases
--------------------------------------------------------------------------------------------------------------------------------------------

SELECT TransactionID,
       ProductID,
       Quantity,
       ActualCost,
       'Batch 1' AS BatchID,
       (Quantity * ActualCost) As TotalCost
FROM Production.TransactionHistory;

SELECT Name AS DepartmentName
FROM HumanResources.Department;

--------------------------------------------------------------------------------------------------------------------------------------------
-- Regular VS Delimited Identifiers
--------------------------------------------------------------------------------------------------------------------------------------------

SELECT  Name,
        [name]
FROM [HumanResources].[Department];

CREATE TABLE #Department -- Create temporary table
    ([Department ID] int NOT NULL);
GO

SELECT Department ID -- Doesn't work
FROM #Department;

SELECT [Department ID] -- This does! Delimited Identifier.
FROM #Department;

--------------------------------------------------------------------------------------------------------------------------------------------
-- FROM Clause
--------------------------------------------------------------------------------------------------------------------------------------------

-- Check which views are in the database
SELECT SCHEMA_NAME(schema_id) AS [schema], 
        [name]
FROM sys.views;

-- FROM clause (table)
SELECT [BusinessEntityID], 
       [Name]
FROM [Sales].[vStoreWithAddresses];

-- Table variable
DECLARE @orders TABLE
    (OrderID int NOT NULL PRimary KEY,
     OrderDT datetime NOT NULL);

INSERT @Orders
VALUES (1, GETDATE());

SELECT [OrderID], [OrderDT]
FROM @Orders;

GO

--------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------