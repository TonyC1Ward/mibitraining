/*
	Measure_001
	Martin Fish
	12 July 2018
*/

--  001_#_SPoSY_FTUG
--  Validated measure = 36,944

USE [Dev_Philip_02_DataWarehouse] 

SELECT COUNT(DISTINCT [StudentPoSYear]) AS StudentPoSYear
FROM [UoH].[DimHESA_StudentAll]
WHERE
    [XMODE01] = '1'             --  Full-time
    AND [XLEV601] IN ('4','5')  --  Undergraduate

