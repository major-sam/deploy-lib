# Установить для всех СОМ аккунтов свойство 116 для доступа на сайт СОМ


$file = "$($env:workspace)\scripts\post\ComAccountsSql\COMAccounts.sql"
$queryTimeout = 720
$MyUrl = "$env:COMPUTERNAME".ToLower()

# Меняем $query без сохранения оригинала
$query = (get-content -raw -Encoding UTF8 -Path "$file") -replace '#VM_URL', $MyUrl

# Выполняем полученный $query
Write-Host -ForegroundColor Green "[INFO] Execute COMAccounts.sql"
Invoke-Sqlcmd -verbose -QueryTimeout $queryTimeout -ServerInstance $env:COMPUTERNAME -Query $query -ErrorAction continue
