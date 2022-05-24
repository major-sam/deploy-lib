Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$serviceBin = Get-Item "C:\Services\CupisIntegrationService\BaltBet.CupisIntegrationService.Host\BaltBet.CupisIntegrationService.Host.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
