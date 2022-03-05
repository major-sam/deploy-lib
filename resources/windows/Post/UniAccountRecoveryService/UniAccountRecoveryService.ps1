# UniAccountRecoveryService
Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "UniAccountRecoveryService"
$serviceBin = Get-Item  "C:\Services\${ServiceName}\Uni.AccountRecoveryService.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
