Import-module '.\scripts\sideFunctions.psm1'

$folder =  "C:\Kernel\TasksDB"
ApplyTasks -ScriptFolder $folder -TargetDB 'BaltBetM' -DBServer $env:COMPUTERNAME
ApplyTasks -ScriptFolder $folder -TargetDB  'BaltBetMMirror'-DBServer $env:COMPUTERNAME
