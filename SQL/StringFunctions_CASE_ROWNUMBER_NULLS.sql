USE Dev_Martin_DataWarehouse;

GO

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Concatenation
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
     [StudentID]
    ,[YearHESAReport]
    ,[StudentID] + '¬' + CAST([YearHESAReport] AS VARCHAR(4)) AS [ConcatStudentYearFull]    -- Adding two columns together 
    ,[StudentID] + '¬' + RIGHT([YearHESAReport], 2) AS [ConcatStudentYearShort]             -- Using the RIGHT string function to return only the right 2 numbers of YearHESAReport. Returns as a string.

FROM [dbo].[HESA_Example];

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ROW NUMBER
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- This can be useful for deleting duplicate rows e.g partition by StudentID and then delete WHERE RowNumber> 1 

SELECT 
     [StudentID]
    ,[YearHESAReport]
    ,[EthnicID]
    ,ROW_NUMBER() OVER (ORDER BY YearHESAReport) AS RowNumber                                       -- We get a row number for every row in the resultset starting with 1.
    ,ROW_NUMBER() OVER (PARTITION BY YearHESAReport ORDER BY YearHESAReport) AS RowNumberPartition  -- Same as above but the row number resets to 1 whenever the partition changes.

FROM [dbo].[HESA_Example];

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- OVER Clause 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Used with PARTITION BY to break up table data in partitions-

SELECT 
     [StudentID]
    ,[YearHESAReport]
    ,[EthnicID]
    ,COUNT(YearHESAReport) OVER (PARTITION BY YearHESAReport) AS StudentYearCount -- Partition the table by YearHESAReport, and then apply a count for each of the partitions (years in this case).

FROM [dbo].[HESA_Example];

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- REPLACE
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Replaces all occurances of a specified string value with another string value.
-- The syntax is- REPLACE(String_expression, Pattern, Replacement_Value)

USE [TSQLV4];
GO

SELECT
     postalcode
    ,REPLACE(country, 'USA', 'NON-UK') AS ConvertedCountry      -- Where the string "USA" appears in the column country, the "USA" string is replaced with the string "NON-UK"

FROM
    [HR].[Employees]

    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- STUFF
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- The syntax is- STUFF(Original_Expression, Start, Length, Replacement_expression))

USE [TSQLV4];
GO

SELECT
     postalcode
    ,STUFF(postalcode, 3, 2, '**') AS StuffedPostalCode     -- Use the column postalcode and start at the position 3 (third character of the string), for the next 2 characters replace them with "**".

FROM
    [HR].[Employees]


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CASE
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Use a CASE statement to test certain conditions and return different answers if those conditions have been met-

SELECT 
     StudentID
    ,YearHESAReport
    ,EthnicID
    ,CourseYear
    ,CASE 
        WHEN EthnicID = 10
            THEN 'White British'
        WHEN EthnicID = 32
            THEN 'Chinese'
        WHEN EthnicID = 98
            THEN 'Irish'
        ELSE 'Other'
        END AS Ethnicity

FROM [dbo].[HESA_Example];

-- Can't use Alias in a WHERE clause, so to use a CASE statement in a WHERE clause we would have to reference the whole CASE statement as follows-
SELECT 
     StudentID
    ,YearHESAReport
    ,EthnicID
    ,CourseYear
    ,CASE 
        WHEN EthnicID = 10
            THEN 'White British'
        WHEN EthnicID = 32
            THEN 'Chinese'
        WHEN EthnicID = 98
            THEN 'Irish'
        ELSE 'Other'
        END AS Ethnicity

FROM [dbo].[HESA_Example];

WHERE CASE                          -- NOTE that this can look messy and we could easily achieve the same result set by simply using "WHERE EthnicID = 32"
        WHEN EthnicID = 10
            THEN 'White British'
        WHEN EthnicID = 32
            THEN 'Chinese'
        WHEN EthnicID = 98
            THEN 'Irish'
        ELSE 'Other'
        END = 'Chinese';

-- Searching for text with CASE-
SELECT StudentID
    ,YearHESAReport
    ,EthnicID
    ,CourseYear
    ,CASE 
        WHEN YearHESAReport LIKE '20%'
            THEN '21st Century'
        WHEN YearHESAReport LIKE '19%'
            THEN '20th Century'
        ELSE 'The dark ages'
        END AS 'HESAReportCentury'

FROM [dbo].[HESA_Example];

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ISNULL
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Can be used to replace NULL values with some desired values.
-- T-SQL standard
-- The syntax is- ISNULL(Expression which may be null, whats to use instead)

SELECT 
     [StudentID]
    ,[YearHESAReport]
    ,[EthnicID]
    ,[CourseYear]
    ,ISNULL([ReasonLeftID], '') AS [ReasonLeftID] --   If the ReasonLeftID column is NULL then replace it with a "blank".
    ,ISNULL([LevelOfStudy], 'Unknown') AS LevelOfStudy -- * If the LevelOfStudy column is Null then replace it with "Unknown".
    ,[DomicileCode]
    ,[FirstYearIdentifier]
    ,[ModeOfStudy]

FROM [dbo].[HESA_Example];

-- * The desired values must match to the datatypes of the original columns. 
-- * In the above example LevelOfStudy displays only the "U" of "Unknown" due to the datatype being Varchar(1).

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- COALESCE
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Can be used to replace NULL values with some desired values.
-- ANSI standard.
-- Allows multiple values and uses the first one which is not null.
-- The syntax is- COALESCE(First value which may be null, second value which may be null, third value to try etc, etc)

--Get valid phone number-
COALESCE(MobileNumber -- Works through the list to produce only one number. If MobileNumber is Null it passes on to WorkPhone-
        ,WorkPhone -- If WorkPhone is null it passes on to HomePhone-
        ,HomePhone -- If HomePhone is null it returns "No phone number given"
        ,'No phone number given') AS Phone

-- Another example to get a name-
COALESCE(FirstName, MiddleName, LastName) AS Name

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- REPLICATE
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Using replicate function to mask user email addresses-

SELECT 
     FirstName
    ,LastName
    ,SUBSTRING(Email,1,2) + REPLICATE('*',5) + SUBSTRING(Email, CHARINDEX('0', Email), LEN(Email) - CHARINDEX('0', Email)+1) AS Email

-- First 2 letters of the users email using Substring
-- Concatenating to the REPLICATE function
-- REPLICATE function adding five "*" symbols to the first 2 letters of the users email e.g. mf*****
-- Using substring to get remainder of user email e.g. mf*****@hull.ac.uk
