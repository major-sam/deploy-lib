Import-module '.\scripts\sideFunctions.psm1'

#Вносим настройки в админке Uni.Ru
$query_insert_ECupisBaseUrl = "
INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
VALUES (1,'PlayerIdentificationSettings.ECupisBaseUrl','https://localhost:4453',0)
GO
"

Write-Host -ForegroundColor Green "[INFO] Insert PlayerIdentificationSettings.ECupisBaseUrl to DB UniRu"
Invoke-Sqlcmd -QueryTimeout 360 -verbose -ServerInstance $env:COMPUTERNAME -Database "UniRu" -query $query_insert_ECupisBaseUrl -ErrorAction continue


#Добавляем очередь в RabbitMQ
Write-Host -ForegroundColor Green "[INFO] Create queue Cupis.Payout.ExecuteQueue"
curl.exe -i -u guest:guest -H "content-type:application/json" -X PUT http://localhost:15672/api/queues/%2f/Cupis.Payout.ExecuteQueue -d"{'auto_delete':false,'durable':true,'arguments':{}}"

# Регистрируем сервис
$serviceBin = Get-Item "C:\Services\CupisIntegrationService\BaltBet.CupisIntegrationService.GrpcHost\BaltBet.CupisIntegrationService.GrpcHost.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME