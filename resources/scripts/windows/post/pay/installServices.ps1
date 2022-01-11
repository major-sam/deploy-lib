import-module '.\scripts\sideFunctions.psm1'
$serviceBin = Get-Item  "C:\Services\Payments\PaymentBalanceReport\Baltbet.Payment.BalanceReport.exe"
$sname = RegisterWinService($serviceBin)
start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME

$serviceBin = Get-Item  "C:\Services\Payments\PaymentBalancing\BaltBet.Payment.BalancingService\BaltBet.Payment.BalancingService.exe"
$sname = RegisterWinService($serviceBin)
start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
