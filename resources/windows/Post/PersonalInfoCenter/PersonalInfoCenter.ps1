import-module '.\scripts\sideFunctions.psm1'
$picRoot = 'c:\Services\PersonalInfoCenter'
$serviceBins = @(
		Get-ChildItem -Recurse -Filter *.exe -Depth 2 $picRoot |%  {$_.fullname} | ?
			{$_ -inotlike "*AdminMessageService*"}
)
$serviceBins | % {
	$sname = RegisterWinService(get-item -path $_)
	start-Service $sname
	Set-Recovery -ServiceDisplayName $sname -Server $env:COMPUTERNAME
}
return 0
