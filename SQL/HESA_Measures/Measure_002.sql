/*
	Measure_002
	Martin Fish
	12 July 2018
*/

-- 002_#_SPoSYFTUG_IsWithdrawn
--  Validated measure = 1,109

USE [Dev_Philip_02_DataWarehouse] 

SELECT COUNT(DISTINCT [StudentPoSYear]) AS StudentPoSYear
FROM [UoH].[DimHESA_StudentAll]
WHERE
    [XMODE01] = '1'             --  Full-time
    AND [XLEV601] IN ('4','5')  --  Undergraduate
    AND IsWithdrawnUoH = 1      --  Withdrawn

