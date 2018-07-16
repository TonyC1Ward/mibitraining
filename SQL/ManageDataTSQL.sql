USE [TSQLV4];
GO

----------------------------------------------------------------------------
-- Combining Predicates
----------------------------------------------------------------------------
SELECT empid, firstname, lastname, country, region, city
FROM HR.Employees
WHERE region <> 'WA'
    OR region IS NULL;

-- Different ways of achieving the same results 

SELECT empid, firstname, lastname, country, region, city
FROM HR.Employees
WHERE NOT region = 'WA'
    OR region IS NULL;

-- Logical evaluation order of predicates - 1.NOT, 2.AND, 3.OR
----------------------------------------------------------------------------





----------------------------------------------------------------------------
-- CASE Statements
----------------------------------------------------------------------------
SELECT productid, productname, unitprice, discontinued,
    CASE discontinued
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Unknown'
    END AS discontinued_desc
FROM Production.Products;

SELECT productid, productname, unitprice,
    CASE
        WHEN unitprice < 20.00 THEN 'Low'
        WHEN unitprice < 40.00 THEN 'Medium'
        WHEN unitprice >= 40.00 THEN ' High'
        ELSE 'Unknown' 
    END AS pricerange
FROM Production.Products;

----------------------------------------------------------------------------

