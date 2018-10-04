---------------------------------------------------------------------
-- TSQL Fundamentals 
-- Background to T-SQL - Chapter 1
-- Martin Fish
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Creating Tables
---------------------------------------------------------------------

-- The following code creates a table called Employees in the dbo schema in the TSQL4
USE TSQLV4;

DROP TABLE IF EXISTS dbo.Employees

CREATE TABLE dbo.Employees
(
    empid       INT             NOT NULL,
    firstname   VARCHAR(30)     NOT NULL,
    lastname    VARCHAR(30)     NOT NULL,
    hiredate    DATE            NOT NULL,
    mgrid       INT             NULL,
    ssn         VARCHAR(20)     NOT NULL,
    salary      MONEY           NOT NUll
);

---------------------------------------------------------------------
-- Data Integrity
---------------------------------------------------------------------

-- Primary Key Constraint
ALTER TABLE dbo.Employees
ADD CONSTRAINT PK_Employees
PRIMARY KEY (empid);
-- Primary key constraint does not allow duplicate key values. It enforces uniqueness of rows and also disallows NULLs.

-- Unique Constraint
ALTER TABLE dbo.Employees
ADD CONSTRAINT UNQ_Employees_ssn
UNIQUE(ssn);
-- Unique constraint enforces the uniqueness of rows. Can have multiple unique constraints. It is not restricted to columns defined as NULL.

-- Table for foreign key example
DROP TABLE IF EXISTS dbo.orders;

CREATE TABLE dbo.Orders
(
    orderid    INT            NOT NULL,
    empid      INT            NOT NULL,
    custid     VARCHAR(10)    NOT NULL,
    orderts    DATETIME2      NOT NULL,
    qty        INT            NOT NULL
CONSTRAINT PK_Orders
PRIMARY KEY(orderid)
);

-- Foreign Key Constraint
ALTER TABLE dbo.Orders
ADD CONSTRAINT FK_Orders_Employees
FOREIGN KEY(empid)
REFERENCES dbo.Employees(empid);
-- Foreign key enforces referential integrity. The foreign keys job is to restrict the values allowed in the foreign key columns to those that exist in the referenced columns.

-- Check Constraint 
ALTER TABLE dbo.Employees
ADD CONSTRAINT CHK_Employees_salary
CHECK(salary > 0.00);
-- Checks to see if a value entered meets the requirement e.g salary > 0.00

-- Testing the Check constraint
INSERT INTO dbo.Employees(empid, firstname, lastname, hiredate, ssn, salary)
VALUES(3, 'joe', 'bloggs', '2018-09-24','89', -0.50);
-- The statement will be terminated as it does not meet the requirements of the Check Constraint above

-- Default Constraint
ALTER TABLE dbo.Orders
ADD CONSTRAINT DFT_Orders_orderts
DEFAULT(SYSDATETIME()) FOR orderts;
-- A Default constraint is used as the default value when an explicit value is not specified when you insert a row. e.g. no date added 

-- Testing the Default Constraint
INSERT INTO dbo.Orders([orderid], [empid], [custid], [qty])
VALUES(1, 01, '12345', 5);
-- The above example does not include a value for the orderts column which is a datetime datatype. Due to the Default constraint a default datetime value will be entered using the SYSDATETIME function

--------------------------------------------------------------------
-- Cleanup
--------------------------------------------------------------------
DROP TABLE IF EXISTS dbo.Orders, dbo.Employees;