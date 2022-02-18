$q  = @'
DECLARE @MinDate datetime

SELECT @MinDate = MIN(EventStartTime) FROM EVENTS WHERE LineID <>1

DECLARE @DateDiff int
SET @DateDiff = datediff(DAY, @MinDate, getdate())
SELECT @DateDiff

UPDATE Events SET 
EventCreationTime = DATEADD(DAY, @DateDiff, EventCreationTime),
EventStartTime = DATEADD(DAY, @DateDiff, EventStartTime),
BetStartDate = DATEADD(DAY, @DateDiff, BetStartDate),
BetEndDate = DATEADD(DAY, @DateDiff, BetEndDate)
WHERE LineID <>1
'@

Invoke-Sqlcmd -verbose -ServerInstance $env:COMPUTERNAME -Database 'BaltBetM' -query $q -ErrorAction Stop
