USE [Dev_Martin_DataWarehouse];

WITH UDXDetails AS (
    SELECT
         [WF].[ShortName]                                                   AS WorkFlowShortName
        ,[WFT].[ShortName]                                                  AS TaskShortName
        ,[WFTR].[StartDateTime]                                             AS TaskRunStartDateTime
        ,[WFTR].[EndDateTime]                                               AS TaskRunEndDateTime
    FROM
       [wf].[WorkflowTaskRun]                   AS WFTR
    INNER JOIN
       [wf].[WorkflowTask]                      AS WFT
    ON 
       [WFTR].[WorkflowTaskId] = [WFT].[Id]
    INNER JOIN
       [wf].[WorkflowRun]                       AS WFR
    ON
       [WFR].[Id] = [WFTR].[WorkflowRunId]
    INNER JOIN
       [wf].[Workflow]                          AS WF
    ON
        [WF].[Id] = [WFR].[WorkflowId]
        
)
SELECT *
FROM UDXDetails