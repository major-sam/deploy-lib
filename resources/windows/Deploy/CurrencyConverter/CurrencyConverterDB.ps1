Import-module '.\scripts\sideFunctions.psm1'

$dbname = "CurrencyConverter"
$initScriptFolder = "C:\Services\CurrencyConverter\CurrencyConverter.DB"
$sqlTasksFolder = "C:\Services\CurrencyConverter\CurrencyConverter.DB\Tasks"

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

# Выполняем скрипт по задаче
if (Test-Path $sqlTasksFolder) {
    foreach ($script in (Get-Item -Path $sqlTasksFolder\* -Include "*.sql").FullName | Sort-Object ) {    
        Write-Host -ForegroundColor Green "[INFO] Execute $script on $dbname"
        Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $script -ErrorAction continue
    }    
} else {
    Write-Host -ForegroundColor Green "[INFO] There is no Tasks folder"
}
