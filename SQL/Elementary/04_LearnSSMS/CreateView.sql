/*
Create a View

Martin Fish
9 August 2018

*/

USE [TSQLV4]


CREATE VIEW v_TSQL4_Managers
AS
SELECT *
  FROM [TSQLV4].[HR].[Employees]
  WHERE title <> 'Sales Representative';
