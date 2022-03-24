Import-module '.\scripts\sideFunctions.psm1'

$dbname = "CurrencyConverter"
$folder = "C:\Services\CurrencyConverter\CurrencyConverter.DB\Tasks"

ApplyTasks -ScriptFolder $folder -TargetDB $dbname -DBServer $env:COMPUTERNAME

