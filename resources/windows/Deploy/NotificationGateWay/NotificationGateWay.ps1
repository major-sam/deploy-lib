Import-module '.\scripts\sideFunctions.psm1'

$targetDir  = "C:\Services\NotificationGateWay"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appsettings.json"
$jsonDepth = 5

Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  | % {$_ -replace  '\s*\/\*(.*|(.*\n){1,4}\s.*)\*\/', ""} | ConvertFrom-Json 

###
#Json values replace
####

# Настраиваем default email 
$jsonAppsetings.AppSettings.EmailSettings.Default.From = "reg@baltbet.ru"
$jsonAppsetings.AppSettings.EmailSettings.Default.FromDisplayName = "TEST"
$jsonAppsetings.AppSettings.EmailSettings.Default.FromHost = "smtp.baltbet.ru"
$jsonAppsetings.AppSettings.EmailSettings.Default.FromLogin = "reg@baltbet.ru"
$jsonAppsetings.AppSettings.EmailSettings.Default.FromPass = "iFbFWtSjeL1"

# Настраиваем email для com
$jsonAppsetings.AppSettings.EmailSettings.Emails[0].From = "pay230@baltbet.ru"
$jsonAppsetings.AppSettings.EmailSettings.Emails[0].FromDisplayName = "TEST"
$jsonAppsetings.AppSettings.EmailSettings.Emails[0].FromHost = "smtp.baltbet.ru"
$jsonAppsetings.AppSettings.EmailSettings.Emails[0].FromLogin = "pay230@baltbet.ru"
$jsonAppsetings.AppSettings.EmailSettings.Emails[0].FromPass = "qk`oP(%;KW'J/Pp"

# Настраиваем email для ru
$jsonAppsetings.AppSettings.EmailSettings.Emails[1].From = "nkiryushina@baltbet.ru"
$jsonAppsetings.AppSettings.EmailSettings.Emails[1].FromDisplayName = "TEST"
$jsonAppsetings.AppSettings.EmailSettings.Emails[1].FromHost = "smtp.baltbet.ru"
$jsonAppsetings.AppSettings.EmailSettings.Emails[1].FromLogin = "nkiryushina@baltbet.ru"
$jsonAppsetings.AppSettings.EmailSettings.Emails[1].FromPass = "ПАРОЛЬ"

# Настраиваем коннект к БД сервиса
$jsonAppsetings.ConnectionStrings.DbConnectionString = "Server=$($env.COMPUTERNAME);Database=BaltBet.SmsService.Db;Trusted_Connection=True;"

# Настраиваем коннект до реббита
$jsonAppsetings.AppSettings.RabbitMQ.ConnectionString = "host=$($env.COMPUTERNAME);username=test;password=test"

ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"