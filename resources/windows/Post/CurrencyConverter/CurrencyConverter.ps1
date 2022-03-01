Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "CurrencyConverter"
$serviceBin = Get-Item  "C:\Services\${ServiceName}\CurrencyConverter.Service.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
