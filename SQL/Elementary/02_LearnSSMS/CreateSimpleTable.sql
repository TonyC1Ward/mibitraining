/*
    Create Simple Table

    Example:
    CREATE TABLE SimpleTable
    (
         Column1 datatype
        ,Column 2 datatype
        ,Column 3 datatype
    )

    Martin Fish
    7 Aug 2018
*/

USE [Dev_Martin_DataWarehouse]

CREATE TABLE Albums
(
     [id] int PRIMARY KEY IDENTITY(1,1)
    ,[artistID] int FOREIGN KEY REFERENCES artists(id)
    ,[name] nvarchar(200)
    ,[year] nvarchar(4)
)

CREATE TABLE Songs
(
     [id] int primary key identity(1,1)
    ,[name] nvarchar(200)
    ,[albumID] int
    ,[TrackNumber] int
)


