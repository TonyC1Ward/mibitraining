/*
Martin Fish
31 July 2018
Stored_Procedure_Basics
*/
USE MOVIES;

GO

ALTER PROCEDURE usp_FilmList
AS
BEGIN
    SELECT 
         FilmName
        ,FilmReleaseDate
        ,FilmRunTimeMinutes
    
    FROM 
        tblFilm
    
    ORDER BY 
        FilmName DESC
END

