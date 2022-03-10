Import-module '.\scripts\sideFunctions.psm1'

$dbname = "UpdateApkService"
$initScriptFolder = "C:\Services\UpdateApk\DB"


# Создаем БД UpdateApk
CreateSqlDatabase($dbname)

# Выполняем скрипт инициализации
$initScript = "${initScriptFolder}\DeployDb.sql"
if(Test-Path $initScript) {
    Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $script -ErrorAction continue
} else {
    Write-Host -ForegroundColor Green "[WARN] There is no ${initScript} "
    #exit 1
}

<# Выполняем остальные скрипты
if (Test-Path $initScriptFolder) {
    foreach ($script in (Get-Item -Path $initScriptFolder\* -Include "*.sql" -Exclude "InitDb.sql").FullName | Sort-Object ) {    
        Write-Host -ForegroundColor Green "[INFO] Execute $script on $dbname"
        Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $script -ErrorAction continue
    }    
} else {
    Write-Host -ForegroundColor Green "[INFO] There is no Tasks folder"
}
#>