Import-module '.\scripts\sideFunctions.psm1'

$dbname = "EraiDB"

# Создаем БД AccountStatisticsService
CreateSqlDatabase($dbname)