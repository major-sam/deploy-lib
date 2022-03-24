Import-module '.\scripts\sideFunctions.psm1'

$folder = "C:\Services\PersonalInfoCenter\MessageService\DB"
$dbname = 'MessageService' 
ApplyTasks -ScriptFolder $folder -TargetDB $dbname -DBServer $env:COMPUTERNAME
