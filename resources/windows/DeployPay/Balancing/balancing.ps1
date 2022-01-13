import-module '.\scripts\sideFunctions.psm1'
##### edit imorter json files
## mayby to env
$logPath = "C:\Logs\Payments\BaltBet.Payment.BalancingService-.txt"
$apiAddr =  (Get-NetIPAddress -AddressFamily IPv4 | ?{$_.InterfaceIndex -ne 1}).IPAddress.trim()
$apiPort = '50001'
$pathtojson = 'C:\Services\Payments\PaymentBalancing\BaltBet.Payment.BalancingService\appsettings.json'
$jsonDepth = 4

Write-Host -ForegroundColor Green "[info] edit json files"
$configFile = Get-Content $pathtojson  -Raw
## Json comment imporvement

$json_appsetings = $configFile -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/'| ConvertFrom-Json

$json_appsetings.Kestrel.Endpoints.PSObject.Properties.Remove('Https')
$json_appsetings.Kestrel.Endpoints | Add-Member -Force -NotePropertyMembers @{ Http= @{ Url = "http://$($apiAddr):$($apiPort)" }} 
$json_appsetings.Kestrel.Endpoints.Http.Url = "http://$($apiAddr):$($apiPort)"
$json_appsetings.Kernel.KernelApiBaseAddress = "http://$($apiAddr):8081"
($json_appsetings.Serilog.WriteTo|%{
	 if($_.name -like "file"){
		 $_.Args.path = $logPath
	  }
})
$json_appsetings.ConnectionStrings.BalancingDb = "data source=localhost;initial catalog=BalancingDb;integrated security=True;MultipleActiveResultSets=True;"
$json_appsetings.Swagger.Enabled = $false
ConvertTo-Json $json_appsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth $jsonDepth"

$pathtojson = 'C:\Services\Payments\PaymentBalancing\BaltBet.Payment.BalancingService.Blazor\appsettings.json'
$logPath = "C:\Logs\Payments\BaltBet.Payment.BalancingService.Blazor-.txt"
$jsonDepth = 4
Write-Host -ForegroundColor Green "[info] edit json files"
$configFile = Get-Content $pathtojson  -Raw
## Json comment imporvement

$json_appsetings = $configFile -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/'| ConvertFrom-Json
$json_appsetings.PSObject.Properties.Remove('Kestrel')
$json_appsetings.Balancing.Address = "http://$($apiAddr):$($apiPort)"
($json_appsetings.Serilog.WriteTo|%{
	 if($_.name -like "file"){
		 $_.Args.path = $logPath
	  }
})
ConvertTo-Json $json_appsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth $jsonDepth"
