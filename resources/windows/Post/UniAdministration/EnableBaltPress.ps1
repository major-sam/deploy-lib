# Task DEVOPS-145
# https://jira.baltbet.ru:8443/browse/DEVOPS-145
# Включает отображения страницы "БАЛТПРЕСС" на UniRu
# На БД BaltBetM выполняется первый скрипт AddExpressCoupons.ps1

$dbname = "UniAdministration"
$query = "
USE UniAdministration

INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (2, 'Global.CampaignServiceSettings.IsEnabled', 'true', 0)
INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (2, 'Global.CampaignServiceSettings.BaltPressSettings.Start', '2022-08-04', 0)
INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (2, 'Global.CampaignServiceSettings.BaltPressSettings.End', '2022-12-31', 0)
INSERT INTO [UniAdministration].[Settings].[SiteOptions] VALUES (2, 'Global.CampaignServiceSettings.BaltPressSettings.IntervalPollingSeconds', 4, 0)
GO
"

Write-Host "[INFO] Enable Global.CampaignServiceSettings.BaltPressSettings"
Invoke-Sqlcmd -QueryTimeout 360 -verbose -ServerInstance $env:COMPUTERNAME -Database $dbname -query $query -ErrorAction stop