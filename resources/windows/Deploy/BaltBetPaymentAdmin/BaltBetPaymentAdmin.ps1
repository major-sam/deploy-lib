Import-module '.\scripts\sideFunctions.psm1'

$targetDir  = "C:\Services\BaltBetPaymentAdmin"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appsettings.json"
$jsonDepth = 5

Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  -Encoding UTF8  | % {$_ -replace  '\s\/\/.*', ""} | ConvertFrom-Json 

###
#Json values replace
####

# Внесение данных о сертификате
$Cert = '{
    "Location": "LocalMachine",
    "Subject": "*.bb-webapps.com",
    "Store": "My",
    "AllowInvalid": "true"
}'| ConvertFrom-Json
$jsonAppsetings.Kestrel.Endpoints.Https | Add-Member -NotePropertyValue $Cert -NotePropertyName "Certificate"
$jsonAppsetings.Kestrel.Endpoints.Https | Add-Member -NotePropertyValue "Http1" -NotePropertyName "Protocols"

# Изменение пути до файла логов
$FileLogs = $jsonAppsetings.Serilog.WriteTo | % {if($_.Name.Equals("File")){return $_}}
$FileLogs.Args.path = "C:\\Logs\\BaltBetPaymentAdmin\\BaltBet.Payment.Admin-.log"

# Добавление прав пользователям
$user1 = "{
    'Name': 'GKBALTBET\\ktofilyuk',
    'Claims': [ 'ServiceAccessClaim', 'TransactionsAccessClaim', 'ConfiguratorAccessClaim' ]
}" | ConvertFrom-Json
$user2 = "{
    'Name': 'GKBALTBET\\nkiryushina',
    'Claims': [ 'ServiceAccessClaim', 'TransactionsAccessClaim', 'ConfiguratorAccessClaim' ]
}" | ConvertFrom-Json
$jsonAppsetings.AuthOptions.Users+=$user1
$jsonAppsetings.AuthOptions.Users+=$user2

# Коннект до БД кернела
$jsonAppsetings.KernelOptions.ConnectionString = "data source=$($env:COMPUTERNAME);initial catalog=BaltBetM;Integrated Security=true;MultipleActiveResultSets=True;trust server certificate=True"

# Коннект до БД Аггрегатора ком и ру зоны
$jsonAppsetings.PaymentOptions.Com.ConnectionString = "data source=TEST-SQL16WIN19\\MSSQLSERVER2;initial catalog=BaltBet_Payment_Test;Integrated Security=true;MultipleActiveResultSets=True;trust server certificate=True"
$jsonAppsetings.PaymentOptions.Ru.ConnectionString = "data source=TEST-SQL16WIN19\\MSSQLSERVER2;initial catalog=BaltBet_Payment_Test;Integrated Security=true;MultipleActiveResultSets=True;trust server certificate=True"


ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"