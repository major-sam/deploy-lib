<#
ARCHI-225
https://jira.baltbet.ru:8443/browse/ARCHI-225

UniAuthService (хостим в IIS https:450, заменить на 449 после выхода задачи)
#>

Import-module '.\scripts\sideFunctions.psm1'

$redispasswd = $ENV:REDIS_CREDS_PSW
$shortRedisStr="$($env:REDIS_HOST),password=$redispasswd"
$rabbitpasswd = $env:RABBIT_CREDS_PSW
$shortRabbitStr="host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

$serviceName = "UniAuthService"
$targetDir = "C:\Services\UniAuthService\${serviceName}"
$ProgressPreference = 'SilentlyContinue'
$pathtojson = "$targetDir\appSettings.json"
$jsonDepth = 5
$grpcPort = 32418
$dbname = "AuthService"
$keyFolder = "c:\keys"
$reCaptchaPK = $env:RECAPTCHA_PK

Write-host "[INFO] Start ${serviceName} deploy script"
Write-Host -ForegroundColor Green "[INFO] Edit $pathtojson"
$jsonAppsetings = Get-Content -Raw -path $pathtojson  | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json 

# Настраиваем секцию подключения к БД
$jsonAppsetings.ConnectionStrings.AuthDb = "data source=localhost;initial catalog=${dbname};Integrated Security=SSPI;MultipleActiveResultSets=True;"
$jsonAppsetings.ConnectionStrings.Redis = $shortRedisStr

# Настраиваем секцию логирования
$jsonAppsetings.Serilog.WriteTo | % { if ($_.Name -like 'File') {
        $_.Args.path = "C:\Logs\Uni.AuthService\Uni.AuthService-.txt"  
        $_.Args.restrictedToMinimumLevel = "Debug" 
    }
}

# Настраиваем секцию GrpcPort
$jsonAppsetings.Grpc.Services | % { if ($_.Name -like 'AuthenticationService') {
        $_.Host = "localhost"
        $_.Port = $grpcPort     
    }
}

# Включаем логирование запросов
if ( $null -ne $jsonAppsetings.ProtectedKeysFolder){ $jsonAppsetings.ProtectedKeysFolder = $keyFolder }

# Включаем логирование запросов
$jsonAppsetings.RequestResponseLogIsEnabled = $true

# Включаем swagger
$jsonAppsetings.UseSwagger = $true

# Настраиваем ReCaptcha
$jsonAppsetings.ReCaptcha.IsCaptchaEnabled = $false
$jsonAppsetings.ReCaptcha.PrivateKey = $reCaptchaPK
$jsonAppsetings.ReCaptcha.VerifyUrl = "https://www.google.com/recaptcha/api/siteverify"

# Настраиваем коннект к RabbitMQ
$jsonAppsetings.Bus.IsEnabled = $true
$jsonAppsetings.Bus.ConnectionString = $shortRabbitStr
$jsonAppsetings.Bus.Exchange = "Exchange.AccountNotifications"

ConvertTo-Json $jsonAppsetings -Depth $jsonDepth  | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"
