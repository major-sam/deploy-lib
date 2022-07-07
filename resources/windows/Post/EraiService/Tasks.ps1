Import-module '.\scripts\sideFunctions.psm1'

$ServiceTasksDbFolder = "EraiServiceDB"
$folder =  "C:\Services\ERAI\${ServiceTasksDbFolder}\Tasks"
$dbname = "EraiDB"

ApplyTasks -ScriptFolder $folder -TargetDB $dbname -DBServer $env:COMPUTERNAME