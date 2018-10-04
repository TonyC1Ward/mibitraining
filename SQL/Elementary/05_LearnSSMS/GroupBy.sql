/*
GROUP BY

Martin Fish
13 August 2018

*/

USE [AdventureWorks2012];
GO

-- GROUP BY single column
SELECT 
     sod.[ProductID]
    ,SUM(sod.orderqty) AS OrderQtyByProductID
FROM sales.[salesorderdetail] AS sod
GROUP BY sod.ProductID;