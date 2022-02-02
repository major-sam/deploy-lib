import-module '.\scripts\sideFunctions.psm1'

$Service = "C:\Services\PromoExpressService\PromoExpressService.exe"
$serviceBin = Get-Item  $Service
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
