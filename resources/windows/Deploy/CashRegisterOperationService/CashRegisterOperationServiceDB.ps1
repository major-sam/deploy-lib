# Сервис корректировки сумм ставок, принятых на ППС, через формирование чеков коррекции (.Net6)
# На проде как служба
# Описание: https://confluence.baltbet.ru:8444/pages/viewpage.action?pageId=84532336
# Задача: https://jira.baltbet.ru:8443/browse/PAY-553

Import-module '.\scripts\sideFunctions.psm1'

$ServiceName = "CashRegisterOperationService"
$ServiceFolderPath = "C:\Services\${ServiceName}"

Move-Item -Path "C:\Services\CashRegisterOperationServiceDB" -Destination $ServiceFolderPath

$dbname = "CashRegisterOperationService"

# Создаем БД CashRegisterOperationService
CreateSqlDatabase($dbname)

