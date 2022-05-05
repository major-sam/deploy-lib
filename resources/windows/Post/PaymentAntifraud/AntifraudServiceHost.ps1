# Payment.Antifraud.ServiceHost
Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "Service"
$serviceBin = Get-Item  "C:\Services\Payments\Antifraud\${ServiceName}\BaltBet.Payment.Antifraud.ServiceHost.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
