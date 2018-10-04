USE Dev_Martin_DataWarehouse;
GO

-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Martin Fish
-- Create date: 26/07/2018
-- Description:	Example template
-- =============================================

CREATE PROCEDURE [dbo].[usp_HESA_Example]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


    IF OBJECT_ID(N'dbo.HESA_Example', N'U') IS NULL
    BEGIN
    CREATE TABLE [dbo].[HESA_Example]
    (
	    [StudentID]             [varchar](20)   NOT NULL,
	    [YearHESAReport]        [smallint]      NOT NULL,
	    [EthnicID]              [varchar](2)        NULL,
	    [CourseYear]            [varchar](2)        NULL,
	    [ReasonLeftID]          [varchar](2)        NULL,
	    [LevelOfStudy]          [varchar](1)        NULL,
	    [DomicileCode]          [varchar](2)        NULL,
	    [FirstYearIdentifier]   [varchar](1)        NULL,
	    [ModeOfStudy]           [varchar](1)        NULL
        CONSTRAINT [PK_HESA_Example] PRIMARY KEY CLUSTERED 
        (
	        [StudentID] ASC,
	        [YearHESAReport] ASC
        )
    ) ON [PRIMARY]
    END

TRUNCATE TABLE [dbo].[HESA_Example]             -- Empty the table  
INSERT INTO [dbo].[HESA_Example]                -- Populate table with data

SELECT
     [OWNSTU]       AS [StudentID]
    ,[YEAR]         AS [YearHESAReport]
    ,[ETHNIC]       AS [EthnicID]           
    ,[YEARPRG]      AS [CourseYear]          
    ,[RSNEND]       AS [ReasonLeftID]           
    ,[XDLEV601]     AS [LevelOfStudy]           
    ,[XDOM01]       AS [DomicileCode]           
    ,[XFYRSR01]     AS [FirstYearIdentifier]           
    ,[XMODE01]      AS [ModeOfStudy]                      

-- INTO [dbo].[HESA_Example]                    -- Create table
-- DROP TABLE [dbo].[HESA_Example]              -- Delete table

FROM
    [UoH].[STUDENT_HESA_CoreTable_DATA]

 WHERE
    [XFYRSR01] = 1              -- First year student
    AND [XMODE01] = '1'         -- Full-time    
    AND [XLEV601] IN (4,5)      -- First degree
    AND [YEARPRG] IN ('0','1')  -- Course year  
    AND [YEAR] > 2008           -- Year of HESA Submission

ORDER BY 
    [YEAR] ASC;

END
GO