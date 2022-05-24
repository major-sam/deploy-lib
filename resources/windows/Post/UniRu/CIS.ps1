Import-module '.\scripts\sideFunctions.psm1'

#Вносим настройки в админке Uni.Ru
$query_insert_ECupisBaseUrl = "
INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
VALUES (1,'PlayerIdentificationSettings.ECupisBaseUrl','https://localhost:4453',0)
GO
"

Write-Host -ForegroundColor Green "[INFO] Insert PlayerIdentificationSettings.ECupisBaseUrl to DB UniRu"
Invoke-Sqlcmd -QueryTimeout 360 -verbose -ServerInstance $env:COMPUTERNAME -Database "UniRu" -query $query_insert_ECupisBaseUrl -ErrorAction continue

