/*--------------------------------------------------------------------
Martin Fish

CTE Basics

6th July 2018
---------------------------------------------------------------------*/

/*
A Common Table Expression (CTE) is a temporary named result set that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement.

You can also use a CTE in a CREATE VIEW statement, as part of the views SELECT query.

After you define your WITH clause with the neccessary CTEs, you can reference those CTEs as you would any other table. However, once you've
run your statement, the CTE result set is not available to other statements. 

There are two types of CTEs -
A Nonrecursive CTE does not reference itself within the CTE.
A Recursive CTE is one that references itself within that CTE.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------
-- CTE Syntax
--------------------------------------------------------------------------------------------------------------------------------------------------
WITH <CTE_name> -- WITH keyword followed by the expression name which is the identifier for the CTE.
AS
(
    <inner_query> -- This is where you write your SELECT statement which defines the CTE.
) 
<outer_query>;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- Basic example
--------------------------------------------------------------------------------------------------------------------------------------------------
USE [MASTER];
GO

WITH [CTE_Requests] -- Name the CTE. *No Column names specified in this example
AS (
    SELECT [r].[session_id], -- Define the CTE. *All unique names in this example definition
           [r].[status],
           [s].[login_name],
           [t].[text]
    FROM [sys].[dm_exec_requests] AS [r]
        INNER JOIN [sys].[dm_exec_sessions] AS [s]
            ON  [s].[session_id] = [r].[session_id]
        INNER JOIN [sys].[dm_exec_connections] AS [c]
            ON [s].[session_id] = [c].[session_id]
        CROSS APPLY [sys].[dm_exec_sql_text] (
            [c].[most_recent_sql_handle]) AS [t]
    WHERE [r].[status] IN ('running', 'runnable', 'suspended')
)
SELECT  [session_id] -- This is where we reference our CTE we've created above.
        [status],
        [login_name],
        [text]
FROM [CTE_Requests]; -- The name of the CTE itself
GO

-- *Column names optional BUT must be specified at the start of the CTE when we DO NOT have unique names in our CTE definition, see example below. 

--------------------------------------------------------------------------------------------------------------------------------------------------
-- When column names matter
--------------------------------------------------------------------------------------------------------------------------------------------------
WITH [CTE_Requests] -- Name the CTE
     ([request_session_id], [session_session_id], [status], [login_name], [text]) -- *Column names needed because non-unique names in the SELECT statement below.
AS (
    SELECT [r].[session_id], -- Define the CTE. 
           [s].[session_id],
           [r].[status],
           [s].[login_name],
           [t].[text]
    FROM [sys].[dm_exec_requests] AS [r]
        INNER JOIN [sys].[dm_exec_sessions] AS [s]
            ON  [s].[session_id] = [r].[session_id]
        INNER JOIN [sys].[dm_exec_connections] AS [c]
            ON [s].[session_id] = [c].[session_id]
        CROSS APPLY [sys].[dm_exec_sql_text] (
            [c].[most_recent_sql_handle]) AS [t]
    WHERE [r].[status] IN ('running', 'runnable', 'suspended')
)
SELECT  [request_session_id] -- This is where we reference our CTE we've created above.
        [session_session_id],
        [status],
        [login_name],
        [text]
FROM [CTE_Requests]; -- The name of the CTE itself
GO

--------------------------------------------------------------------------------------------------------------------------------------------------
-- Execution Scope
--------------------------------------------------------------------------------------------------------------------------------------------------
--Does this work?
WITH [CTE_Requests] 
     ([session_id], [status], [login_name], [text]) 
AS (
    SELECT [r].[session_id], 
           [r].[status],
           [s].[login_name],
           [t].[text]
    FROM [sys].[dm_exec_requests] AS [r]
        INNER JOIN [sys].[dm_exec_sessions] AS [s]
            ON  [s].[session_id] = [r].[session_id]
        INNER JOIN [sys].[dm_exec_connections] AS [c]
            ON [s].[session_id] = [c].[session_id]
        CROSS APPLY [sys].[dm_exec_sql_text] (
            [c].[most_recent_sql_handle]) AS [t]
    WHERE [r].[status] IN ('running', 'runnable', 'suspended')
)
GO -- GO batch separator terminates the batch which means the below SELECT statement cannot query the CTE.

SELECT  [session_id], -- The SELECT needs to be immeadiatly after the CTE definition, not separated by a GO to be part of the same statement. 
        [status],
        [login_name],
        [text]
FROM [CTE_Requests]; 
GO

-- How about this? 
WITH [CTE_Requests] 
     ([session_id], [status], [login_name], [text]) 
AS (
    SELECT [r].[session_id], 
           
           [r].[status],
           [s].[login_name],
           [t].[text]
    FROM [sys].[dm_exec_requests] AS [r]
        INNER JOIN [sys].[dm_exec_sessions] AS [s]
            ON  [s].[session_id] = [r].[session_id]
        INNER JOIN [sys].[dm_exec_connections] AS [c]
            ON [s].[session_id] = [c].[session_id]
        CROSS APPLY [sys].[dm_exec_sql_text] (
            [c].[most_recent_sql_handle]) AS [t]
    WHERE [r].[status] IN ('running', 'runnable', 'suspended')
)
SELECT  [session_id], 
        [status],
        [login_name],
        [text]
FROM [CTE_Requests]
WHERE [session_id] = @@SPID
--UNION ALL                 -- Uncomment this to make the code work! Without this the CTE is no longer applicable in the second SELECT statement.
SELECT  [session_id], 
        [status],
        [login_name],
        [text]
FROM [CTE_Requests]
WHERE [session_id] <> @@SPID;

--------------------------------------------------------------------------------------------------------------------------------------------------
-- Multiple CTE query definitions
--------------------------------------------------------------------------------------------------------------------------------------------------
USE Master;
GO

-- Does this work?
WITH [CTE_Views_Triggers] 
    ([object_id], [name], [type_desc])
AS (
    SELECT [object_id],
           [name],
           [type_desc]
    FROM [sys].[all_views]

    SELECT [object_id],
           [name],
           [type_desc]
    FROM [sys].[triggers]
  )
  SELECT   [name],
           [object_id],
           [type_desc]
  FROM [CTE_Views_Triggers];
  GO

-- Does this work?
WITH [CTE_Views_Triggers] 
    ([object_id], [name], [type_desc])
AS (
    SELECT [object_id],
           [name],
           [type_desc]
    FROM [sys].[all_views]
    UNION ALL
    SELECT [object_id],
           [name],
           [type_desc]
    FROM [sys].[triggers]
  )
  SELECT   [name],
           [object_id],
           [type_desc]
  FROM [CTE_Views_Triggers];
  GO

-- For multiple query definitions, we can use UNION ALL, UNION, INTERSECT, or EXCEPT
-- Alternatively we can define multiple CTEs




