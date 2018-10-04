---------------------------------------------------------------------
-- WISE OWL - SQL Server Queries
-- GROUP BY and HAVING - Part 10
-- Martin Fish
-- 25 September 2018
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Aggregate Functions
---------------------------------------------------------------------
USE Movies;

-- SUM
SELECT
    SUM(FilmRunTimeMinutes) AS [TotalRunTime]
FROM
    tblFilm;

-- AVG
SELECT
    AVG(FilmRunTimeMinutes) AS [AverageRunTime]
FROM
    tblFilm;

-- Max
SELECT
    Max(FilmRunTimeMinutes) AS [AverageRunTime]
FROM
    tblFilm;
