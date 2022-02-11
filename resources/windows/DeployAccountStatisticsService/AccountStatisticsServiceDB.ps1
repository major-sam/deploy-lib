Import-module '.\scripts\sideFunctions.psm1'

$dbname = "AccountStatisticsService"

# Создаем БД AccountStatisticsService
CreateSqlDatabase($dbname)
