Import-module '.\scripts\sideFunctions.psm1'

$dbname = "AccountStatisticsService"

# Создаем БД CashRegisterOperationService
CreateSqlDatabase($dbname)
