Import-module '.\scripts\sideFunctions.psm1'

$dbname = "CurrencyConverter"
$initScriptFolder = "C:\Services\CurrencyConverter\CurrencyConverter.DB"

# Создаем БД CurrencyConverter
CreateSqlDatabase($dbname)

# Выполняем скрипт инициализации
$initScript = "${initScriptFolder}\Init.sql"
if(Test-Path $initScript) {
    foreach ($script in (Get-Item -Path $initScriptFolder\* -Include "*.sql").FullName | Sort-Object ) {    
        Write-Host -ForegroundColor Green "[INFO] Execute $script on $dbname"
        Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $script -ErrorAction continue
    }
} else {
    Write-Host -ForegroundColor Green "[WARN] There is no ${initScript} "
    exit 1
}

