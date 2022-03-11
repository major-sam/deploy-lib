Import-module '.\scripts\sideFunctions.psm1'

$dbname = "UpdateApkService"
$initScriptFolder = "C:\Services\UpdateApk\DB"

$query_add_user = "
insert into Users (Login, FullName) values ('GKBALTBET\$($env:DEPLOYUSER)', '$($env:DEPLOY_USER_NAME)')

insert into Roles (Name) values ('Write')
insert into Roles (Name) values ('Read')

declare @role varchar(128) = (select top 1 Id from Roles where Name = 'Write')

insert into UserRoles (UserId, RoleId)
    select Users.Id, @role from Users
"

# Создаем БД UpdateApk
Write-Host -ForegroundColor Green "[INFO] Create database $dbname"
CreateSqlDatabase($dbname)

# Выполняем скрипт инициализации, добавляем пользователя и роль
$initScript = "${initScriptFolder}\DeployDb.sql"

if(Test-Path $initScript) {
    Write-Host -ForegroundColor Green "[INFO] Execute script $initScript on database $dbname"
    Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $initScript -ErrorAction continue
    Write-Host -ForegroundColor Green "[INFO] Add user $($env:DEPLOYUSER) to database $dbname"
    Invoke-Sqlcmd -verbose -QueryTimeout 720 -ServerInstance $env:COMPUTERNAME -Database $dbname -query $query_add_user -ErrorAction continue
} else {
    Write-Host -ForegroundColor Green "[WARN] There is no ${initScript} "
    #exit 1
}
