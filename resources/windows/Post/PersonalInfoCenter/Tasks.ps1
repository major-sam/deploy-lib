Import-module '.\scripts\sideFunctions.psm1'

$dbname = 'MessageService' 
if(Test-Path C:\Services\PersonalInfoCenter\MessageServiceDb\Tasks\*){
	Write-host 'apply db Tasks'
	$folder = "C:\Services\PersonalInfoCenter\MessageService\DB"
	ApplyTasks -ScriptFolder $folder -TargetDB $dbname -DBServer $env:COMPUTERNAME
}elseif(Test-Path C:\Services\PersonalInfoCenter\MessageService\DB)
	Write-host 'apply old db Tasks'
	$folder = "C:\Services\PersonalInfoCenter\MessageService\DB"
	ApplyTasks -ScriptFolder $folder -TargetDB $dbname -DBServer $env:COMPUTERNAME
}
}else
	Write-host 'No db Tasks for issue'
}
