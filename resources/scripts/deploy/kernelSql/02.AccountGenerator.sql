USE BaltBetM
GO
SET QUOTED_IDENTIFIER ON
--GO
--DROP TABLE #TempAccounts
GO
CREATE TABLE #TempAccounts
(
Login varchar(100),
FirstName varchar(100),
MiddleName varchar(100),
LastName varchar(100),
Address varchar(100),
BirthDate datetime
)
GO
INSERT INTO #TempAccounts
	SELECT
		WorkerLogin
	   ,WorkerName
	   ,WorkerMidname
	   ,WorkerSurname
	   ,Address
	   ,WorkerDateOfBirth
	FROM workers
	WHERE RightTypeId = 80
GO
DECLARE @AccountId int
SELECT @AccountId = ISNULL(MAX(AccountId),0)+1 FROM ACCOUNTS 
DECLARE AccountCursor CURSOR
READ_ONLY
FOR SELECT
	*
FROM #TempAccounts
DECLARE @Login varchar(100)
DECLARE @FirstName varchar(100)
DECLARE @MiddleName varchar(100)
DECLARE @LastName varchar(100)
DECLARE @Address varchar(100)
DECLARE @BirthDate datetime
DECLARE @Phone varchar(100)
DECLARE @Email varchar(100)
DECLARE @PlayerType int=-1
DECLARE @DocNumber nvarchar(6)
DECLARE @DocSeries nvarchar(4)
OPEN AccountCursor

FETCH NEXT FROM AccountCursor INTO @Login, @FirstName,@MiddleName,@LastName,@Address,@BirthDate
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
	IF (@PlayerType=-1)
SET @PlayerType = 0
	else IF (@PlayerType=0)
SET @PlayerType = 1
	else IF (@PlayerType=1)
SET @PlayerType = 2
		else IF (@PlayerType=2)
SET @PlayerType = 0
SET @DocSeries = CAST(4000 + @AccountId AS NVARCHAR(4))
SET @DocNumber = CAST(123456 + @AccountId AS NVARCHAR(6))
SET @Phone = '+7' + CAST(9818553793 + @AccountId AS NVARCHAR(10))
SET @EMail = @Login + '@gmail.com'
INSERT INTO [dbo].[Accounts] ([AccountId], [AccountLogin], [AccountPassword], [AccountCreationTime], [AccountName], [AccountSurname], [AccountMidname],
[AccountPassportSet], [AccountPassportNumber], [AccountPassport], [AccountAddress], [AccountEmail], [AccountChatBlocked],
[AccountDebitBlocked], [AccountBigBetsBlocked], [AccountBetLimit], [AccountBetInform], [AccountBetsUnaccepted], [AccountBetRepeatWait],
[AccountDebitFastBlocked], [AccountActivated], [AccountBirthDate], [AccountPhone], [AccountComment], [AccountAdvert], [Nickname],
[Code], [EnableSmsValidation], [ChatPhone], [AccountCurrencyId], [AccountCountryId], [WmId], [SiteVersion], [Options], [AccountBonusValue],
[CardNumber], [WorkerId], [PlaceOfBirth], [Gender], [Notification], [Description], [PrivatePhone], [TIN], [BaseAccountId], [CardAttachmentDate],
[AddInfo], [AccountBalanceValue], [PromoId], [PlayerType], [DocumentType], [CountryOfIssue], [ClientID], [AccountUid], [BetNote],
[ResidenceAddress], [IssueDate], [AccountNameEn], [AccountSurnameEn], [AccountMidnameEn], [AccountSetID], [Resident], [ResidentValidTill],IdentificationLevel, PaymentIdentificationLevel,IdentificationType)
	VALUES (@AccountId,--[AccountId]
	@Login, --[AccountLogin]
	N'61baccc562d37cbf7fb83f29d37948ea', --[AccountPassword]
	GETDATE(), --[AccountCreationTime]
	@FirstName, --[AccountName]
	@LastName, --[AccountSurname]
	@MiddleName, --[AccountMidname]
	@DocSeries,--[AccountPassportSet]
	@DocNumber,--[AccountPassportNumber]
	N'28ОМ Центр р-на Спб', --[AccountPassport]
	N'Стойкости', --[AccountAddress]
	@Email,--[AccountEmail]
	0,--[AccountChatBlocked]
	0, --[AccountDebitBlocked]
	0, --[AccountBigBetsBlocked]
	NULL, --[AccountBetLimit]
	0, --[AccountBetInform]
	0, --[AccountBetsUnaccepted]
	0, --[AccountBetRepeatWait]
	0, --[AccountDebitFastBlocked]
	1, --[AccountActivated]
	@BirthDate, --[AccountBirthDate]
	@Phone, --[AccountPhone]
	N'', --[AccountComment]
	NULL, --[AccountAdvert]
	@Login, --[Nickname]
	N'', --[Code]
	1, --[EnableSmsValidation]
	@Phone, --[ChatPhone]
	1, --[AccountCurrencyId]
	1, --[AccountCountryId]
	N'', --[WmId]
	3, --[SiteVersion]
	1, --[Options]
	800000, --[AccountBonusValue]
	NULL,-- [CardNumber]
	NULL, --[WorkerId]
	NULL, --[PlaceOfBirth]
	1, --[Gender]
	NULL, --[Notification]
	NULL, --[Description]
	NULL, --[PrivatePhone]
	NULL, --[TIN]
	NULL, --[BaseAccountId]
	NULL, --[CardAttachmentDate]
	NULL, --[AddInfo]
	1000, --[AccountBalanceValue]
	NULL, --[PromoId]
	@PlayerType, --[PlayerType]
	1, --[DocumentType]
	1, --[CountryOfIssue]
	1,--[ClientID]
	NULL, --[AccountUid]
	NULL, --[BetNote]
	NULL, --[ResidenceAddress]
	NULL, --[IssueDate]
	NULL, --[AccountNameEn]
	NULL, --[AccountSurnameEn]
	NULL, --[AccountMidnameEn]
	@AccountId, --[AccountSetID]
	1, --[Resident]
	NULL,--[ResidentValidTill]
	1,--[IdentificationLevel]
	1, --PaymentIdentificationLevel
    30 --IdentificationType
	)

IF (@PlayerType = 1)
BEGIN
UPDATE ACCOUNTS
SET ClientID = 777
   ,SiteVersion = 4
   ,Code = NULL
FROM Accounts
WHERE AccountId = @AccountId
END
ELSE
IF (@PlayerType = 2)
BEGIN
UPDATE ACCOUNTS
SET ClientID = 7773
   ,SiteVersion = 3
   ,Code = NULL
   ,Options = 32
FROM Accounts
WHERE AccountId = @AccountId
DECLARE @AccountUid UNIQUEIDENTIFIER
SET @AccountUid = NEWID()
UPDATE Accounts
SET AccountLogin = @Phone
   ,AccountPhone = @Phone
   ,Nickname = @Phone
   ,AccountUid = @AccountUid
   ,ResidenceAddress = @Address
WHERE AccountId = @AccountId
INSERT INTO cps.CpsAccounts (Id, Email, PasswordSalt, PasswordHash, RegistrationType, AccountState, PromoCodeAttemptsCount, StateChangeDateUtc, AccountRegistrationIdentificationType)
	VALUES (@AccountUid, @Email, 0xAC9DF12A027EB8270780A00CCCF4501E, 0xC71B0B2F5EC19DDA23E646833B0CCEFFBD78ECBED0C25AB3A9CA8699FD8F451F, 1, 20, 0, GETDATE(),30)
INSERT INTO cps.CpsAccountLogins (CpsAccountId, WalletId, Phone, IsMain, IsDeactivated)
	VALUES (@AccountUid, @AccountId, @Phone, 1, 0)
INSERT INTO cps.CpsPersonalData (CpsAccountId, FirstName, LastName, Patronymic, DateOfBirth, PersonalData, DocumentType, DocumentSeries, DocumentNumber, DocumentIssuedDate, BirthPlace, Inn, Citizenship, AuthorityName, AuthorityCode, ZipCode, Region, RegionCode, City, Street, House, Building, Flat)
	VALUES (@AccountUid, @FirstName, @LastName, @MiddleName, @BirthDate, '{"ClientData":null,"CpsResponse":null}', 1, @DocNumber, @DocSeries, '2018-01-28 00:00:00.000', 'Ленинград', NULL, 'RU', '18 О/М Центрального района СПб', '784-023', '190000', 'г. Санкт-Петербург', 'RU', 'Санкт-Петербург', 'Невский пр', 18, 12, 132)
END
END

INSERT INTO BaltBetWeb.dbo.Accounts (AccountId,
AccountLogin,
AccountPassword,
AccountCreationTime,
AccountBalanceValue,
AccountName,
AccountSurname,
AccountMidname,
AccountPassportSet,
AccountPassportNumber,
AccountPassport,
AccountAddress,
AccountEmail,
AccountChatBlocked,
AccountDebitBlocked,
AccountBigBetsBlocked,
AccountBetLimit,
AccountBetInform,
AccountBetsUnaccepted,
AccountBetRepeatWait,
AccountDebitFastBlocked,
AccountActivated,
AccountBirthDate,
AccountPhone,
AccountComment,
AccountAdvert,
Nickname,
Code,
EnableSmsValidation,
ChatPhone,
AccountCurrencyId,
AccountCountryId,
WmId,
SiteVersion,
Options,
AccountBonusValue,
CardNumber,
WorkerId,
PlaceOfBirth,
Gender,
Notification,
Description,
PrivatePhone,
TIN,
BaseAccountId,
CardAttachmentDate,
AddInfo,
BetSum,
BetMode)
	SELECT
		AccountId
	   ,AccountLogin
	   ,AccountPassword
	   ,AccountCreationTime
	   ,AccountBalanceValue
	   ,AccountName
	   ,AccountSurname
	   ,AccountMidname
	   ,AccountPassportSet
	   ,AccountPassportNumber
	   ,LEFT(AccountPassport, 100)
	   ,AccountAddress
	   ,AccountEmail
	   ,AccountChatBlocked
	   ,AccountDebitBlocked
	   ,AccountBigBetsBlocked
	   ,AccountBetLimit
	   ,AccountBetInform
	   ,AccountBetsUnaccepted
	   ,AccountBetRepeatWait
	   ,AccountDebitFastBlocked
	   ,AccountActivated
	   ,AccountBirthDate
	   ,AccountPhone
	   ,''
	   ,AccountAdvert
	   ,Nickname
	   ,Code
	   ,EnableSmsValidation
	   ,ChatPhone
	   ,AccountCurrencyId
	   ,AccountCountryId
	   ,WmId
	   ,SiteVersion
	   ,Options
	   ,AccountBonusValue
	   ,CardNumber
	   ,WorkerId
	   ,PlaceOfBirth
	   ,Gender
	   ,Notification
	   ,Description
	   ,PrivatePhone
	   ,TIN
	   ,BaseAccountId
	   ,CardAttachmentDate
	   ,AddInfo
	   ,0
	   ,NULL
	FROM Accounts
	WHERE AccountId = @AccountId

SET @AccountId = @AccountId + 1
	FETCH NEXT FROM AccountCursor INTO @Login, @FirstName,@MiddleName,@LastName,@Address,@BirthDate
END
CLOSE AccountCursor
DEALLOCATE AccountCursor
GO
ALTER TABLE Accounts NOCHECK CONSTRAINT [FK_Accounts_AccountParent]
delete from AccountParents
ALTER TABLE Accounts NOCHECK CONSTRAINT [FK_Accounts_AccountParent]

set IDENTITY_INSERT AccountParents ON
INSERT INTO AccountParents(Id,FirstName,LastName,Patronymic,DateOfBirth,Phone,DocumentType,DocumentSeries,DocumentNumber,AuthorityName,DocumentIssuedDate,CreatedOn,WorkerId)
SELECT AccountId, AccountSurname, AccountName, AccountMidname, AccountBirthDate, AccountPhone, DocumentType, AccountPassportSet, AccountPassportNumber, AccountPassport, ISNULL(IssueDate,GETDATE()), GETDATE(), 1 FROM ACCOUNTS
set IDENTITY_INSERT AccountParents OFF
go
UPDATE ACCOUNTS SET AccountParentId = AccountId
GO
