/*
	Measure_006
	Martin Fish
	12 July 2018
*/

-- 006_#_SPoSY_Set1_IsWithdrawn
-- Validated measure = 1,109

USE [Dev_Philip_02_DataWarehouse] 

SELECT COUNT(DISTINCT [StudentPoSYear]) AS StudentPoSYear
FROM [UoH].[DimHESA_StudentAll]
WHERE
    [XMODE01] = '1'             --  Full-time
    AND [XLEV601] IN ('4','5')  --  Undergraduate
    AND XFYRSR01 = '1'          --  First Year
    AND IsWithdrawnUoH = 1      --  Withdrawn