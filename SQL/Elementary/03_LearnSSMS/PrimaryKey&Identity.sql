/*
    Primary Key & Identity
  
    Martin Fish
    7 Aug 2018

*/

-- Create new table to hold rows
USE [Dev_Martin_DataWarehouse]

CREATE TABLE ProductionCompany
(
	 [id] int IDENTITY(1,1) PRIMARY KEY -- Defines the ID column to be an auto-incremented (starts at 1 and increases by 1 each time) primary key field.
	,[Name] nvarchar(200)
	,[Abbreviation] nvarchar(3)
)

-- Create new rows
INSERT INTO ProductionCompany
(										-- To insert a new record into the Production Company table we do NOT have to specify a value for the ID column as it is automatically added.
	 [name]
	,[Abbreviation]
)
VALUES
	 ('Google', 'GGL')
	,('Amazon', 'AMZ')
	,('British Broadcasting Corporation', 'BBC')


SELECT *
FROM ProductionCompany