
use BaltBetM
SET QUOTED_IDENTIFIER ON
go
---КОПИРОВАНИЕ СПРАВОЧНЫХ ДАННЫХ---
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
exec sp_msforeachtable "ALTER TABLE ? DISABLE TRIGGER  all"
go
--Очистка событий--

PRINT 'start query'
PRINT 'delete eventbind'
delete from eventbind
go
PRINT 'delete coefs'
delete from coefs where LineID <>1
go
PRINT 'delete EventMembers'
delete from EventMembers where LineID <>1
go
PRINT 'delete EventGroupMembers'
DELETE FROM EventGroupMembers 
go
PRINT 'delete EventGroups'
DELETE FROM EventGroups
go
PRINT 'delete events'
delete from events where LineID <>1
go
--Окончание очистки событий--
PRINT 'delete EventTCoefTBind'
delete from EventTCoefTBind
go
PRINT 'delete LineMemberBind'
delete from LineMemberBind
go
PRINT 'delete EventResults'
DELETE FROM EventResults
go
PRINT 'delete coeftypes'
delete from coeftypes
go
PRINT 'delete LineMembers'
delete from LineMembers
go
PRINT 'delete Federations'
delete from Federations
go
PRINT 'delete EventTypes'
delete from EventTypes
go
PRINT 'delete market'
delete from market
go
set IDENTITY_INSERT MARKEt ON
PRINT 'insert into Market'
insert into Market(ID, Name, IsMain, EventTypeID, SuperMarketID, SortOrder, BindDate, UserBindID, FactTypeKindId,MarketKindId,MarketMergeTypeId)
select ID, Name, IsMain, EventTypeID, SuperMarketID, SortOrder, BindDate, UserBindID, FactTypeKindId,MarketKindId,MarketMergeTypeId 
from [srvapkbb3.gkbaltbet.local].BaltBetM.dbo.Market
set IDENTITY_INSERT MARKEt OFF
go
PRINT 'insert into Market done'
PRINT 'insert into LineMemberBind'
insert into LineMemberBind
select [LineMemberBindId]
      ,[LineMemberBindTypeId]
      ,[LineMemberId1]
      ,[LineMemberId2]
      ,[LineMemberBindVisible]
      ,[DateCreate]	  
	from [srvapkbb3.gkbaltbet.local].BaltBetM.dbo.LineMemberBind
PRINT 'insert into LineMemberBind done'
GO
PRINT 'insert into EventTCoefTBind'
insert into EventTCoefTBind
select [EventTypesCoefTypesBindId]
      ,[CoefTypeID]
      ,[EventTypeId]
      ,[CoefTypeMain]
      ,[CoefTypeCount]
      ,[CoefTypeRepeatCount]
      ,[MinValue]
      ,[MaxValue]
      ,[MarketID]
      ,[SortOrder]
      ,[DefaultValue]
      ,[DefaultAddit]
      ,[TextVisible]
      ,[Visibility]
      ,[AutoCalculated]
      ,[DateCreate]
	  from [srvapkbb3.gkbaltbet.local].BaltBetM.dbo.EventTCoefTBind
PRINT 'insert into EventTCoefTBind done'
go
PRINT 'insert into CoefTypes'
insert into CoefTypes([CoefTypeID]
      ,[CoefTypeName]
      ,[CoefAdditType]
      ,[CoefTypeDefaultValue]
      ,[CoefTypeDefaultAddit]
      ,[CoefSeparateLine]
      ,[CoefForceTable]
      ,[MainCoefTypeId]
      ,[CoefResultVisible]
      ,[CoefLevel]
      ,[ReverseCoefTypeId]
      ,[CoefMemberNodeId]
      ,[ReverseDifferentSign]
      ,[ShortName]
      ,[GroupID]
      ,[IsMain]
      ,[OutComeKindId]
      ,[ValueFormat]
      ,[CoefKindId]
      ,[ParamKindTokenId]
      ,[CoefValueTypeId]
      ,[NameTemplates]
      ,[CoefTypeAnalogId]
      ,[DateCreate])
select [CoefTypeID]
      ,[CoefTypeName]
      ,[CoefAdditType]
      ,[CoefTypeDefaultValue]
      ,[CoefTypeDefaultAddit]
      ,[CoefSeparateLine]
      ,[CoefForceTable]
      ,[MainCoefTypeId]
      ,[CoefResultVisible]
      ,[CoefLevel]
      ,[ReverseCoefTypeId]
      ,[CoefMemberNodeId]
      ,[ReverseDifferentSign]
      ,[ShortName]
      ,[GroupID]
      ,[IsMain]
      ,[OutComeKindId]
      ,[ValueFormat]
      ,[CoefKindId]
      ,[ParamKindTokenId]
      ,[CoefValueTypeId]
      ,[NameTemplates]
      ,[CoefTypeAnalogId]
      ,[DateCreate]
	   from [srvapkbb3.gkbaltbet.local].BaltBetM.dbo.CoefTypes
PRINT 'insert into CoefTypes done'
go
PRINT 'insert into LineMembers'
INSERT INTO LineMembers([LineMemberId]
      ,[LineMemberTypeId]
      ,[LineMemberText]
      ,[LineMemberValid]
      ,[LineMemberEventTypeId]
      ,[LineMemberMinBetLimit]
      ,[LineMemberMaxBetLimit]
      ,[LineMemberMaxBetAddLimit]
      ,[LineMemberMembersGroupId]
      ,[LineMemberCommentMemberId]
      ,[SportTypeID]
      ,[TopOrder]
      ,[SuspiciousState]
      ,[FederationID]
      ,[TopMemberId]
      ,[PhaseKindId]
      ,[PhaseValueFrom]
      ,[PhaseValueTo]
      ,[CommentMemberId]
      ,[InfoMemberId]
      ,[IsCountdownEnabled]
      ,[Settings]
      ,[TranslateID]
      ,[ClientShow]
      ,[CommentMember]
      ,[InfoMember]
      ,[CountryId]
      ,[MaxExpressCount]
      ,[SortOrder]
      ,[DateCreate])
SELECT  [LineMemberId]
      ,[LineMemberTypeId]
      ,[LineMemberText]
      ,[LineMemberValid]
      ,[LineMemberEventTypeId]
      ,[LineMemberMinBetLimit]
      ,[LineMemberMaxBetLimit]
      ,[LineMemberMaxBetAddLimit]
      ,[LineMemberMembersGroupId]
      ,[LineMemberCommentMemberId]
      ,[SportTypeID]
      ,[TopOrder]
      ,[SuspiciousState]
      ,[FederationID]
      ,[TopMemberId]
      ,[PhaseKindId]
      ,[PhaseValueFrom]
      ,[PhaseValueTo]
      ,[CommentMemberId]
      ,[InfoMemberId]
      ,[IsCountdownEnabled]
      ,[Settings]
      ,[TranslateID]
      ,[ClientShow]
      ,[CommentMember]
      ,[InfoMember]
      ,[CountryId]
      ,[MaxExpressCount]
      ,[SortOrder]
      ,[DateCreate] 
	  from [srvapkbb3.gkbaltbet.local].BaltBetM.dbo.LineMembers

PRINT 'insert into LineMembers done'
go
set IDENTITY_INSERT Federations ON
PRINT 'insert into Federations'
insert into Federations(ID,Name)
select ID, Name from [srvapkbb3.gkbaltbet.local].BaltBetM.dbo.Federations
set IDENTITY_INSERT Federations OFF
PRINT 'insert into Federations done'
go
PRINT 'insert into EventTypes'
insert into EventTypes( [EventTypeId]
      ,[EventTypeText]
      ,[EventTypeMemberNumber]
      ,[EventTypeClientShow]
      ,[EventTypeActive]
      ,[MatchParts]
      ,[PartTime]
      ,[Visibility]
      ,[DateCreate])
select [EventTypeId]
      ,[EventTypeText]
      ,[EventTypeMemberNumber]
      ,[EventTypeClientShow]
      ,[EventTypeActive]
      ,[MatchParts]
      ,[PartTime]
      ,[Visibility]
      ,[DateCreate]
	   from [srvapkbb3.gkbaltbet.local].BaltBetM.dbo.EventTypes
PRINT 'insert into EventTypes done'
go
---КОНЕЦ КОПИРОВАНИЯ СПРАВОЧНЫХ ДАННЫХ---

---Копирование событий---
PRINT 'insert into Events'
insert into dbo.Events ([LineID],
	[LineMemberId],
	[WorkerId],
	[EventCreationTime],
	[EventStartTime],
	[EventActive],
	[EventFinished],
	[EventResultText],
	[MaxBetLimit],
	[MinBetLimit],
	[MaxBetAddLimit],
	[EventComment],
	[MinExpressCount],
	[MaxExpressCount],
	[ResultComment],
	[TopEvent],
	[EventScore],
	[EventPosition],
	[EventTV],
	[EventSource],
	[CommentMemberId],
	[ResultCommentMemberId],
	[InfoMemberId],
	[Live],
	[EventTypeGroupID],
	[EventName],
	[MarketGroupID],
	[ClientShow],
	[EventGroupId],
	[CommentVisibility],
	[InfoVisibility],
	[PlaceMemeberId],
	[StageMemeberId],
	[ResultFirstMemeberId],
	[FormatMemeberId],
	[ResultBatchMemeberId],
	[AdditionalTermsMemeberId],
	[LongLifeCoefs],
	[AcceptAllBets],
	[TranslateId],
	[BetStartDate],
	[BetEndDate],
	[IsBetFinished],
	[EventTypeID])
select [LineID],
	[LineMemberId],
	[WorkerId],
	[EventCreationTime],
	[EventStartTime],
	[EventActive],
	[EventFinished],
	[EventResultText],
	[MaxBetLimit],
	[MinBetLimit],
	[MaxBetAddLimit],
	[EventComment],
	[MinExpressCount],
	[MaxExpressCount],
	[ResultComment],
	[TopEvent],
	[EventScore],
	[EventPosition],
	[EventTV],
	[EventSource],
	[CommentMemberId],
	[ResultCommentMemberId],
	[InfoMemberId],
	[Live],
	[EventTypeGroupID],
	[EventName],
	[MarketGroupID],
	[ClientShow],
	[EventGroupId],
	[CommentVisibility],
	[InfoVisibility],
	[PlaceMemeberId],
	[StageMemeberId],
	[ResultFirstMemeberId],
	[FormatMemeberId],
	[ResultBatchMemeberId],
	[AdditionalTermsMemeberId],
	[LongLifeCoefs],
	[AcceptAllBets],
	[TranslateId],
	[BetStartDate],
	[BetEndDate],
	[IsBetFinished],
	[EventTypeID] 
from [srvapkbb3.gkbaltbet.local].BaltBetM.dbo.Events ct 
where ct.EventStartTime>=getdate() and ct.Live=0
PRINT 'insert into Events done'
go
PRINT 'insert into EventMembers'
insert into EventMembers
select ct.[EventMemberId]
      ,ct.[LineMemberId]
      ,ct.[LineID]
      ,ct.[DateCreate]
       from [srvapkbb3.gkbaltbet.local].BaltBetM.dbo.EventMembers ct
INNER JOIN [srvapkbb3.gkbaltbet.local].BaltBetM.dbo.Events ev on ct.LineID = ev.LineID
where ev.EVENTSTARTTIME > GETDATE() AND ev.Live = 0
PRINT 'insert into EventMembers done'
go
PRINT 'delete eventmembers'
delete eventmembers  from eventmembers  left outer join events on events.lineid = eventmembers.lineid where events.lineid is null
go


GO
exec sp_MSforeachtable @command1="print '?'", @command2="ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
go
sp_msforeachtable @command1="print '?'", @command2="ALTER TABLE ? ENABLE TRIGGER  all"
go