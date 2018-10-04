USE Dev_Philip_02_DataWarehouse;
GO

SELECT 
     [YEAR]                     AS YearHESAReport           -- Year of HESA Submission
    ,COUNT(DISTINCT[OWNSTU])    AS DistinctStudentCount     -- Distinct count of students
        
FROM 
    [UoH].[STUDENT_HESA_CoreTable_DATA]

WHERE
    [XFYRSR01] = 1            -- First year student
    AND [XMODE01] = '1'       -- Full-time    
    AND [XLEV601] IN (4,5)    -- First degree
    AND [YEARPRG] IN ('0','1')    -- Course year  
    AND [YEAR] > 2008         -- Year of HESA Submission

GROUP BY
     [YEAR]
     
