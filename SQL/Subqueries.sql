/*
    Subqueries
    
    Examples of subqueries and how to use them.

    Martin Fish
    25 June 2018

*/


 --------------------------------------------------------------------------------------------------------------------------------------------------------
--  Scalar Subqueries
---------------------------------------------------------------------------------------------------------------------------------------------------------
--  Scalar subquery returns single value to outer query. 
--  Can be used anywhere single-valued expression is used- SELECT, WHERE, and so on.
--  If inner query returns an empty set, result is converted to NULL.

-- Inner Query:
USE TSQL;
GO

SELECT MAX(orderid) AS lastorder            -- This returns: 11077
FROM sales.orders;

-- Then write the outer query using the value returned by the inner query.

-- Outer and Inner Query:
USE TSQL;
GO

SELECT orderid, productid, unitprice, qty   -- Outer Query
FROM Sales.OrderDetails
WHERE orderid = 
    (SELECT MAX(orderid) AS lastorder       -- Inner Query (Subquery)
    FROM Sales.Orders);

--  To denote a query as a subquery, enclose it in parentheses().
--  The above is a self-contained subquery, it has no dependency on the outer query. It returns a scalar result and  can be run on its own (highlight subquery only).

--  Another example:
USE TSQLV4

SELECT productid, productname, unitprice
FROM Production.Products
WHERE unitprice =
    (SELECT MIN(unitprice)
     FROM Production.Products);

---------------------------------------------------------------------------------------------------------------------------------------------------------


 --------------------------------------------------------------------------------------------------------------------------------------------------------
--  Multi-Valued Subqueries
---------------------------------------------------------------------------------------------------------------------------------------------------------
--  Multi-valued subquery returns multiple values as a single column set to the outer query.
--  Used with IN predicate.
--  If any value in the subquery result matches IN predicate expression, the predicate returns TRUE.
--  May return more than one result, in the form of a single-column set.

USE TSQL;
GO

SELECT custid, orderid
FROM Sales.Orders
WHERE custid IN (
    SELECT custid
    FROM Sales.Customers
    WHERE country = 'Mexico');

--  May also be expressed as a JOIN (test both for performance)

--  Subquery Rewritten As a JOIN:
USE TSQL;
GO

SELECT c.custid, o.orderid
FROM Sales.orders AS o
    INNER JOIN Sales.Customers As c
    ON o.custid = c.custid
WHERE c.country = 'Mexico';

--  The execution plans for the above two queries above are identical. The database engine interprets the subquery above as a INNER JOIN.

--  Another example:
USE TSQLV4;
GO

SELECT productid, productname, unitprice
FROM Production.Products
WHERE supplierid IN
    (SELECT supplierid
     FROM Production.Suppliers
     WHERE country = 'Japan');

---------------------------------------------------------------------------------------------------------------------------------------------------------


 --------------------------------------------------------------------------------------------------------------------------------------------------------
--  Correlated Subqueries
---------------------------------------------------------------------------------------------------------------------------------------------------------
--  Correlated subqueries refer to elements of tables used in outer query.
--  Dependent on outer query, cannot be executed separately.
--  Behaves as if inner query is executed once per outer row.
--  May return scalar or multiple values .
USE TSQL;
GO

SELECT orderid, empid, orderdate
FROM Sales.Orders AS O1
WHERE orderdate =
    (SELECT MAX(orderdate)
     FROM Sales.Orders AS O2
     WHERE O2.empid = O1.empid)
ORDER BY empid,orderdate;

--  The above query uses a correlated subquery to return the orders with the latest order date for each employee.
--  The subquery accepts an input value from the outer query, used the input in its WHERE clause, and returns a scalar result to the outer query.


--  Correlated subqueries typically used to pass a value from the outer query to the inner query, to be used as a parameter there.
--  UNLIKE self-contained subqueries they depend on the outer query to pass values into the subquery as a parameter.


--  Write inner query to accept input value from outer query.
--  Write outer query to accept appropriate return result (scalar or multi-valued).
--  Correlate queries by passing value from outer query to match argument in inner query:
SELECT custid, orderid, orderdate
FROM Sales.Orders AS outerorders
WHERE orderdate =
    (SELECT MAX(orderdate)
     FROM Sales.Orders AS innerorders
     WHERE innerorders.custid = outerorders.custid)
ORDER BY custid;

---------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT custid, orderdate, orderid
FROM 

 --------------------------------------------------------------------------------------------------------------------------------------------------------
--  Using EXISTS predicate with Subqueries
---------------------------------------------------------------------------------------------------------------------------------------------------------
--  The EXISTS predicate evaluates whether rows exist, but rather than return them, it returns TRUE or FALSE.
--  This is useful for validating data without incurring the overhead of retrieving and counting the results. 
--  When a subquery is used with the keyword EXISTS, it functions as an existence test.

USE TSQL
GO

SELECT custid, companyname
FROM Sales.Customers AS c
WHERE NOT EXISTS (
        SELECT *
        FROM Sales.Orders as o
        WHERE c.custid = o.custid);

--  The above query does not return data about customers who have placed orders. 
--  If a customer ID is found in the Sales.Orders table, NOT EXISTS evaluates to FALSE and is therefore not returned. 

--  The Keyword EXISTS does not follow a column name or other expression.
--  The SELECT list of a subquery introduced by EXISTS typically only uses and asterisk(*):
USE TSQL
GO

SELECT custid, companyname
FROM Sales.Customers AS c
WHERE EXISTS (
    SELECT *
    FROM Sales.Orders AS o
    WHERE c.custid = o.custid);
---------------------------------------------------------------------------------------------------------------------------------------------------------

