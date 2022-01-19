Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "CashRegisterOperationService"
$serviceBin = Get-Item  "C:\Services\${ServiceName}\CashRegisterOperationService.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
