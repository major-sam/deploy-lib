Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "AccountStatisticsService"
$serviceBin = Get-Item  "C:\Services\${ServiceName}\BaltBet.AccountStatisticsService.GrpcHost\BaltBet.AccountStatisticsService.GrpcHost.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
