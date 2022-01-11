import-module '.\scripts\sidefunctions.psm1'

Get-ChildItem C:/Services/TradingTool -Exclude "tools","client"| Get-childitem -recurse -depth 1 -filter "*.exe" |? {
	$_.fullname -notlike "*Baltbet.TradingTool.Api*" -and $_.fullname  -notlike "*chromedriver*"
	}| %{
		$sname = registerwinservice($_)
		start-service $sname
		Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
	}
