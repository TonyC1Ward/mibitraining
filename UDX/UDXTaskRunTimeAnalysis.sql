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

WITH UDXDetails AS (
    SELECT
         WFLO.[ShortName]                                                                                                                           AS WorkFlowShortName
        ,WFTA.[ShortName]                                                                                                                           AS TaskShortName
        ,WFTR.[StartDateTime]                                                                                                                       AS TaskRunStartDateTime
        ,WFTR.[EndDateTime]                                                                                                                         AS TaskRunEndDateTime
        ,DATEDIFF(s, WFTR.[StartDateTime], WFTR.[EndDateTime])                                                                                      AS TaskRunDuration
        ,AVG(CAST(DATEDIFF(s, WFTR.[StartDateTime], WFTR.[EndDateTime]) AS float)) OVER (PARTITION BY WFLO.[ShortName], WFTA.[ShortName])           AS AverageRunTime

    FROM
       [wf].[WorkflowTaskRun]                           AS WFTR     --  UDX Workflow Task Run
        
        INNER JOIN [wf].[WorkflowTask]                  AS WFTA     --  UDX Workflow Task
            ON WFTR.[WorkflowTaskId] = WFTA.[Id]
        INNER JOIN [wf].[WorkflowRun]                   AS WFRU     --  UDX Workflow Run
            ON WFRU.[Id] = WFTR.[WorkflowRunId]
        INNER JOIN [wf].[Workflow]                      AS WFLO     --  UDX Workflow
            ON WFLO.[Id] = WFRU.[WorkflowId]

    GROUP BY
         WFLO.[ShortName]
        ,WFTA.[ShortName]
        ,WFTR.[StartDateTime]
        ,WFTR.[EndDateTime]
)
SELECT *
FROM UDXDetails


---------------------------------------------------------------------------------------------
