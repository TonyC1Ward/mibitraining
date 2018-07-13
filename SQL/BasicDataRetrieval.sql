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
    (OrderID int NOT NULL PRIMARY KEY,
     OrderDT datetime NOT NULL);

INSERT @Orders
VALUES (1, GETDATE());

SELECT [OrderID], [OrderDT]
FROM @Orders;

GO
-- Another Table Variable
DECLARE @MartinTable TABLE
    (FirstName varchar(255),
     LastName varchar(255),
     DOB date,
     Employer varchar(255));

INSERT @MartinTable
VALUES ('Martin', 'Fish', '19850625', 'University of Hull');

SELECT *
FROM @MartinTable;

GO

--------------------------------------------------------------------------------------------------------------------------------------------
-- Table Aliases
--------------------------------------------------------------------------------------------------------------------------------------------
-- Table alias
SELECT [dept].[Name]
FROM [HumanResources].[Department] AS [dept];

-- Compact table alias
SELECT [d].[Name]
FROM [HumanResources].[Department] AS [d];

--------------------------------------------------------------------------------------------------------------------------------------------
-- WHERE Clause
--------------------------------------------------------------------------------------------------------------------------------------------
-- One predicate
SELECT [sod].[SalesOrderID],
       [sod].[SalesOrderDetailID]
FROM [Sales].[SalesOrderDetail] AS [sod]
WHERE [sod].[CarrierTrackingNumber] = '4911-403c-98';

--Two predicates with AND
SELECT [sod].[SalesOrderID],
       [sod].[SalesOrderDetailID],
       [sod].[SpecialOfferID],
       [sod].[CarrierTrackingNumber]
FROM [Sales].[SalesOrderDetail] AS [sod]
WHERE [sod].[CarrierTrackingNumber] = '4911-403c-98' AND
      [sod].[SpecialOfferID] = 1;

-- Two predicates with OR
SELECT [sod].[SalesOrderID],
       [sod].[SalesOrderDetailID],
       [sod].[SpecialOfferID],
       [sod].[CarrierTrackingNumber]
FROM [Sales].[SalesOrderDetail] AS [sod]
WHERE [sod].[CarrierTrackingNumber] = '4911-403c-98' OR
      [sod].[SpecialOfferID] = 1;

-- Three predicates AND and OR
SELECT [sod].[SalesOrderID],
       [sod].[SalesOrderDetailID],
       [sod].[ProductID]
FROM [Sales].[SalesOrderDetail] AS [sod]
WHERE ([sod].[CarrierTrackingNumber] = '4911-403c-98' AND
       [sod].[SpecialOfferID] = 1) OR
       [sod].[ProductID] = 711;

-- Negating a boolean expression
SELECT [sod].[SalesOrderID],
       [sod].[SalesOrderDetailID],
       [sod].[ProductID]
FROM [Sales].[SalesOrderDetail] AS [sod]
WHERE NOT [sod].[ProductID] = 711;

--------------------------------------------------------------------------------------------------------------------------------------------
-- DISTINCT
--------------------------------------------------------------------------------------------------------------------------------------------
-- no DISTINCT
SELECT [sod].[SalesOrderID]
FROM [Sales].[SalesOrderDetail] AS [sod]
WHERE [sod].[CarrierTrackingNumber] = '4911-403c-98'; 

-- with DISTINCT
SELECT DISTINCT [sod].[SalesOrderID]
FROM [Sales].[SalesOrderDetail] AS [sod]
WHERE [sod].[CarrierTrackingNumber] = '4911-403c-98'; 

-- NULL handling
SELECT DISTINCT [CarrierTrackingNumber]
FROM [Sales].[SalesOrderDetail] AS [sod]
ORDER BY [CarrierTrackingNumber]; 

-- Count of rows with NULL
SELECT COUNT(*)
FROM [Sales].[SalesOrderDetail] As [sod]
WHERE [CarrierTrackingNumber] IS NULL;

--------------------------------------------------------------------------------------------------------------------------------------------
-- TOP
--------------------------------------------------------------------------------------------------------------------------------------------
--no TOP
SELECT  [FirstName],
        [LastName],
        [StartDate],
        [EndDate]
FROM [HumanResources].[vEmployeeDepartmentHistory] AS [edh]
ORDER BY [edh].[StartDate];

-- TOP rows
SELECT  TOP (10)
        [FirstName],
        [LastName],
        [StartDate],
        [EndDate]
FROM [HumanResources].[vEmployeeDepartmentHistory] AS [edh]
ORDER BY [edh].[StartDate];

--TOP percent
SELECT  TOP (50) PERCENT
        [FirstName],
        [LastName],
        [StartDate],
        [EndDate]
FROM [HumanResources].[vEmployeeDepartmentHistory] AS [edh]
ORDER BY [edh].[StartDate];

--TOP WITH TIES
SELECT  TOP (3) WITH TIES
        [FirstName],
        [LastName],
        [StartDate],
        [EndDate]
FROM [HumanResources].[vEmployeeDepartmentHistory] AS [edh]
WHERE [edh].[StartDate] = '2009-02-26'
ORDER BY [edh].[StartDate];

--without TIES
SELECT  TOP (3)
        [FirstName],
        [LastName],
        [StartDate],
        [EndDate]
FROM [HumanResources].[vEmployeeDepartmentHistory] AS [edh]
WHERE [edh].[StartDate] = '2009-02-26'
ORDER BY [edh].[StartDate];

--------------------------------------------------------------------------------------------------------------------------------------------
-- GROUP BY
--------------------------------------------------------------------------------------------------------------------------------------------
-- GROUP BY single column (notice it isn't ordered)
SELECT  [sod].[ProductID],
        SUM([sod].[OrderQty]) AS [OrderQtyByProductID]
FROM [Sales].[SalesOrderDetail] AS [sod]
GROUP BY [sod].[ProductID];

-- GROUP BY, single column with ordering
SELECT  [sod].[ProductID],
        SUM([sod].[OrderQty]) AS [OrderQtyByProductID]
FROM [Sales].[SalesOrderDetail] AS [sod]
GROUP BY [sod].[ProductID]
ORDER BY [sod].[ProductID];

-- GROUP BY multi-column with ordering
SELECT  [sod].[ProductID],
        [sod].[SpecialofferID],
        SUM([sod].[OrderQty]) AS [OrderQtyByProductID]
FROM [Sales].[SalesOrderDetail] AS [sod]
GROUP BY [sod].[ProductID],
         [sod].[SpecialofferID]
ORDER BY [sod].[ProductID],
         [sod].[SpecialOfferID];

--GROUPING SETS
SELECT  [sod].[ProductID],
        [sod].[SpecialofferID],
        SUM([sod].[OrderQty]) AS [OrderQtyByProductID]
FROM [Sales].[SalesOrderDetail] AS [sod]
GROUP BY GROUPING SETS 
         (([sod].[ProductID],
          [sod].[SpecialofferID]),
         ([sod].[SpecialOfferID]))
ORDER BY [sod].[ProductID];

--------------------------------------------------------------------------------------------------------------------------------------------
-- HAVING CLAUSE
--------------------------------------------------------------------------------------------------------------------------------------------
SELECT sod.ProductId
FROM sales.salesorderdetail
