import-module '.\scripts\sidefunctions.psm1'
$doNotStart = @(
"Baltbet.TradingTool.Scraping.Bet365",
"Baltbet.TradingTool.Scraping.Betspan",
"Baltbet.TradingTool.Scraping.Marathonbet",
"Baltbet.TradingTool.Scraping.PinnacleApiDataReader",
"Baltbet.TradingTool.Scraping.Sbobet",
"Baltbet.TradingTool.Scraping.Surebet",
"Baltbet.TradingTool.Scraping.Emulator",
"Baltbet.TradingTool.Scraping.AllbestbetsApi",
)
Get-ChildItem C:/Services/TradingTool -Exclude "tools","client"| Get-childitem -recurse -depth 1 -filter "*.exe" |? {
	$_.fullname -notlike "*Baltbet.TradingTool.Api*" -and $_.fullname  -notlike "*chromedriver*"
	}| %{
		$sname = registerwinservice($_)
		if ($sname -in $doNotStart){
			write-out "$sname autostart disabled. Use manual startuo"
		}
		else{
			start-service $sname
			Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
		}
	}
