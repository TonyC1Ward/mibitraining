/*
    AlterSchema

    Example:
    ALTER SCHEMA MySchema TRANSFER dbo.MyTable
    Move table from dbo schema to MySchema.

    Martin Fish
    7 Aug 2018
*/

USE [Dev_Martin_DataWarehouse]

ALTER SCHEMA Test TRANSFER [dbo].[TestPerson]

