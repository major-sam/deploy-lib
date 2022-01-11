Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "SuperExpressService"
$serviceBin = Get-Item  "C:\Services\${ServiceName}\BaltBet.SuperExpress.Service.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
