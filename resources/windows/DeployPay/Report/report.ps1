import-module '.\scripts\sideFunctions.psm1'
##### edit imorter json files
## mayby to env
$logPath = "C:\Logs\Payments\BaltBet.Payment.BalanceReport-.txt"
$apiAddr =  (Get-NetIPAddress -AddressFamily IPv4 | ?{$_.InterfaceIndex -ne 1}).IPAddress.trim()
$apiPort = '50009'
$apiPortBS = '50005'
$pathtojson = "C:\Services\Payments\PaymentBalanceReport\appsettings.json"
$jsonDepth = 6
$defaultDomain = "bb-webapps.com"

Write-Host -ForegroundColor Green "[info] edit json files"
$configFile = Get-Content -Encoding UTF8 $pathtojson  -Raw 
## Json comment imporvement

$json_appsetings = $configFile -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/'| ConvertFrom-Json

$json_appsetings.Kestrel.Endpoints.Https.Url = "https://$($env:COMPUTERNAME).$($defaultDomain):$($apiPort)"
$json_appsetings.Kestrel.Endpoints.Https.Certificate.Location = "LocalMachine"
$json_appsetings.Kestrel.Endpoints.Https.Certificate.Subject = "*.bb-webapps.com"
$json_appsetings.BalancingServiceOptions.BaseAddress = "http://$($apiAddr):$($apiPortBS)"
$json_appsetings.KernelOptions.KernelApiBaseAddress = "http://$($apiAddr):8081"
$json_appsetings.Serilog.WriteTo | % {
	if ($_.name -like "file") {
		$_.Args.path = $logPath
	}
}

New-Item -path "C:\Services\Payments\PaymentBalanceReport\BalanceReports" -Type Directory
$BalanceReportDir = 'C:\Services\Payments\PaymentBalanceReport\BalanceReports'
$json_appsetings.BalanceReportOptions.Cron = "1 1 12 * * ?"
$json_appsetings.BalanceReportOptions.ReportDir = $BalanceReportDir
#New-SmbShare -Name "Balance Reports" -Path $BalanceReportDir
$json_appsetings.BalancingServiceOptions  | Add-Member -Force -MemberType NoteProperty  -Name ZoneId -Value 1
$json_appsetings.BalancingServiceOptions  | Add-Member -Force -MemberType NoteProperty  -Name Timeout -Value "00:00:30" 
$json_appsetings.KernelOptions  | Add-Member -Force -MemberType NoteProperty  -Name Timeout -Value "00:00:30"

$json_appsetings.AggregatorOptions.Aggregators[0].GrpcServiceAddress = "https://172.16.1.70:32420;http://172.16.1.70:32421"

ConvertTo-Json $json_appsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth $jsonDepth"
