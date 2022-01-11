Import-module '.\scripts\sideFunctions.psm1'

# Создаем БД Cupis.GrpcHost
$dbname = "Cupis.GrpcHost"
$queryTimeout = 720

CreateSqlDatabase $dbname
# Выполняем скрипты миграции
#foreach ($script in (Get-Item -Path $sqlfolder\* -Include "*.sql").FullName | Sort-Object ) {    
#    Write-Host -ForegroundColor Green "[INFO] Execute $script on $dbname"
#    Invoke-Sqlcmd -verbose -QueryTimeout $queryTimeout -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile $script -ErrorAction continue
#}

Invoke-Sqlcmd -verbose -QueryTimeout $queryTimeout -ServerInstance $env:COMPUTERNAME -Database $dbname -InputFile  'c:\services\payments\PaymentCupisService\CupisGrpcDb\init.sql' -ErrorAction continue

# Редактируем конфиг
$ServiceFolderPath = "C:\Services\Payments\PaymentCupisService\BaltBet.PaymentCupis.Grpc.Host"
$DataSource = "localhost"
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 | Where-Object -FilterScript { $_.interfaceindex -ne 1 }).IPAddress.trim()

$config = Get-Content -Path "$ServiceFolderPath\appsettings.json" -Encoding UTF8
$config = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json
$config.DbOptions.ConnectionString = "data source=${DataSource};initial catalog=${dbname};Integrated Security=true;MultipleActiveResultSets=True;"
$config.RabbitBusOptions.ConnectionString = "host=localhost"
$config.Serilog.WriteTo[1].Args.path = "C:\logs\Payments\Payment.Cupis\Payment.Cupis-.log"
$config.Kestrel.Endpoints.HttpGrpc.Url = "http://0.0.0.0:5003"
$config.Kestrel.Endpoints.HttpWeb.Url = "http://0.0.0.0:5002"
$config.AggregatorGrpcOptions.ServiceAddress = "http://172.16.1.70:32421"
$config.AggregatorGrpcOptions.NotificationUrl = "http://${IPAddress}:5001/api/v1/notifications/aggregator"
$config.AggregatorGrpcOptions.CheckWithdrawUrl = "http://${IPAddress}:5001/api/v1/payout/checkwithdraw"
Set-Content -Path "$ServiceFolderPath\appsettings.json" -Encoding UTF8 -Value ($config | ConvertTo-Json -Depth 100)

$ServiceName =
$ServiceFolderPath = "C:\Services\Payments\PaymentCupisService\PaymentCupis.RestApi.Host"


$config = Get-Content -Path "$ServiceFolderPath\appsettings.json" -Encoding UTF8
$config = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json
$config.Serilog.WriteTo[1].Args.path = "C:\logs\RestLog\Payment.Cupis-.log"
$config.Kestrel.Endpoints.Http.Url = "http://${IPAddress}:5001"
$config.PSHOptions.ServiceUrl = "http://localhost:88"
$config.DbOptions.ConnectionString = "data source=localhost;initial catalog=Cupis.GrpcHost;Integrated Security=true;MultipleActiveResultSets=True;"
Set-Content -Path "$ServiceFolderPath\appsettings.json" -Encoding UTF8 -Value ($config | ConvertTo-Json -Depth 100)

