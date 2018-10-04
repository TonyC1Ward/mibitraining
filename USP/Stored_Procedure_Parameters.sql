/*
Martin Fish
31 July 2018
Stored_Procedure_Parameters
*/

USE MOVIES;
GO

ALTER PROCEDURE usp_FilmCriteria
    (
         @MinLength AS INT
        ,@
    )        -- Creates a parameter called "MinLength" for use in the WHERE clause
AS
BEGIN
    SELECT
         FilmName
        ,FilmRunTimeMinutes
        ,FilmOscarWins

    FROM
        tblFilm

    WHERE
        FilmRunTimeMinutes > @MinLength                     -- Where run time is greater than whatever value is being passed in through the parameter "MinLength"
        AND FilmOscarWins > @MinOscars

    ORDER BY
        FilmRunTimeMinutes ASC
END