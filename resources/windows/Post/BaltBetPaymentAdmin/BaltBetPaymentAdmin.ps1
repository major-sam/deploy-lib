Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "BaltBetPaymentAdmin"
$serviceBin = Get-Item  "C:\Services\${ServiceName}\BaltBet.Payment.Admin.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
