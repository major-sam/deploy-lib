# Task DEVOPS-145
# https://jira.baltbet.ru:8443/browse/DEVOPS-145
# Добавляет купон в базу BaltBetM
# На БД UniAdministration выполняется второй скрипт EnableBaltPress.ps1

$dbname = "BaltBetM"
$query = "
USE BaltBetM

INSERT INTO [BaltBetM].[dbo].[ExpressCoupons] (Name, BetSum, StartDate, EndDate, EventsCount, CoefsCount, MinCoef, CreateDate, UserCreateId, StateId)
VALUES (N'Тестовая акция', 200, '2022-08-04 00:00:00.0', '2022-12-31 23:59:00.0', 3, 3, 1.80, '2022-08-04 00:00:00.0', 7838, 1)
GO
"

Write-Host "[INFO] Add ExpressCoupons to $dbname"
Invoke-Sqlcmd -QueryTimeout 360 -verbose -ServerInstance $env:COMPUTERNAME -Database $dbname -query $query -ErrorAction stop