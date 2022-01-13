Import-module '.\scripts\sideFunctions.psm1'

# Регистрируем сервис
$ServiceName = "CashBookService"
$serviceBin = Get-Item  "C:\Services\${ServiceName}\CashBook.Service.exe"
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
