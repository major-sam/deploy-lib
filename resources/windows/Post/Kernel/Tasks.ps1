Import-module '.\scripts\sideFunctions.psm1'

$folder =  "C:\Kernel\TasksDB"
Apply-DB-Tasks -ScriptFolder $folder -TargetDB 'BaltBetM' -DBServer $env:COMPUTERNAME
Apply-DB-Tasks -ScriptFolder $folder -TargetDB  'BaltBetMMirror'-DBServer $env:COMPUTERNAME
