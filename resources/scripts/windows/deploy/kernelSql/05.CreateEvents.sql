USE BaltBetM
GO
SET QUOTED_IDENTIFIER ON
GO

IF (OBJECT_ID('CreateMultiEvents ') IS NOT NULL)
DROP PROCEDURE CreateMultiEvents 
GO
---Раскомментировать если хочется очистить БД от событий
/*
Delete from EventBind
Delete from EventComments
delete from EventGroupMembers
delete from EventGroups
delete from coefs where LineID<>1
delete from EventMembers where LineID<>1
delete from events where LineID<>1
go
*/
CREATE PROCEDURE [dbo].[CreateMultiEvents]
@LineMemberId INT, --Код ветки, в которой будут созданы события
@EventStartTime DATETIME, --Базовая дата начала события
@EventCount int, --Кол-во событий для генерации
@StartEventId int =1, --С какого кода события начинать генерацию
@GroupId INT,--Верхний уровень дерева
@Live bit,
@GenKWEvents bit = 0,
@GenAdditionalCoefs bit = 1
AS
BEGIN
SET NOCOUNT ON
DECLARE @WorkerID int = 7279 --Код букмекера
DECLARE @EventGroupMemberId int
DECLARE @EventID int
DECLARE @PlayerGroupId int
SELECT @PlayerGroupId  =isnull(LineMemberMembersGroupId,LineMemberId) from LineMembers where LineMemberId = @LineMemberId
SELECT LineMemberId1 as PlayerId, LINEMEMBERS.LineMemberText AS PlayerName into #TempPlayers from LineMemberBind
INNER JOIN LINEMEMBERS ON LINEMEMBERS.LineMemberId = LineMemberBind.LineMemberId1
where LineMemberId2 = @PlayerGroupId
DECLARE @EventTypeId INT
SELECT @EventTypeId = LineMemberEventTypeId FROM LINEMEMBERS WHERE LineMemberId = @LineMemberId
select @EventID = ISNULL(max(LineID),0)+1 from Events
IF (@EventID<@StartEventId)
	SET @EventID = @StartEventId
DECLARE @EventMemberId int
SELECT @EventMemberId = ISNULL(max(EventMemberId),0) from EventMembers
DECLARE @LoopCounter int =0
while(@EventCount>@LoopCounter)
BEGIN
	DECLARE @Hours INT = RAND() * 100 + 1--Количество часов добавляемых к базовой дате начала
	DECLARE @StartDate datetime = DATEADD(HOUR, @Hours, @EventStartTime)
	DECLARE @PlayerName nvarchar(50), @PlayerName2 nvarchar(50), @Player1Id int, @Player2Id int
	SELECT top 1 @Player1Id = PlayerId, @PlayerName = PlayerName FROM #TempPlayers order by newid()
	SELECT top 1 @Player2Id = PlayerId, @PlayerName2 = PlayerName FROM #TempPlayers order by newid()
	INSERT INTO events(LineID, EventTypeId, LineMemberId, WorkerId, EventCreationTime, EventStartTime, EventActive, EventFinished, EventResultText, MaxBetLimit, MinBetLimit, MinExpressCount, MaxExpressCount, EventName,Live, EventTypeGroupID,ClientShow, BetStartDate, BetEndDate, IsBetFinished) 
	VALUES(@EventID,@EventTypeId, @LineMemberId,@WorkerID,getdate(),@StartDate,1,0,'',10000,20,0,0, @PlayerName + '-' + @PlayerName2, @Live,@GroupId,15,getdate(), @StartDate, 0)
    INSERT INTO EventComments(EventId) VALUES(@EventID)
	INSERT INTO EventMembers(EventMemberId,LineID,LineMemberId)
	VALUES(@EventMemberId+1,@EventID,@Player1Id)
	INSERT INTO EventMembers(EventMemberId,LineID,LineMemberId)
	VALUES(@EventMemberId+2,@EventID,@Player2Id)
	IF (@GenKWEvents=1)
	BEGIN
		INSERT INTO BaltBetWeb.DBO.Translations(TranslationCachId, LanguageId, Text)
		VALUES(@EventID, 1, @PlayerName + '-' + @PlayerName2)

		INSERT INTO BaltBetWeb.dbo.Events(EventId, TranslationCachId, EventStartTime, EventResultText)
		VALUES(@EventID, @EventID, @EventStartTime, '')
	END
declare @coefid bigint
select @CoefID = ISNULL(max(CoefID),0) from coefs
BEGIN
	SELECT @CoefID = ISNULL(max(CoefID),0) from coefs
	DECLARE CoefCursor CURSOR
	READ_ONLY
	FOR
	SELECT CoefTypes.CoefTypeID, CoefTypes.CoefAdditType, CoefTypes.CoefTypeDefaultValue, CoefTypes.CoefTypeDefaultAddit, CoefTypes.MainCoefTypeId, CoefTypes.CoefMemberNodeId, CoefTypes.CoefTypeName
	FROM EventTCoefTBind
	INNER JOIN CoefTypes ON CoefTypes.CoefTypeID = EventTCoefTBind.CoefTypeID
	where EventTypeId = @EventTypeId
    AND ((@GenAdditionalCoefs = 0 AND CoefTypes.IsMain=1) OR (@GenAdditionalCoefs = 1))
    ORDER BY EventTCoefTBind.EventTypesCoefTypesBindId

	DECLARE @CoefTypeID int, @CoefAdditType int, @CoefTypeDefaultValue FLOAT, @CoefTypeDefaultAddit nvarchar(10), @MainCoefTypeId INT, @CoefMemberNodeId INT, @Swap bit =0, @CoefTypeName nvarchar(100)
	OPEN CoefCursor
	FETCH NEXT FROM CoefCursor INTO @CoefTypeID, @CoefAdditType, @CoefTypeDefaultValue, @CoefTypeDefaultAddit, @MainCoefTypeId, @CoefMemberNodeId,@CoefTypeName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			DECLARE @RefCoefId bigint = NULL
			DECLARE @CoefMemberId int = NULL
			SET @coefid +=1
			IF (@MainCoefTypeId is not null)
				set @RefCoefId = (SELECT TOP 1 CoefID FROM COEFS WHERE LineID = @EventID AND CoefTypeID = @MainCoefTypeId)
			IF (@CoefAdditType>=0)
			BEGIN
				IF (ISNULL(@CoefTypeDefaultValue,0)=0)
					SET @CoefTypeDefaultValue = round(1+RAND(convert(varbinary, newid())),2)
			END
			ELSE
			SET @CoefTypeDefaultValue = 1
                IF ((@CoefAdditType=-1 or @CoefAdditType=1) AND @CoefTypeName like '%счет%')
					SET @CoefTypeDefaultAddit = cast (ROUND(7*RAND(convert(varbinary, newid())),0)  as nvarchar(1)) + '-' + cast (ROUND(7*RAND(convert(varbinary, newid())),0)  as nvarchar(1))
				ELSE IF (@CoefAdditType=-1 or @CoefAdditType=1)
					SET @CoefTypeDefaultAddit = (CASE WHEN RAND(convert(varbinary, newid())) > 0.5 THEN '+' ELSE '-' END) + cast (2.5 + ROUND(7*RAND(convert(varbinary, newid())),0)  as nvarchar(3))
				ELSE IF (@CoefAdditType=1000)
					BEGIN
						IF (@Swap=1)
							BEGIN
								set @CoefMemberId =@Player1Id
								SET @Swap=0
							END
						ELSE
							BEGIN
								set @CoefMemberId =@Player2Id
								SET @Swap=1
							END
					END
				ELSE IF (@CoefMemberNodeId=125379)
				SET @CoefTypeDefaultAddit = CAST(125381 as NVARCHAR(100))
				ELSE IF (@CoefMemberNodeId=125376)
					BEGIN
						IF (@Swap=1)
							BEGIN
								SET @CoefTypeDefaultAddit = CAST(@Player1Id as NVARCHAR(100))
								SET @Swap=0
							END
						ELSE
							BEGIN
								SET @CoefTypeDefaultAddit = CAST(@Player2Id as NVARCHAR(100))
								SET @Swap=1
							END
					END
				ELSE IF ((@CoefAdditType=-5 or @CoefAdditType=5) AND @CoefMemberNodeId IS NOT NULL)
					    select TOP 1 @CoefTypeDefaultAddit = CAST(LineMemberId1 AS NVARCHAR(7)) from LineMemberBind WHERE LineMemberId2 = @CoefMemberNodeId AND LineMemberBindVisible = 1 AND LineMemberBindTypeId = 1 ORDER BY NEWID()
                ELSE IF (@CoefAdditType=-3 or @CoefAdditType=3)
                    BEGIN
					    select TOP 1 @CoefTypeDefaultAddit = CAST(LineMemberId1 AS NVARCHAR(7)) from LineMemberBind
                        inner join linemembers on LineMemberId1 = LineMemberId
                        WHERE LineMemberId2 IN (@Player1Id,@Player2Id) AND LineMemberBindVisible = 1 AND LineMemberBindTypeId = 1
                        ORDER BY NEWID()
                    END
                IF (@CoefTypeDefaultAddit is NULL)
                    BEGIN
                    PRINT('PlayerGroupId' + ' - ' + CAST(@PlayerGroupId as NVARCHAR(100)))
                    PRINT('LineMemberId' + ' - ' + CAST(@LineMemberId as NVARCHAR(100)))
                    PRINT(CAST(@Player1Id as NVARCHAR(100)) + ' ' + CAST(@Player2Id as NVARCHAR(100)) + ' ' + CAST(@CoefTypeID as nvarchar(10)) + ' ' + CAST(@CoefMemberNodeId as nvarchar(10)))
                    END
			INSERT INTO coefs(CoefID, LineID, CoefTypeID, CoefValue, CoefActive, CoefAddit, CoefDateTime, CoefValid, CoefManual, WorkerId,RefCoefId, CoefMemberId)
			VALUES(@coefid,@EventID,@CoefTypeID,@CoefTypeDefaultValue, 1, @CoefTypeDefaultAddit, GETDATE(), 1,0,@WorkerID,@RefCoefId,@CoefMemberId)
		END
	FETCH NEXT FROM CoefCursor INTO @CoefTypeID, @CoefAdditType, @CoefTypeDefaultValue, @CoefTypeDefaultAddit, @MainCoefTypeId, @CoefMemberNodeId,@CoefTypeName
END

CLOSE CoefCursor
DEALLOCATE CoefCursor
END
	SET @EventMemberId = @EventMemberId+2
	SET @EventID = @EventID+1
	SET @LoopCounter = @LoopCounter+1
END
END
go
declare @Now datetime
set @Now = getdate()
DECLARE @StartEventId int = 11492171
exec CreateMultiEvents 830,@Now, 30,@StartEventId, 1,0 -- Футбол Англия. 1-я Лига
exec CreateMultiEvents 18,@Now, 30,@StartEventId, 14,0--Хоккей Россия.  КХЛ
exec CreateMultiEvents 490375,@Now, 10,@StartEventId, 893,0--Теннис Кубок Дэвиса. Мировая группа. Квалификационный раунд. Мужчины
exec CreateMultiEvents 501710,@Now, 10,@StartEventId, 4458,0--Настольный теннис ITT Cup. Мужчины
exec CreateMultiEvents 167012,@Now, 10,@StartEventId, 153044,0--Бадминтон US Open. Женщины
exec CreateMultiEvents 809,@Now, 30,@StartEventId, 1,0 -- Футбол Англия.   Премьер-Лига
exec CreateMultiEvents 1649,@Now, 10,@StartEventId, 14,0--Хоккей  США.  NHL
exec CreateMultiEvents 7370,@Now, 10,@StartEventId, 893,0--Теннис Большой Шлем.  Wimbledon.  Мужчины
exec CreateMultiEvents 180393,@Now, 10,@StartEventId, 4458,0--Настольный теннис ITTF World Tour. Russian Open. Женщины
exec CreateMultiEvents 167016,@Now, 10,@StartEventId, 153044,0--Бадминтон US Open. Микст
--Live
exec CreateMultiEvents 663566,@Now, 3,@StartEventId, 51190, 1 -- Бадминтон All England Open. Женщины
exec CreateMultiEvents 435746,@Now, 3,@StartEventId, 12769, 1 -- Баскетбол США. NBA. All-Star Weekend
exec CreateMultiEvents 60554,@Now, 3,@StartEventId, 11261, 1 -- Футбол Лига Европы УЕФА. 1-й отборочный раунд
exec CreateMultiEvents 135992,@Now, 2,@StartEventId, 11262, 1--Хоккей Международный турнир. Санкт-Петербург
exec CreateMultiEvents 482091,@Now, 5,@StartEventId, 11745, 1--Теннис Кубок ATP
exec CreateMultiEvents 279457,@Now, 10,@StartEventId, 43072, 1--Настольный теннис TT Cup. Женщины
exec CreateMultiEvents 371730,@Now, 10,@StartEventId, 367258, 1--AI Games DOTA 2 - Shadow Fiend Duel
go

UPDATE Events
SET PlayerId1 = EM.LineMemberId
FROM Events
INNER JOIN 
(
SELECT ROW_NUMBER() OVER (PARTITION BY LineID ORDER BY EventMemberId)  AS PlayedId, LineID, LineMemberId FROM EventMembers
) EM ON EVENTS.LineID = EM.LineID
WHERE EM.PlayedId = 1 AND PlayerId1 is NULL
GO
UPDATE Events
SET PlayerId2 = EM.LineMemberId
FROM Events
INNER JOIN 
(
SELECT ROW_NUMBER() OVER (PARTITION BY EventMembers.LineID ORDER BY EventMembers.EventMemberId)  AS PlayedId, EventMembers.LineID, EventMembers.LineMemberId FROM EventMembers
INNER JOIN EVENTS ON EVENTS.LineID = EventMembers.LineID
INNER JOIN EventTypes ON Events.EventTypeId = EventTypes.EventTypeId
WHERE EventTypes.EventTypeMemberNumber>1
) EM ON EVENTS.LineID = EM.LineID
WHERE EM.PlayedId = 2 AND PlayerId2 is NULL
GO
