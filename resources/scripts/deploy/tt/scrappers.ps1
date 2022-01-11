import-module '.\scripts\sideFunctions.psm1'
##### edit imorter json files
## mayby to env
$logPath = "C:\Logs\TradingTool\scrappers\"
$apiAddr =  (Get-NetIPAddress -AddressFamily IPv4 | ?{$_.InterfaceIndex -ne 1}).IPAddress.trim()
$apiPort = '50005'
$jsonDepth = 4
Get-ChildItem -Path "C:\Services\TradingTool\Scrapers\" -Filter 'appsettings.json' -Recurse | 
	? {$_.DirectoryName -notlike "*Emulator"} |
	% {
		Write-Output "[info] edit json files $($_.FullName)"
		Write-Output ($_.Directory.Name -notlike "Baltbet.TradingTool.Scraping.Emulator")
		$configFile = Get-Content -Path $_.FullName -Raw

## Json comment imporvement

		$json_appsetings = $configFile -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/'| ConvertFrom-Json

		$json_appsetings.ClientOptions.Url =  "http://$($apiAddr):$($apiPort)"
		$json_appsetings.Serilog.WriteTo[0].Args.path = $logPath + $_.Directory.Name + "-.log"
		ConvertTo-Json $json_appsetings -Depth $jsonDepth  | Format-Json | Set-Content -Encoding 'utf8' -path $_.FullName
		Write-Output "$($_.FullName) renewed with json depth $jsonDepth"
}
