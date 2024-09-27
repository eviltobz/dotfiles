
/*
select top 10 * from workflowActivity order by workflowactivityid desc

select top 10 * from workflowActivityLog where workflowActivityId = 54
order by processingStartTime desc
*/


--SELECT WorkflowActivityLogId, ProcessingStartTime, ProcessingEndTime, '--', *
--FROM workflowActivityLog l
----WHERE workflowActivityId = 54 
--order by l.processingStartTime desc
	

-- 9.45 40-50ish?
use MassivisionCore

-- SET @Id to get a specific run, leave null to get the latest run for the @ActivityTypeId
DECLARE @Id UNIQUEIDENTIFIER --= '0CA3E025-4537-EE11-AC1D-0A28845B2C38'
DECLARE @ActivityTypeId INT = 54 -- 54 for Gameday, 55? for Forge Delta????
----------------------------------
DECLARE @StartTime DATETIME 
DECLARE @EndTime DATETIME

IF @Id is NULL
BEGIN
	-- Get latest activity log Id, start & end
	SELECT TOP 1 @Id = WorkflowActivityLogId, @StartTime = ProcessingStartTime, @EndTime = ProcessingEndTime FROM workflowActivityLog WHERE workflowActivityId = @ActivityTypeId order by processingStartTime desc
	IF @Id IS NULL
	BEGIN
		DECLARE @type NVARCHAR(100)
		SELECT TOP 1 @type = WorkflowActivityKey FROM workflowActivity WHERE WorkflowActivityId = @ActivityTypeId
		SELECT 'No workflow activity logs found for type: ' 'Error Message', @type 'Type', @ActivityTypeId 'Type Id'
	END
END
ELSE
BEGIN
	-- Get specific activity log start & end
	SELECT TOP 1 @StartTime = ProcessingStartTime, @EndTime = ProcessingEndTime FROM workflowActivityLog WHERE workflowActivityLogId = @Id
END
-- Get entity count
DECLARE @CountString VARCHAR(50)
SELECT @CountString = Message FROM workflowActivityLogMessage WHERE WorkflowActivityLogID = @Id AND Message LIKE '% domain entities prepared for ingestion'
DECLARE @SpaceIndex INT = CHARINDEX(' ', @CountString)
DECLARE @EntityCount FLOAT = CAST(SUBSTRING(@CountString, 0, @SpaceIndex) AS FLOAT)

-- Progress
IF @EndTime IS NULL
BEGIN
	SET @EndTime = GETDATE()
	DECLARE @RuntimeMins INT = DATEDIFF(MINUTE, @StartTime, @EndTime)

	
	--select *
	--	from workflowActivityLogMessage 	where WorkflowActivityLogID = @Id 	and message like '%batch #%'

	select 'Running' 'Status', CAST(count(0) * 5 AS VARCHAR(30)) + '/' + CAST(@EntityCount AS VARCHAR(10)) 'Approx Completed', 
		(CAST((count(0) * 5) AS FLOAT)/@EntityCount) * CAST(100 AS FLOAT) 'Approx %', @RuntimeMins 'Runtime minutes', 
		@RuntimeMins/ 60.0 'Runtime hours', 
		  @Id workflowActivityLogId, @startTime StartedAt 
		from workflowActivityLogMessage 	where WorkflowActivityLogID = @Id 	and message like '%batch #%'

		DECLARE @SavedItemCount int
		SELECT @SavedItemCount = COUNT(0) * 5 FROM workflowActivityLogMessage 	where WorkflowActivityLogID = @Id 	and message like '%batch #%'
		
		DECLARE @ItemsPerMinute FLOAT = CASE WHEN @RuntimeMins = 0 THEN 1 ELSE CAST(@SavedItemCount AS FLOAT) / CAST(@RuntimeMins AS FLOAT) END
		DECLARE @EstimatedRuntimeMins INT = CASE WHEN @ItemsPerMinute = 0 THEN 0 ELSE @EntityCount / @ItemsPerMinute END
		DECLARE @EstimatedRuntimeHours FLOAT = CAST(@EstimatedRuntimeMins AS FLOAT) / 60.0
		DECLARE @EstimatedRemainingMins INT = @EstimatedRuntimeMins - @RuntimeMins
		DECLARE @EstimatedRemainingHours FLOAT = CAST(@EstimatedRemainingMins AS FLOAT) / 60.0
		
		select CAST(@SavedItemCount AS VARCHAR(30)) + '/' + CAST(@EntityCount AS VARCHAR(10)) 'Approx Completed', 
		(CAST(@SavedItemCount AS FLOAT)/@EntityCount) * CAST(100 AS FLOAT) 'Approx %', 
			@RuntimeMins 'Runtime minutes', DATEDIFF(HOUR, @StartTime, @EndTime) 'Runtime hours', 
			@ItemsPerMinute 'Items/Min', 
			@EstimatedRuntimeMins 'RuntimeMins',
			@EstimatedRuntimeHours 'RuntimeHours',
			@EstimatedRemainingMins 'RemainingMins',
			@EstimatedRemainingHours 'RemainingHours'

END
ELSE
BEGIN
	select 'Completed' 'Status', CAST(count(0) * 5 AS VARCHAR(30)) + '/' + CAST(@EntityCount AS VARCHAR(10)) 'Approx Completed',  
	  (CAST((count(0) * 5) AS FLOAT)/@EntityCount) * CAST(100 AS FLOAT) 'Approx %', 
			DATEDIFF(MINUTE, @StartTime, @EndTime) 'Runtime minutes', DATEDIFF(MINUTE, @StartTime, @EndTime) / 60.0 'Runtime hours', 
	  @Id workflowActivityLogId, @startTime StartedAt, @EndTime FinishedAt
	from workflowActivityLogMessage 	where WorkflowActivityLogID = @Id 	and message like '%batch #%'
END
-- Errors
select top 1000 MessageIndex, Message 'Errors' from workflowActivityLogMessage 	where WorkflowActivityLogID = @Id  and messageType > 2 order by messageIndex desc
-- Log Tail	
select top 1000 MessageIndex, MessageType, Message as 'Log Tail' from workflowActivityLogMessage 	
where WorkflowActivityLogID = @Id order by messageIndex desc


---- Log start
--select top 100 MessageIndex, MessageType, Message as 'Log Tail' from workflowActivityLogMessage 	where WorkflowActivityLogID = @Id order by messageIndex asc

