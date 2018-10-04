USE Dev_Philip_02_DataWarehouse;
GO

IF OBJECT_ID(N'dbo.HESA_StudentCount', N'U') IS NULL
BEGIN

CREATE TABLE [dbo].[HESA_StudentCount]
(
	[YearHESAReport]        [smallint]      NOT NULL,
	[RSNEND]                [varchar](2)    NOT NULL,
	[DistinctStudentCount]  [int]               NULL,
    CONSTRAINT [PK_HESA_StudentCount] PRIMARY KEY CLUSTERED 
    (
	    [YearHESAReport] ASC,
	    [RSNEND] ASC
    )
) ON [PRIMARY]
END

TRUNCATE TABLE [dbo].[HESA_StudentCount]
INSERT INTO [dbo].[HESA_StudentCount]

SELECT 
     [YEAR]                     AS YearHESAReport           -- Year of HESA Submission
    ,ISNULL([RSNEND],'0')       AS RSNEND
    ,COUNT(DISTINCT[OWNSTU])    AS DistinctStudentCount     -- Distinct count of students

-- INTO [dbo].[HESA_StudentCount]
-- DROP TABLE [dbo].[HESA_StudentCount]  
        
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
     ,[RSNEND];
     
