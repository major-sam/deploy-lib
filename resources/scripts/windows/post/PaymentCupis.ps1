import-module '.\scripts\sideFunctions.psm1'

$Service = "C:\Services\Payments\PaymentCupisService\BaltBet.PaymentCupis.Grpc.Host\BaltBet.Payment.Cupis.GrpcHost.exe"
$serviceBin = Get-Item  $Service
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME

$Service= "C:\Services\Payments\PaymentCupisService\PaymentCupis.RestApi.Host\BaltBet.Payment.Cupis.RestApiHost.exe"
$serviceBin = Get-Item  $Service
$sname = RegisterWinService($serviceBin)
Start-Service $sname
Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME

