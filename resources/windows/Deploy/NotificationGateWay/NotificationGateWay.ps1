Import-module '.\scripts\sideFunctions.psm1'
$redispasswd = "$($ENV:REDIS_CREDS_PSW)$($ENV:VM_ID)" 
$shortRedisStr="$($env:REDIS_HOST):$($env:REDIS_Port),password=$redispasswd"
$rabbitpasswd = "$($env:RABBIT_CREDS_PSW)$($ENV:VM_ID)" 
$shortRabbitStr="host=$($ENV:RABBIT_HOST):$($ENV:RABBIT_PORT);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

$ServiceName = "NotificationGateWay"
$targetDir  = "C:\Services\$($ServiceName)"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appsettings.json"
$jsonDepth = 5

Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  | % {$_ -replace  '\s*\/\*(.*|(.*\n){1,4}\s.*)\*\/', ""} | ConvertFrom-Json 

###
#Json values replace
####

$node = '{
    "Name": "File",
    "Args": {
        "path": "C:\\Logs\\'+"$($ServiceName)\\$($ServiceName)"+'-{Date}.log",
        "rollingInterval": 3,
        "retainedFileCountLimit": 7
    }
}' | ConvertFrom-Json
$jsonAppsetings.Serilog.WriteTo += $node

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
$jsonAppsetings.AppSettings.RabbitMQ.ConnectionString = $shortRabbitStr

ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"
