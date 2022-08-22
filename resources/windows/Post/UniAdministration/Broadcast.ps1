<#
Task DEVOPS-152 https://jira.baltbet.ru:8443/browse/DEVOPS-152
Настройки для WEBAPI при деплое
Админка:
Необходимо что-бы после деплоя были активны
Трансляции --> доступность трансляций для WebApi --> должен быть активен чек бокс "Трансляция разрешена" в списке должна быть проставлена Трансляция Club
Трансляции --> доступность трансляций для WebApi --> должен быть активен чек бокс "Трансляция разрешена" в списке должна быть проставлена Трансляция Start
Трансляции --> доступность везуализаций для WebApi --> должен быть активен чек бокс "Визуализация разрешена" в списке должна быть проставлена Визуализация BaltBet
#>

$dbname = "UniAdministration"
$query = "
USE UniAdministration

INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (1, 'BroadcastSettings.Broadcasts[5].IsEnabled', 'true', 0)
INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (1, 'BroadcastSettings.Broadcasts[5].Type', 'Club', 0)
INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (1, 'BroadcastSettings.Broadcasts[6].IsEnabled', 'true', 0)
INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (1, 'BroadcastSettings.Broadcasts[6].Type', 'Start', 0)
INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (1, 'BroadcastSettings.Visualizations[0].IsEnabled', 'true', 0)
INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (1, 'BroadcastSettings.Visualizations[0].Type', 'BaltBet', 0)
GO
"

Write-Host "[INFO] Add 'BroadcastSettings.*' settings"
Invoke-Sqlcmd -QueryTimeout 360 -verbose -ServerInstance $env:COMPUTERNAME -Database $dbname -query $query -ErrorAction stop