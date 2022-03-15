if (test-path "c:\kernel\TasksDB"){
	write-host "[INFO] Exec tasks"
	get-ChildItem "c:\Kernel\TasksDB\*" -include "*.sql" | Sort-Object | % {
		Write-Host -ForegroundColor Green "[INFO] Execute script $_ on database BaltBetM"
		Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database 'BaltBetM' -InputFile $_ -ErrorAction continue
		Write-Host -ForegroundColor Green "[INFO] Execute script $_ on database BaltBetMMirror"
		Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database 'BaltBetMMirror' -InputFile $_ -ErrorAction continue
		}
}else{
	write-host "no task for this branch"
}

