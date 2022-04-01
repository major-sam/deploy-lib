Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "NotificationGateWay"
$serviceBin = Get-Item  "C:\Services\${ServiceName}\BaltBet.NotificationProcessor.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
