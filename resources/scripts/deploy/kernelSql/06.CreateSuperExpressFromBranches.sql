USE BaltBetM
GO
SET QUOTED_IDENTIFIER ON
GO
----CLEAR SECTION-----
delete from BetLinks
delete from BaltBetWeb.dbo.BetEvents
DELETE from BaltBetWeb.dbo.Bets
delete from BetEvents
DELETE from Bets
delete from SuperExpressBetVariants
delete from EventGroupMembers
delete from EventGroups
update events set EventGroupId = null
GO
----END CLEAR SECTION-----
if (object_id('SetSuperExpressEventRandomResult') is not null)
DROP PROCEDURE [dbo].SetSuperExpressEventRandomResult
if (object_id('CreateSuperExpressBets') is not null)
DROP PROCEDURE [dbo].CreateSuperExpressBets
if (object_id('CreateSuperExpressWebBets') is not null)
DROP PROCEDURE [dbo].CreateSuperExpressWebBets
if (object_id('SetSuperExpressEventResult') is not null)
DROP PROCEDURE [dbo].SetSuperExpressEventResult
if (object_id('CreateSuperExpressEvents') is not null)
DROP PROCEDURE [dbo].CreateSuperExpressEvents
if (object_id('CreateSuperExpress') is not null)
DROP procedure [dbo].[CreateSuperExpress]
if (object_id('CreateSuperExpressPart') is not null)
DROP procedure [dbo].[CreateSuperExpressPart]
if (object_id('CreateSuperExpressesForTest') is not null)
drop PROCEDURE [CreateSuperExpressesForTest]
GO
CREATE procedure [dbo].[CreateSuperExpressPart]
@EventGroupId int, @BranchId INT, @EventStartTime DATETIME, @EventCount int
AS
BEGIN
SET NOCOUNT ON
DECLARE @EventID int,@EventGroupMemberId int,@StartSortOrder int, @LoopCounter int=0
SELECT @StartSortOrder = ISNULL(max(SortOrder),0)+1 from eventgroupmembers WHERE EventGroupId = @EventGroupId
SELECT @EventGroupMemberId = ISNULL(max(EventGroupMemberId),0)+1 from eventgroupmembers
DECLARE ec CURSOR
READ_ONLY
FOR select top (@EventCount) LineID from events where LineMemberId = @BranchId AND EventGroupId IS NULL
OPEN ec
FETCH NEXT FROM ec INTO @eventid
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
        UPDATE Events SET EventStartTime = @EventStartTime, EventGroupId = @EventGroupId WHERE LineID = @EventID
		INSERT INTO eventgroupmembers (EventGroupMemberId, EventGroupId, EventId,SortOrder)
		VALUES(@EventGroupMemberId+@LoopCounter,@EventGroupId,@EventID,@StartSortOrder+@LoopCounter)
		SET @LoopCounter = @LoopCounter+1
        UPDATE Coefs SET IsHaveBets = 1 WHERE LineID = @EventID AND CoefTypeID in (1,2,3)
	END
	FETCH NEXT FROM ec INTO @eventid
END

CLOSE ec
DEALLOCATE ec
END
go
CREATE procedure [dbo].[CreateSuperExpress]
@BranchId1 INT,@BranchId2 INT,@BranchId3 INT, @Active bit, @EventStartDate datetime
AS
BEGIN
SET NOCOUNT ON
DECLARE @WorkerID int = 7279
DECLARE @EventGroupId int
DECLARE @EventGroupMemberId int
DECLARE @EventID int
DECLARE @CoefID int
SELECT @EventGroupId = ISNULL(max(EventGroupId),200)+1 from eventgroups
--Добавить тираж
declare @Name nvarchar(100) = '№'+cast(@EventGroupId as nvarchar(4))
declare @SitName nvarchar(100) = 'Тираж №'+cast(@EventGroupId as nvarchar(4))
INSERT INTO eventgroups (EventGroupId, EventGroupName,EventGroupType,EventGroupActive,EventGroupJackPot,EventGroupJackPotAssigned,EventGroupComment, EventGroupData, SiteName, StartTime)
VALUES(@EventGroupId,@Name,4,1,1000000,0,'0','',@SitName, @EventStartDate)
IF (@Active=0)
UPDATE EventGroups set EventGroupComment='2|1913557|15:0(0)|14:0(0)|13:0(0)|12:311,25(10)|11:2704,12(86)|10:15967,62(505)|9:63280,04(2005)' where EventGroupId=@EventGroupId
exec CreateSuperExpressPart @EventGroupId, @BranchId1, @EventStartDate, 6
exec CreateSuperExpressPart @EventGroupId, @BranchId2, @EventStartDate, 7
exec CreateSuperExpressPart @EventGroupId, @BranchId3, @EventStartDate, 2
END
GO
CREATE procedure [dbo].[CreateSuperExpressesForTest]
AS
BEGIN
SET NOCOUNT ON
DELETE FROM EventGroupMembers
DELETE FROM eventgroups
DECLARE @ActualSE DATETIME = DATEADD(HOUR, 2, getdate())
DECLARE @OldSE DATETIME = DATEADD(DAY, -1, getdate())
DECLARE @FutureSE DATETIME = DATEADD(DAY, 1, getdate())
exec [CreateSuperExpress] 830,809,18,0, @OldSE
exec [CreateSuperExpress] 830,809,18,1, @ActualSE
exec [CreateSuperExpress] 830,809,18,1, @FutureSE
END
go
CREATE PROCEDURE SetSuperExpressEventResult
(
@SuperExpressID int,
@CoefTypeId int
)
AS
SET NOCOUNT ON
BEGIN
UPDATE Coefs
SET CoefWon = CASE when Coefs.CoefTypeID = @CoefTypeId then 1 else 0 end
FROM Events
INNER JOIN Coefs ON EVENTS.LineID = COEFS.LineID
INNER JOIN EventGroupMembers ON EVENTS.LineID = EventGroupMembers.EventId
WHERE EventGroupMembers.EventGroupId = @SuperExpressID

UPDATE Coefs
SET CoefWon = 0
FROM Events
INNER JOIN Coefs ON EVENTS.LineID = COEFS.LineID
INNER JOIN EventGroupMembers ON EVENTS.LineID = EventGroupMembers.EventId
WHERE EventGroupMembers.EventGroupId = @SuperExpressID AND Coefs.CoefWon IS NULL

UPDATE Events
SET EventStartTime = getdate()
FROM Events
INNER JOIN EventGroupMembers ON EVENTS.LineID = EventGroupMembers.EventId
WHERE EventGroupMembers.EventGroupId = @SuperExpressID

INSERT INTO BaltBetWeb.DBO.Translations(TranslationCachId, LanguageId, Text)
SELECT CoefID+10000, 1, CoefTypes.CoefTypeName FROM Coefs
INNER JOIN CoefTypes ON COEFS.CoefTypeID = CoefTypes.CoefTypeID

INSERT INTO BaltBetWeb.DBO.Coefs
(
CoefId,EventId,TranslationCachId,CoefValue,CoefWon,WorkerId
)
SELECT CoefID, LineID, CoefID+10000, CoefValue, CoefWon, 7279 FROM COEFS 
END
GO

CREATE PROCEDURE SetSuperExpressEventRandomResult
(
@SuperExpressID int
)
AS
SET NOCOUNT ON
BEGIN
;WITH cte AS
(
   SELECT coefs.CoefID,
   ROW_NUMBER() OVER (PARTITION BY LineID ORDER BY NEWID()) as RN
   from EventGroupMembers
INNER JOIN COEFS ON COEFS.CoefTypeID IN (1,2,3) AND EventGroupMembers.EventId = COEFS.LineID
INNER JOIN CoefTypes on CoefTypes.CoefTypeID = coefs.CoefTypeID
WHERE EventGroupMembers.EventGroupId = @SuperExpressID
)
UPDATE Coefs
SET CoefWon = 1
FROM Coefs
INNER JOIN cte ON cte.CoefID = Coefs.CoefID
WHERE cte.RN = 1

UPDATE Coefs
SET CoefWon = 0
FROM Events
INNER JOIN Coefs ON EVENTS.LineID = COEFS.LineID
INNER JOIN EventGroupMembers ON EVENTS.LineID = EventGroupMembers.EventId
WHERE EventGroupMembers.EventGroupId = @SuperExpressID AND Coefs.CoefWon IS NULL

UPDATE Events
SET EventStartTime = getdate()
FROM Events
INNER JOIN EventGroupMembers ON EVENTS.LineID = EventGroupMembers.EventId
WHERE EventGroupMembers.EventGroupId = @SuperExpressID

INSERT INTO BaltBetWeb.DBO.Translations(TranslationCachId, LanguageId, Text)
SELECT CoefID+10000, 1, CoefTypes.CoefTypeName FROM Coefs
INNER JOIN CoefTypes ON COEFS.CoefTypeID = CoefTypes.CoefTypeID

INSERT INTO BaltBetWeb.DBO.Coefs
(
CoefId,EventId,TranslationCachId,CoefValue,CoefWon,WorkerId
)
SELECT CoefID, LineID, CoefID+10000, CoefValue, CoefWon, 7279 FROM COEFS 
END
GO

CREATE PROCEDURE CreateSuperExpressBets
(
@SuperExpressID int, @BetCount int
)
AS
SET NOCOUNT ON
BEGIN
DECLARE @BetId int
select @BetId = ISNULL(max(BetId),0)+1 from bets
DECLARE @LoopCounter int =0
while(@LoopCounter<@BetCount)
begin
DECLARE @BetSum FLOAT
set @BetSum = cast(RAND()*1000 as int)
DECLARE @Bonus int
SET @Bonus = @BetSum
DECLARE @AccountId int
DECLARE @PlayerType int
DECLARE @ClientId int
select @AccountId = AccountId, @PlayerType = PlayerType from ACCOUNTS WHERE PlayerType IN (0,2) order by newid()
IF (@PlayerType=0)
SELECT @ClientId = ClientId from Clients where ClientTypeId=2 and Status =0 order by newid()
ELSE
SET @ClientId = 7773
INSERT INTO Bets(
BetId,
WorkerId,
AccountId,
BetTypeID,
ClientId,
BetSum,
BetWinSum,
BetCreationTime,
BetWin,
BetFormuleText,
BetValid,
BetWinPayed,
BetDeleted,
BetAccepted,
BetResultTime,
BetCode,
ClientNumber,
PayType,
CoefValue,
SumToWin,
KRMID,
ParentBetID,
Bonus,
JsonPary,
TaxTransactionId,
BetTax,
CouponId,
VIP,
SoldDate,
SuperExpressID,
PackageBet)
VALUES
(
@BetId,
7279,
@AccountId,
8,
@ClientId,
@BetSum,
0,
GETDATE(),
NULL,
CAST(@SuperExpressID as nvarchar(10))+'-1-',
1,
0,
1,
1,
NULL,
'AWER',
0,
3,
1,
0,
NULL,
NULL,
@Bonus,
NULL,
NULL,
NULL,
NULL,
0,
NULL,
@SuperExpressID,
NULL
)
DECLARE @BetEventID INT
select @BetEventID = isnull(max(BetEventId),0) + 1 from BetEvents
;WITH cte AS
(
   SELECT @BetEventID + ROW_NUMBER() over(order by coefs.CoefID) as BetEventId, 
   ROW_NUMBER() over(order by coefs.CoefID) as GroupNumber,
   coefs.CoefID, coefs.LineID,coefs.CoefValue, CoefTypes.CoefTypeName,
   ROW_NUMBER() OVER (PARTITION BY LineID ORDER BY NEWID()) as RN,
   EventGroupMembers.EventId
   from EventGroupMembers
INNER JOIN COEFS ON COEFS.CoefTypeID IN (1,2,3) AND EventGroupMembers.EventId = COEFS.LineID
INNER JOIN CoefTypes on CoefTypes.CoefTypeID = coefs.CoefTypeID
WHERE EventGroupMembers.EventGroupId = @SuperExpressID
)
INSERT INTO BetEvents
(
BetEventId, CoefID,BetId,BetEventGroup,EventId,CoefValue,CoefName
)
SELECT BetEventId, CoefID, @BetId, GroupNumber, EventId, CoefValue, CoefTypeName
FROM cte
WHERE rn = 1

SET @LoopCounter = @LoopCounter+1
SET @BetId = @BetId+1
end
INSERT INTO BetLinks(BetId, LocationType)
select betid,1 from Bets
END
GO

CREATE PROCEDURE CreateSuperExpressWebBets
(
@SuperExpressID int, @BetCount int
)
AS
SET NOCOUNT ON
BEGIN
DECLARE @BetId int
select @BetId = ISNULL(max(BetId),0)+1 from bets
DECLARE @LoopCounter int =0
while(@LoopCounter<@BetCount)
begin
DECLARE @BetSum FLOAT
set @BetSum = cast(RAND()*1000 as int)
DECLARE @Bonus int
SET @Bonus = @BetSum
DECLARE @AccountId int
select @AccountId = AccountId from ACCOUNTS WHERE PlayerType =1 and Accountid <> 1 order by newid()
INSERT INTO BaltBetWeb.dbo.Bets(
BetId,
AccountId,
BetTypeID,
ClientId,
BetSum,
BetWinSum,
BetCreationTime,
BetWin,
BetFormuleText,
BetWinPayed,
BetDeleted,
BetAccepted,
BetResultTime,
PayType,
VIP,
SuperExpressID,
SiteVersion,
BetBonus
)
VALUES
(
@BetId,
@AccountId,
8,
777,
@BetSum,
0,
GETDATE(),
NULL,
CAST(@SuperExpressID as nvarchar(10))+'-15-',
0,
0,
1,
NULL,
16,
0,
@SuperExpressID,
1,
@Bonus
)
DECLARE @BetEventID INT
select @BetEventID = isnull(max(BetEventId),0) + 1 from BaltBetWeb.dbo.BetEvents
;WITH cte AS
(
   SELECT @BetEventID + ROW_NUMBER() over(order by coefs.CoefID) as BetEventId, 
   coefs.CoefID,
   ROW_NUMBER() OVER (PARTITION BY LineID ORDER BY NEWID()) as RN,
   ROW_NUMBER() over(order by coefs.CoefID) as GroupNumber
   from EventGroupMembers
INNER JOIN COEFS ON COEFS.CoefTypeID IN (1,2,3) AND EventGroupMembers.EventId = COEFS.LineID
WHERE EventGroupMembers.EventGroupId = @SuperExpressID
)
INSERT INTO BaltBetWeb.dbo.BetEvents
(
BetEventId, CoefID,BetId,BetEventGroup
)
SELECT BetEventId, CoefID, @BetId, GroupNumber
FROM cte
WHERE rn = 1

SET @LoopCounter = @LoopCounter+1
SET @BetId = @BetId+1
end
INSERT INTO BetLinks(BetId, LocationType)
select betid,2 from BaltBetWeb.dbo.Bets
END
GO
--Создать тираж и события
EXEC [CreateSuperExpressesForTest]
go
--Создать ставки
exec dbo.CreateSuperExpressBets 202, 1000
go
--Создать ставки на Web
exec dbo.CreateSuperExpressWebBets 202, 1000
go
DROP SEQUENCE [dbo].[BetSequence]
GO
DECLARE @Betid int, @WebBetId int
select @BetId  = max(betid) from bets
select @WebBetId  = max(betid) from BaltBetWeb.dbo.bets
IF (@WebBetId>@BetId)
SET @BetId = @WebBetId
SET @BetId +=1
DECLARE @TextBetId nvarchar(10)
set @TextBetId = CAST(@Betid as nvarchar(10))

DECLARE @sql varchar(1000)
set @sql = N'CREATE SEQUENCE [dbo].[BetSequence] 
 AS [int]
 START WITH ' + @TextBetId + '
 INCREMENT BY 500
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go


--Закончить тираж со случайным результатом
--exec dbo.SetSuperExpressEventRandomResult 2
--Закончить тираж с известным результатом
--exec dbo.SetSuperExpressEventResult 2, 1

go
