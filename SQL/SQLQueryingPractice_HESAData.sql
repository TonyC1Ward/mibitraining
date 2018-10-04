/*
    SQL Querying Practice - HESA Data

    Q- How many students in 2016 failed all of their modules?
    A- 3497

    Q- how many are UoHset01?
    A- 355

    Q- Which facultys in 2016 have the highest number of failures?
    A- 

    Martin Fish
    21 August 2018
*/

USE [Dev_Philip_02_DataWarehouse]

/* How many students in 2016 failed all of their modules? (Total students) */
SELECT 
     [StudentId]
    ,[IsUoHset01]
    ,COUNT([ModuleId]) AS ModuleCount
    ,SUM(CASE WHEN [IsModulePassed] = 0 THEN 1 ELSE 0 END) AS Fail
    -- The line above converts the zeros to one and everything else to zero. Effectively creates IsModuleFailed flag. 

FROM
    [UoH].[DimHESA_StudentAll]

WHERE
    [YearHESAReport] = 2016
    AND [ModuleId] <> ''
    
GROUP BY
     [StudentId]
    ,[IsUoHset01]

HAVING
    COUNT([ModuleId]) = SUM(CASE WHEN [IsModulePassed] = 0 THEN 1 ELSE 0 END)

/* Out of the above dataset, how many are UoHSet1? */
SELECT 
     [StudentId]
    ,[IsUoHset01]
    ,COUNT([ModuleId]) AS ModuleCount
    ,SUM(CASE WHEN [IsModulePassed] = 0 THEN 1 ELSE 0 END) AS Fail

FROM
    [UoH].[DimHESA_StudentAll]

WHERE
    [YearHESAReport] = 2016
    AND [ModuleId] <> ''
    AND [IsUoHset01] = 1
    
GROUP BY
     [StudentId]
    ,[IsUoHset01]

HAVING
    COUNT([ModuleId]) = SUM(CASE WHEN [IsModulePassed] = 0 THEN 1 ELSE 0 END)

/* Which facultys in 2016 have the highest number of failures? */
SELECT 
     [StudentId]
    ,[IsUoHset01]
    ,COUNT([ModuleId]) AS ModuleCount
    ,SUM(CASE WHEN [IsModulePassed] = 0 THEN 1 ELSE 0 END) AS Fail
    ,[Faculty]

FROM
    [UoH].[DimHESA_StudentAll]

WHERE
    [YearHESAReport] = 2016
    AND [ModuleId] <> ''
    AND [IsUoHset01] = 1
    
GROUP BY
     [StudentId]
    ,[IsUoHset01]
    ,[Faculty]

HAVING
    COUNT([ModuleId]) = SUM(CASE WHEN [IsModulePassed] = 0 THEN 1 ELSE 0 END)

