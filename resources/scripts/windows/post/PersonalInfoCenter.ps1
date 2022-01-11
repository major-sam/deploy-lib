import-module '.\scripts\sideFunctions.psm1'
$picRoot = 'c:\Services\PersonalInfoCenter'
$serviceBins = @(
		"$($picRoot)\MessageService\BaltBet.MessageService.Host.exe" , 
		"$($picRoot)\PromoCodeService\BaltBet.PromoCodeService.Host.exe" , 
		"$($picRoot)\PushService\BaltBet.PushService.Host.exe")
$serviceBins | % {
	$sname = RegisterWinService(get-item -path $_)
	start-Service $sname
	Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
}
return 0
