import-module '.\scripts\sideFunctions.psm1'

$serviceBin = Get-Item  "c:\Services\Marketing\BaltBet.Marketing.ApkService\BaltBet.Marketing.ApkService.exe"
$sname = RegisterWinService($serviceBin)
start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
 return 0
