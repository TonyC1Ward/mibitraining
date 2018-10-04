/*
    ORDER BY

	Example syntax:
	ORDER BY "Column Name" [ASC / DESC]

    Martin Fish
    9 Aug 2018

*/

USE [TSQLV4];
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM [HR].[Employees]
ORDER BY [hiredate] ASC;	-- Sorts the results in order of employees hire date. The earliest hiredate is listed 1st. 

------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT [orderid], [productid], [unitprice], [qty], [discount], ([unitprice] * [qty]) AS OrderTotal
FROM [Sales].[OrderDetails]
ORDER BY OrderTotal DESC;		-- Sorts the results in order of order total. The highest total is listed 1st. 

------------------------------------------------------------------------------------------------------------------------------------------------------------
