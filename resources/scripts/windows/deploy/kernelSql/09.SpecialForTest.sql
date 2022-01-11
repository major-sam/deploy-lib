USE BaltBetM
GO
SET QUOTED_IDENTIFIER ON
-- Активация клиента aloza 
GO
UPDATE [BaltBetM].[dbo].[Workers] SET EndDate = NULL WHERE WorkerLogin = 'aloza'
UPDATE [BaltBetM].[dbo].[Workers] SET WorkerDeleted = 0 WHERE WorkerLogin = 'aloza'
go
-- Изменение аккаунта с добавлением кошелька С.Буланой  (в скоре надо будет убрать)
Update [BaltBetM].[cps].[CpsAccountLogins] SET WalletId = 'WL-10200000000000060329', Phone = '+79112492620' where Phone = '+79818553797'
UPDATE [BaltBetM].[dbo].[Accounts] SET AccountLogin = '+79112492620', AccountPhone = '+79112492620' where AccountPhone  = '+79818553797'
UPDATE [BaltBetM].[dbo].[Accounts] SET IdentificationType = 30 where AccountPhone  = '+79112492620'
go
update [BaltBetM].[dbo].[Accounts] set IdentificationType = 30 where PlayerType = 2
update [BaltBetM].[dbo].[Accounts] set AccountBalanceValue = 9000000, accountbonusvalue = 9000000 where accountid >= 1

-- Изменение аккаунта с добавлением ПолИД аккакнта, который есть в тестовом еЦУПИС

UPDATE [BaltBetM].[dbo].[Accounts] SET AccountLogin = '+79117775596', AccountPhone = '+79117775596', AccountUid = 'AA559A4B-CE8B-492C-90D8-635570E7EFCA', IdentificationType = 30 where AccountPhone  = '+79818553800'

ALTER TABLE [BaltBetM].[cps].[CpsAccountLogins] NOCHECK CONSTRAINT [FK_cps.CpsAccountLogin_cps.CpsAccount_CpsAccountId]
UPDATE [BaltBetM].[cps].[CpsAccountLogins] SET Phone = '+79117775596', CpsAccountId  = 'AA559A4B-CE8B-492C-90D8-635570E7EFCA' where Phone  = '+79818553800'
ALTER TABLE [BaltBetM].[cps].[CpsAccountLogins] CHECK CONSTRAINT [FK_cps.CpsAccountLogin_cps.CpsAccount_CpsAccountId]


ALTER TABLE [BaltBetM].[cps].[CpsPersonalData] NOCHECK CONSTRAINT [FK_cps.CpsPersonalData_cps.CpsAccount_CpsAccountId]
UPDATE [BaltBetM].[cps].[CpsPersonalData] SET CpsAccountId  = 'AA559A4B-CE8B-492C-90D8-635570E7EFCA' where CpsAccountId in (select id from  [BaltBetM].[cps].[CpsAccounts] cps
join [BaltBetM].[dbo].[Accounts] ac on cps.Email=ac.AccountEmail where ac.AccountPhone='+79117775596')
ALTER TABLE [BaltBetM].[cps].[CpsPersonalData] NOCHECK CONSTRAINT [FK_cps.CpsPersonalData_cps.CpsAccount_CpsAccountId]


UPDATE [BaltBetM].[cps].[CpsAccounts] SET Id  = 'AA559A4B-CE8B-492C-90D8-635570E7EFCA' where Id in (select id from  [BaltBetM].[cps].[CpsAccounts] cps
join [BaltBetM].[dbo].[Accounts] ac on cps.Email=ac.AccountEmail where ac.AccountPhone='+79117775596')

-- Изменение аккаунта с добавлением УпрИД аккакнта, который есть в тестовом еЦУПИС


UPDATE [BaltBetM].[dbo].[Accounts] SET AccountLogin = '+79228888888', AccountPhone = '+79228888888', AccountUid = 'B5B25D53-CF1A-4570-A016-E69A3491B5D3', IdentificationType = 20 where AccountPhone  = '+79818553803'

ALTER TABLE [BaltBetM].[cps].[CpsAccountLogins] NOCHECK CONSTRAINT [FK_cps.CpsAccountLogin_cps.CpsAccount_CpsAccountId]
UPDATE [BaltBetM].[cps].[CpsAccountLogins] SET Phone = '+79228888888', CpsAccountId  = 'B5B25D53-CF1A-4570-A016-E69A3491B5D3' where Phone  = '+79818553803'
ALTER TABLE [BaltBetM].[cps].[CpsAccountLogins] CHECK CONSTRAINT [FK_cps.CpsAccountLogin_cps.CpsAccount_CpsAccountId]


ALTER TABLE [BaltBetM].[cps].[CpsPersonalData] NOCHECK CONSTRAINT [FK_cps.CpsPersonalData_cps.CpsAccount_CpsAccountId]
UPDATE [BaltBetM].[cps].[CpsPersonalData] SET CpsAccountId  = 'B5B25D53-CF1A-4570-A016-E69A3491B5D3' where CpsAccountId in (select id from  [BaltBetM].[cps].[CpsAccounts] cps
join [BaltBetM].[dbo].[Accounts] ac on cps.Email=ac.AccountEmail where ac.AccountPhone='+79228888888')
ALTER TABLE [BaltBetM].[cps].[CpsPersonalData] NOCHECK CONSTRAINT [FK_cps.CpsPersonalData_cps.CpsAccount_CpsAccountId]


UPDATE [BaltBetM].[cps].[CpsAccounts] SET Id  = 'B5B25D53-CF1A-4570-A016-E69A3491B5D3' where Id in (select id from  [BaltBetM].[cps].[CpsAccounts] cps
join [BaltBetM].[dbo].[Accounts] ac on cps.Email=ac.AccountEmail where ac.AccountPhone='+79228888888')

-- Fix [UniRu].[Accounts].[AccountPreferences] и перенесит их из BaltBetM в UniRu

update UniRu.Accounts.AccountPreferences set UniRu.Accounts.AccountPreferences.AccountUid = BaltBetM.dbo.Accounts.AccountUid
from BaltBetM.dbo.Accounts  inner join UniRu.Accounts.AccountPreferences on  BaltBetM.dbo.Accounts.AccountId = UniRu.Accounts.AccountPreferences.AccountId and BaltBetM.dbo.Accounts.PlayerType = 2



