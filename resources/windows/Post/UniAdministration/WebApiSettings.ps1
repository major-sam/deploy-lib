<#
Task DEVOPS-151 https://jira.baltbet.ru:8443/browse/DEVOPS-151
Настройки для WEBAPI при деплое
Должен быть активен чек бокс у следующих параметров:

- "Включить заглушку по регистрации и идентификации для WebApi"
- "Включить нативную регистрацию в МП"
- "Включить нативные платежи android"
- "Включить сообщения ЛИЦ"
- "Включить купоны в корзине"
#>

$dbname = "UniAdministration"
$query = "
USE UniAdministration

INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (1, 'WebApi.NativeRegistrationEnabled', 'true', 0)
INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (1, 'WebApi.NativePaymentsPageAndroidEnabled', 'true', 0)
INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (1, 'WebApi.MessagesEnabled', 'true', 0)
INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (1, 'WebApi.EnableCouponsInBettingCart', 'true', 0)
GO
"

Write-Host "[INFO] Insert 'WebApi.*' settings"
Invoke-Sqlcmd -QueryTimeout 360 -verbose -ServerInstance $env:COMPUTERNAME -Database $dbname -query $query -ErrorAction stop