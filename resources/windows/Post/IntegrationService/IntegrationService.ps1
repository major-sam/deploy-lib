# ARCHI-378
# https://jira.baltbet.ru:8443/browse/ARCHI-378

Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "IntegrationService"
$serviceBin = Get-Item  "C:\Services\${ServiceName}\IntegrationService.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME