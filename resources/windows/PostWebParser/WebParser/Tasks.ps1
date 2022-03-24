Import-module '.\scripts\sideFunctions.psm1'

$folder = "C:\services\WebParser\DB Script"
$dbname = 'Parser'
Apply-DB-Tasks -ScriptFolder $folder -TargetDB $dbname -DBServer $env:COMPUTERNAME
