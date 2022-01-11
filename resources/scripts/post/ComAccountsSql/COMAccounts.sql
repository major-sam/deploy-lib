-- Установить для всех СОМ аккунтов свойство 116 для доступа на сайт СОМ

DECLARE @MyUrl nvarchar(1024); 
-- copy your vm url without port and https:// (like wrote in the example ).
SET @MyUrl = '#VM_URL.bb-webapps.com';


set IDENTITY_INSERT [BaltBetDomain].[dbo].[ParentDomains] ON
insert into [BaltBetDomain].[dbo].[ParentDomains] (Id , Name, Address, IsActive, ActivationDate, State)
  VALUES (1, NULL, @MyUrl, 'True' , GETDATE(), 10)
set IDENTITY_INSERT [BaltBetDomain].[dbo].[ParentDomains] OFF

DECLARE @LastAccountGroupID INT;
select @LastAccountGroupID =  MAX(AccountGroupId) FROM [BaltBetM].[dbo].[AccountGroups];
insert into [BaltBetM].[dbo].[AccountGroups] (AccountGroupId, AccountGroupName,AccountGroupDescription , Weight, DateCreate)
 VALUES (@LastAccountGroupID +1 , 'COM домен', NULL, NULL,GETDATE());

DECLARE @LastAccountGroupPropertyID INT;
select @LastAccountGroupPropertyID =  MAX(AccountGroupPropertyID) FROM [BaltBetM].[dbo].[AccountGroupProperties];
INSERT INTO [BaltBetM].[dbo].[AccountGroupProperties] (AccountGroupPropertyId, AccountGroupId, AccountPropertyTypeId, PropertyValue, PropertyValueEx, DateCreate) 
  VALUES (@LastAccountGroupPropertyID+1, @LastAccountGroupID +1, 116, 0, '#VM_URL.bb-webapps.com', GETDATE());

INSERT INTO [BaltBetM].[dbo].[AccountAccountGroups] 
select 
  ROW_NUMBER() OVER(ORDER BY AccountId ASC) AS N, 
  AccountId, 
  @LastAccountGroupID+1, 
  GETDATE() 
from [BaltBetM].[dbo].Accounts 
where PlayerType = 1