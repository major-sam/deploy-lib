Import-module '.\scripts\sideFunctions.psm1'

$folder =  "C:\Services\CashRegisterOperationService\CashRegisterOperationServiceDB"
$dbname = 'Parser'
Apply-DB-Tasks -ScriptFolder $folder -TargetDB $dbname -DBServer $env:COMPUTERNAME
