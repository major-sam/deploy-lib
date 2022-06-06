$q = "
-- Установить для всех СОМ аккунтов свойство 116 для доступа на сайт СОМ

DECLARE @MyUrl nvarchar(1024);
-- copy your vm url without port and https:// (like wrote in the example ).
SET @MyUrl = '$("$env:COMPUTERNAME".ToLower()).bb-webapps.com';


set IDENTITY_INSERT [BaltBetDomain].[dbo].[ParentDomains] ON
insert into [BaltBetDomain].[dbo].[ParentDomains] (Id , Name, Address, IsActive, ActivationDate, State)
  VALUES (1, NULL, @MyUrl, 'True' , GETDATE(), 10)
set IDENTITY_INSERT [BaltBetDomain].[dbo].[ParentDomains] OFF
go
UPDATE [BaltBetM].dbo.AccountGroupProperties
SET PropertyValueEx = @MyUrl
WHERE AccountPropertyTypeId like '116' and PropertyValueEx like '%#VM_URL%'
"


Write-Host -ForegroundColor Green "[INFO] Execute COMAccounts.sql on BaltBetDomain"
Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Query $query -ErrorAction continue
