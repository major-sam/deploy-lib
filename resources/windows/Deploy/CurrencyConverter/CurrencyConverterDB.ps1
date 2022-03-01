Import-module '.\scripts\sideFunctions.psm1'

$dbname = "CurrencyConverter"
$initScriptFolder = "C:\Services\CurrencyConverter\CurrencyConverter.DB"
$sqlTasksFolder = "C:\Services\CurrencyConverter\CurrencyConverter.DB\Tasks"

# Создаем БД CurrencyConverter
CreateSqlDatabase($dbname)

# Выполняем скрипт инициализации
foreach ($script in (Get-Item -Path $initScriptFolder\* -Include "*.sql").FullName | Sort-Object ) {    
    Write-Host -ForegroundColor Green "[INFO] Execute $script on $dbname"
    Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $script -ErrorAction continue
}

# Выполняем скрипт по задаче
foreach ($script in (Get-Item -Path $sqlTasksFolder\* -Include "*.sql").FullName | Sort-Object ) {    
    Write-Host -ForegroundColor Green "[INFO] Execute $script on $dbname"
    Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $script -ErrorAction continue
}