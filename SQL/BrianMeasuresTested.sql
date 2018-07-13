


USE [Dev_Philip_02_DataWarehouse];
GO

WITH #001 AS
(
    SELECT 
        [StudentPoSYear], [XLEV601], [XMODE01]

    FROM 
        [UoH].[DimHESA_StudentAll]

)
SELECT COUNT(DISTINCT[StudentPoSYear])
FROM #001
WHERE 
            [XLEV601] IN ('4','5')
        AND [XMODE01] = 1


