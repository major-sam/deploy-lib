# 5. Обновляем настройки Uni.Ru

$queryTimeout = 720
$dbname = "UniRu"

# Включаем настройки в админке (если есть кириллические символы, кодировка файла должна быть UTF-8 BOM)
$query_insert_settings = "
INSERT INTO UniRu.Settings.SiteOptions (GroupId, Name, Value, IsInherited)
VALUES
    (1,N'PlayerIdentificationSettings.ECupisAddressЕСИА','https://wallet.1cupis.ru/auth',0)    
GO
"
Write-Host -ForegroundColor Green "[INFO] Insert settings to UniRu"
Invoke-Sqlcmd -QueryTimeout $queryTimeout -verbose -ServerInstance $env:COMPUTERNAME -Database $dbname -query $query_insert_settings -ErrorAction continue
