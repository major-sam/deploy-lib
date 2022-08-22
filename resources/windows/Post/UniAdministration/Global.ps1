<#
Task DEVOPS-153 https://jira.baltbet.ru:8443/browse/DEVOPS-153
Общие --> настройка сервиса уведомлений

Должен быть активен чек бокс у следующих параметров:

- "Включить основные уведомления"
- "Включить уведомления по игрокам"
#>

$dbname = "UniAdministration"
$query = "
USE UniAdministration

INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (1, 'Global.NotificationServiceSettings.PushAccountsEnabled', 'true', 0)
GO
"

Write-Host "[INFO] Enable 'Global.NotificationServiceSettings.PushAccountsEnabled'"
Invoke-Sqlcmd -QueryTimeout 360 -verbose -ServerInstance $env:COMPUTERNAME -Database $dbname -query $query -ErrorAction stop