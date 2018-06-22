/*
    TableTypes

    Table: [dbo].[TableTypes]
    
    Examples of different table types and datasets.

    Martin Fish
    22 June 2018

*/


 --------------------------------------------------------------------------------------------------------------------------------------------------------
--  Regular Table
---------------------------------------------------------------------------------------------------------------------------------------------------------
--  Regular tables are used for storing PERSISTENT data:

CREATE TABLE [dbo].[TestPerson]
(
     [PersonCode]    [nvarchar](12)  NOT NULL
    ,[Title]         [nvarchar](12)      NULL
    ,[Forename]      [nvarchar](30)      NULL
    ,[Surname]       [nvarchar](40)      NULL
    ,[DateOfBirth]   [datetime]          NULL
    ,[GenderCode]    [nvarchar](1)       NULL
    PRIMARY KEY CLUSTERED
    (
        [PersonCode] ASC
    )
) ON [PRIMARY]

GO

INSERT INTO [dbo].[TestPerson]([PersonCode], [Title], [Forename], [Surname], [DateOfBirth], [GenderCode])
VALUES
     ('0010059', 'Miss', 'Cherish', 'Saltan', '1987-01-27 00:00:00:000', 'F')
    ,('0010060', 'Mr', 'Martin', 'Fish', '1985-06-25 00:00:00:000', 'M')
    ,('0010061', 'Master', 'Alex', 'Saltan', '2008-04-28 00:00:00:000', 'M')
    ,('0010062', 'Mrs', 'Jean', 'Kent', '1987-01-27 00:00:00:000', 'F')
    ,('0010063', 'Mr', 'Tony', 'Kopamees', '1987-01-27 00:00:00:000', 'F')

---------------------------------------------------------------------------------------------------------------------------------------------------------


 --------------------------------------------------------------------------------------------------------------------------------------------------------
--  Temporary Table (Local)
---------------------------------------------------------------------------------------------------------------------------------------------------------
--  Local temporary tables are only available to the session that created them. 
--  The data IS NOT PERSISTENT.
--  Temporary tables are automatically dropped after terminating the procedure or session.
--  Local temporary tables are prefixed with a # :

CREATE TABLE [#TestPerson]
(
     [PersonCode]    [nvarchar](12)  NOT NULL
    ,[Title]         [nvarchar](12)      NULL
    ,[Forename]      [nvarchar](30)      NULL
    ,[Surname]       [nvarchar](40)      NULL
    ,[DateOfBirth]   [datetime]          NULL
    ,[GenderCode]    [nvarchar](1)       NULL
    PRIMARY KEY CLUSTERED
    (
        [PersonCode] ASC
    )
) ON [PRIMARY]

GO

INSERT INTO [#TestPerson]([PersonCode], [Title], [Forename], [Surname], [DateOfBirth], [GenderCode])
VALUES
     ('0010059', 'Miss', 'Cherish', 'Saltan', '1987-01-27 00:00:00:000', 'F')
    ,('0010060', 'Mr', 'Martin', 'Fish', '1985-06-25 00:00:00:000', 'M')
    ,('0010061', 'Master', 'Alex', 'Saltan', '2008-04-28 00:00:00:000', 'M')
    ,('0010062', 'Mrs', 'Jean', 'Kent', '1987-01-27 00:00:00:000', 'F')
    ,('0010063', 'Mr', 'Tony', 'Kopamees', '1987-01-27 00:00:00:000', 'F')

SELECT *
FROM [#TestPerson]

---------------------------------------------------------------------------------------------------------------------------------------------------------


 --------------------------------------------------------------------------------------------------------------------------------------------------------
--  Table Variables
---------------------------------------------------------------------------------------------------------------------------------------------------------
--  Table variables are alternatives to temporary tables.
--  They store a set of records as a variable
--  They are prefixed with @
--  Table variables are automatically local and automatically dropped:

DECLARE @TestPerson TABLE
(
     [PersonCode]    [nvarchar](12)  NOT NULL
    ,[Title]         [nvarchar](12)      NULL
    ,[Forename]      [nvarchar](30)      NULL
    ,[Surname]       [nvarchar](40)      NULL
    ,[DateOfBirth]   [datetime]          NULL
    ,[GenderCode]    [nvarchar](1)       NULL
) 

INSERT INTO @TestPerson ([PersonCode], [Title], [Forename], [Surname], [DateOfBirth], [GenderCode])
VALUES
     ('0010059', 'Miss', 'Cherish', 'Saltan', '1987-01-27 00:00:00:000', 'F')
    ,('0010060', 'Mr', 'Martin', 'Fish', '1985-06-25 00:00:00:000', 'M')
    ,('0010061', 'Master', 'Alex', 'Saltan', '2008-04-28 00:00:00:000', 'M')
    ,('0010062', 'Mrs', 'Jean', 'Kent', '1987-01-27 00:00:00:000', 'F')
    ,('0010063', 'Mr', 'Tony', 'Kopamees', '1987-01-27 00:00:00:000', 'F')

SELECT *
FROM @TestPerson

---------------------------------------------------------------------------------------------------------------------------------------------------------


 --------------------------------------------------------------------------------------------------------------------------------------------------------
--  Common Table Expression (CTE)
---------------------------------------------------------------------------------------------------------------------------------------------------------
--  A CTE is a temporary named result set that you can reference within a SELECT, INSERT, UPDATE, or DELETE.
--  It is usual to create a dataset within a CTE from one or more tables (JOINS) but in this example its populated directly:

WITH CTE_TestPerson ([PersonCode], [Title], [Forename], [Surname], [DateOfBirth], [GenderCode]) AS
(
SELECT '0010059', 'Miss', 'Cherish', 'Saltan', '1987-01-27 00:00:00:000', 'F' UNION ALL
SELECT '0010060', 'Mr', 'Martin', 'Fish', '1985-06-25 00:00:00:000', 'M'      UNION ALL
SELECT '0010061', 'Master', 'Alex', 'Saltan', '2008-04-28 00:00:00:000', 'M'  UNION ALL
SELECT '0010062', 'Mrs', 'Jean', 'Kent', '1987-01-27 00:00:00:000', 'F'       UNION ALL
SELECT '0010063', 'Mr', 'Tony', 'Kopamees', '1987-01-27 00:00:00:000', 'F'
) 

SELECT *
FROM CTE_TestPerson

---------------------------------------------------------------------------------------------------------------------------------------------------------