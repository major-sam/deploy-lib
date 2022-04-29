# Payment.Antifraud.Client
Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "Client"
$serviceBin = Get-Item  "C:\Services\Payments\Antifraud\${ServiceName}\BaltBet.Payment.Antifraud.Client.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
