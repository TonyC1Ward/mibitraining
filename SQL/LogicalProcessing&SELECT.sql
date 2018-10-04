---------------------------------------------------------------------
-- Microsoft SQL Server T-SQL Fundamentals
-- Chapter 02 - Single-Table Queries
-- Martin Fish
-- 25 September 2018
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Elements of the SELECT Statement
---------------------------------------------------------------------
USE TSQLV4;

SELECT [empid], YEAR(orderdate) AS orderyear, COUNT(*) AS numorders -- 5
FROM [Sales].[Orders]                                               -- 1
WHERE custid = 71                                                   -- 2
GROUP BY empid, YEAR(orderdate)                                     -- 3
HAVING COUNT(*) > 1                                                 -- 4
ORDER BY empid, orderyear;                                          -- 6

/*
LOGICAL PROCESSING OF THE ABOVE QUERY LOOKS LIKE THIS-
1. FROM     - Queries the rows from the Sales.Orders table
2. WHERE    - Filters only orders where the customer ID is equal to 71
3. GROUP BY - Groups the orders by employee ID and order year
4. HAVING   - Filters only groups (employee ID and order year) having more than one order
5. SELECT   - Selects (returns) for each group the employee ID, order year, and number of orders
6. ORDER BY - Orders (sorts) the rows in the ouput by employee ID and order year
*/
