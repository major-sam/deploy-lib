PRINT 'DROP SEQUENCE dbo.EventMembersSequence'; DROP SEQUENCE dbo.EventMembersSequence
PRINT 'DROP SEQUENCE dbo.AccountSequence'; DROP SEQUENCE dbo.AccountSequence
PRINT 'DROP SEQUENCE dbo.AccountAccountGroupsSequence'; DROP SEQUENCE dbo.AccountAccountGroupsSequence
PRINT 'DROP SEQUENCE dbo.AccountCommentsSequence'; DROP SEQUENCE dbo.AccountCommentsSequence
PRINT 'DROP SEQUENCE dbo.EventsSequence'; DROP SEQUENCE dbo.EventsSequence
PRINT 'DROP SEQUENCE dbo.AccountGroupsSequence'; DROP SEQUENCE dbo.AccountGroupsSequence
PRINT 'DROP SEQUENCE dbo.AccountLogsSequence'; DROP SEQUENCE dbo.AccountLogsSequence
PRINT 'DROP SEQUENCE dbo.ActionDestinationsSequence'; DROP SEQUENCE dbo.ActionDestinationsSequence
PRINT 'DROP SEQUENCE dbo.ActionLogsSequence'; DROP SEQUENCE dbo.ActionLogsSequence
PRINT 'DROP SEQUENCE dbo.BetEventsSequence'; DROP SEQUENCE dbo.BetEventsSequence
PRINT 'DROP SEQUENCE dbo.ClientSequence'; DROP SEQUENCE dbo.ClientSequence
PRINT 'DROP SEQUENCE dbo.CoefPropertiesSequence'; DROP SEQUENCE dbo.CoefPropertiesSequence
PRINT 'DROP SEQUENCE dbo.CoefTypesSequence'; DROP SEQUENCE dbo.CoefTypesSequence
PRINT 'DROP SEQUENCE dbo.EventCommentParametersSequence'; DROP SEQUENCE dbo.EventCommentParametersSequence
PRINT 'DROP SEQUENCE dbo.EventLogsSequence'; DROP SEQUENCE dbo.EventLogsSequence
PRINT 'DROP SEQUENCE dbo.EventResultsSequence'; DROP SEQUENCE dbo.EventResultsSequence
PRINT 'DROP SEQUENCE dbo.EventTypesSequence'; DROP SEQUENCE dbo.EventTypesSequence
PRINT 'DROP SEQUENCE dbo.ExchangeSequence'; DROP SEQUENCE dbo.ExchangeSequence
PRINT 'DROP SEQUENCE dbo.GlobalTranslateSequence'; DROP SEQUENCE dbo.GlobalTranslateSequence
PRINT 'DROP SEQUENCE dbo.LineMembersSequence'; DROP SEQUENCE dbo.LineMembersSequence
PRINT 'DROP SEQUENCE dbo.TransactionAddsSequence'; DROP SEQUENCE dbo.TransactionAddsSequence
PRINT 'DROP SEQUENCE dbo.TransactionDocumentsSequence'; DROP SEQUENCE dbo.TransactionDocumentsSequence
PRINT 'DROP SEQUENCE dbo.TransactionsSequence'; DROP SEQUENCE dbo.TransactionsSequence
PRINT 'DROP SEQUENCE dbo.WorkersSequence'; DROP SEQUENCE dbo.WorkersSequence
GO
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = AccountId from Accounts order by AccountId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[AccountSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 100
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = AccountAccountGroupId  from AccountAccountGroups order by AccountAccountGroupId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[AccountAccountGroupsSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 100
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = Id  from AccountComments order by id desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[AccountCommentsSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 1000
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
GO
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = CoefTypeId from CoefTypes order by CoefTypeId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[CoefTypesSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 10
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = DocumentId  from transactiondocuments order by DocumentId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[TransactionDocumentsSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 50
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = TransactionId  from Transactions order by TransactionId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[TransactionsSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 1000
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = TransactionAddId  from transactionadds order by TransactionAddId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[TransactionAddsSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 500
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = AccountGroupId  from AccountGroups order by AccountGroupId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[AccountGroupsSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 1
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = AccountLogId from accountlogs order by AccountLogId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[AccountLogsSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 1000
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = ActionLogId from ActionLogs order by ActionLogId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[ActionLogsSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 1000
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
GO
DECLARE @Id bigint, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = ActionDestinationId + 1 from ActionDestinations order by ActionDestinationId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[ActionDestinationsSequence]
 AS [bigint]
 START WITH ' + @TextId + '
 INCREMENT BY 10000
 MAXVALUE 9223372036854775807
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = BetEventId from BetEvents order by BetEventId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[BetEventsSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 1000
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = ClientId from Clients order by ClientId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[ClientSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 1
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = WorkerId from Workers order by WorkerId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[WorkersSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 1
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = ExchangeId from exchange order by ExchangeId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[ExchangeSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 100
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = LineID from Events order by LineID desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[EventsSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 100
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = EventMemberId from EventMembers order by EventMemberId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[EventMembersSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 200
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id bigint, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = ID from GlobalTranslate order by ID desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[GlobalTranslateSequence]
 AS [bigint]
 START WITH ' + @TextId + '
 INCREMENT BY 1000
 MAXVALUE 9223372036854775807
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = EventResultId from EventResults order by EventResultId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[EventResultsSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 500
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = EventCommentParameterId from EventCommentParameters order by EventCommentParameterId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[EventCommentParametersSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 500
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = EventTypeId from EventTypes order by EventTypeId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[EventTypesSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 1
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = CoefPropertyId from CoefProperties order by CoefPropertyId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[CoefPropertiesSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 1000
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
GO
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = EventLogId from EventLogs order by EventLogId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[EventLogsSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 1000
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
DECLARE @Id int, @TextId nvarchar(20)
DECLARE @sql varchar(1000)
SELECT top 1 @Id = LineMemberId from LineMembers order by LineMemberId desc
set @TextId = CAST(ISNULL(@Id,0)+1 as nvarchar(20))
set @sql = N'CREATE SEQUENCE [dbo].[LineMembersSequence]
 AS [int]
 START WITH ' + @TextId + '
 INCREMENT BY 100
 MAXVALUE 2147483647
 CACHE'
  EXEC(@sql)
go
