USE [Dev_Martin_DataWarehouse]
GO
------------------------------------------------------------------------------------------------------------------------
--
--  Procedure     : UDX.sp_UDXTaskRunTimeAnalysis
--
--  File Name     : UDXTaskRunTimeAnalysis.sql
--
--  System Name   : Data Warehouse
--
--  Author        : M.Fish
--
--  Description   : For each task running in the UDX work out the average time taken to run and the standard deviation.  
--                : Add the Average run time to the standard deviation.
--                : Test if the last run time is longer than the average plus standard deviation.
--                : If it is report it.
--                : If the average run time for the task is less than 30 seconds, ignore it.
--                :
--                :Thanks to Lisa Silgram and Tim Davies for help and advice on developing the SP.
--                :
--
--  Version History
--
--  Version Date        Who			Description
--  ------- ----------  -----		-----------
--  1.0     17/04/2018	A.C. Ward	Original version.
--  2.0     04/10/2018	M.Fish   	Reworked version by M.F.
--
------------------------------------------------------------------------------------------------------------------------
DECLARE @GivenDate         AS DATE = GETDATE();
DECLARE @DaysOffSet        AS Integer = -28;
DECLARE @AcceptableRunTime AS Integer =  30;

;WITH UDXDetails AS (
    SELECT
         WFL.[ShortName]                                                                                                                         AS WorkFlowShortName
        ,WFT.[ShortName]                                                                                                                         AS TaskShortName
        ,WTR.[StartDateTime]                                                                                                                     AS TaskRunStartDateTime
        ,WTR.[EndDateTime]                                                                                                                       AS TaskRunEndDateTime
        ,DATEDIFF(s, WTR.[StartDateTime], WTR.[EndDateTime])                                                                                     AS TaskRunDuration      --  The difference between task run start and end time in seconds.
        ,AVG(CAST(DATEDIFF(s, WTR.[StartDateTime], WTR.[EndDateTime])     AS float)) OVER (PARTITION BY WFL.[ShortName], WFT.[ShortName])        AS AverageRunTime       --  Partitions (groups) the data together by  task name, takes the individual task run durations for each partition and works out the partition average. Casts it as a float.
        ,STDEV(CAST(DATEDIFF(s, WTR.[StartDateTime], WTR.[EndDateTime])   AS float)) OVER (PARTITION BY WFL.[ShortName], WFT.[ShortName])        AS StandardDeviation    --  Partitions the data by task name, takes the individual task run durations for each partition and works out the standard deviation for each partition. Casts it as a float.
        ,AVG(CAST(DATEDIFF(s, WTR.[StartDateTime], WTR.[EndDateTime])     AS float)) OVER (PARTITION BY WFL.[ShortName], WFT.[ShortName])
            + STDEV(CAST(DATEDIFF(s, WTR.[StartDateTime], WTR.[EndDateTime])   AS float)) OVER (PARTITION BY WFL.[ShortName], WFT.[ShortName])   AS AcceptableRunTime    --  Partitions the data by task name, adds together the average run time and the standard deviation for each partition to calculate the acceptable run time per partition. Casts it as a float. 
        ,ROW_NUMBER()                                          OVER (PARTITION BY WFL.[ShortName], WFT.[ShortName] ORDER BY WTR.[StartDateTime]) AS RowNumber            --  Adds a row number for each partition by task name, row number resets at 1 at the start of each partition. 

    FROM
       [wf].[WorkflowTaskRun]                           AS WTR     --  UDX Workflow Task Run
        
        INNER JOIN [wf].[WorkflowTask]                  AS WFT     --  UDX Workflow Task
            ON WTR.[WorkflowTaskId] = WFT.[Id]
        INNER JOIN [wf].[WorkflowRun]                   AS WFR     --  UDX Workflow Run
            ON WFR.[Id] = WTR.[WorkflowRunId]
        INNER JOIN [wf].[Workflow]                      AS WFL     --  UDX Workflow
            ON WFL.[Id] = WFR.[WorkflowId]

    /*WHERE
        CONVERT(DATE,WTR.[StartDateTime],101) BETWEEN DATEADD(d, @DaysOffSet, @GivenDate) AND @GivenDate
    */
    GROUP BY
         WFL.[ShortName]
        ,WFT.[ShortName]
        ,WTR.[StartDateTime]
        ,WTR.[EndDateTime]
)
SELECT *
FROM UDXDetails




---------------------------------------------------------------------------------------------
