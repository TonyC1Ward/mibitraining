/*
	Measure_004
	Martin Fish
	12 July 2018
*/

-- 004_#_SPoSY_Set1_Female
-- Validated measure = 8,067

USE [Dev_Philip_02_DataWarehouse] 

SELECT COUNT(DISTINCT [StudentPoSYear]) AS StudentPoSYear
FROM [UoH].[DimHESA_StudentAll]
WHERE
    [XMODE01] = '1'             --  Full-time
    AND [XLEV601] IN ('4','5')  --  Undergraduate
    AND XFYRSR01 = '1'          --  First Year
    AND Sex = 'Female'          --  Sex Identification