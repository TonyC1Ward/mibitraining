/*
	Measure_003
	Martin Fish
	12 July 2018
*/

-- 003_#_SPoSYFTUG_FYr
-- Validated measure = 14,703

USE [Dev_Philip_02_DataWarehouse] 

SELECT COUNT(DISTINCT [StudentPoSYear]) AS StudentPoSYear
FROM [UoH].[DimHESA_StudentAll]
WHERE
    [XMODE01] = '1'             --  Full-time
    AND [XLEV601] IN ('4','5')  --  Undergraduate
    AND XFYRSR01 = '1'          --  First Year