/*
	Measure_001
	Martin Fish
	12 July 2018
*/

--  001_#_SPoSY_FTUG
--  Validated measure = 36,944

USE [Dev_Philip_02_DataWarehouse] 

SELECT * --COUNT(DISTINCT [StudentPoSYear]) AS StudentPoSYear
FROM [UoH].[DimHESA_StudentAll]
WHERE
    IsNonConUoHset01 = 1
    AND LEFT(AcademicSessionID,4) = '1617'
    AND SubjectGroupArea = 'electrical and Electronic Engineering'
    AND IsModulePassed = 1
    AND ModuleTitle = 'Engineering global challenge I'


SELECT DISTINCT IsNonConUoHset01
FROM [UoH].[DimHESA_StudentAll]
WHERE IsUoHset01 = 0