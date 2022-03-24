Import-module '.\scripts\sideFunctions.psm1'

$folder =  "C:\Services\CashRegisterOperationService\CashRegisterOperationServiceDB"
$dbname = "CashRegisterOperationService"
ApplyTasks -ScriptFolder $folder -TargetDB $dbname -DBServer $env:COMPUTERNAME
