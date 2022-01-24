Import-module '.\scripts\sideFunctions.psm1'

# Создаем БД Cupis.GrpcHost
$dbname = "Cupis.GrpcHost"
# Редактируем конфиг
$pathtojson = "C:\Services\Payments\PaymentCupisService\BaltBet.PaymentCupis.Grpc.Host\appsettings.json"
$DataSource = "localhost"
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 | Where-Object -FilterScript { $_.interfaceindex -ne 1 }).IPAddress.trim()

$config = Get-Content -Path $pathtojson -Encoding UTF8
$config = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json
$config.DbOptions.ConnectionString = "data source=${DataSource};initial catalog=${dbname};Integrated Security=true;MultipleActiveResultSets=True;"
$config.RabbitBusOptions.ConnectionString = "host=localhost"
$config.Serilog.WriteTo[1].Args.path = "C:\logs\Payments\Payment.Cupis\Payment.Cupis-.log"
$config.Kestrel.Endpoints.HttpGrpc.Url = "http://0.0.0.0:5003"
$config.Kestrel.Endpoints.HttpWeb.Url = "http://0.0.0.0:5002"
$config.AggregatorGrpcOptions.ServiceAddress = "http://172.16.1.70:32421"
$config.AggregatorGrpcOptions.NotificationUrl = "http://${IPAddress}:5001/api/v1/notifications/aggregator"
$config.AggregatorGrpcOptions.CheckWithdrawUrl = "http://${IPAddress}:5001/api/v1/payout/checkwithdraw"

ConvertTo-Json $config -Depth 4| Format-Json | Set-Content $pathtojson -Encoding UTF8

$reportval =@"
[paysys]
$webConfig
    .DbOptions.ConnectionString = "data source=${DataSource};initial catalog=${dbname};Integrated Security=true;MultipleActiveResultSets=True;"
    .RabbitBusOptions.ConnectionString = "host=localhost"
    .Serilog.WriteTo[1].Args.path = "C:\logs\Payments\Payment.Cupis\Payment.Cupis-.log"
    .Kestrel.Endpoints.HttpGrpc.Url = "http://0.0.0.0:5003"
    .Kestrel.Endpoints.HttpWeb.Url = "http://0.0.0.0:5002"
    .AggregatorGrpcOptions.ServiceAddress = "http://172.16.1.70:32421"
    .AggregatorGrpcOptions.NotificationUrl = "http://${IPAddress}:5001/api/v1/notifications/aggregator"
    .AggregatorGrpcOptions.CheckWithdrawUrl = "http://${IPAddress}:5001/api/v1/payout/checkwithdraw"
$('='*60)


"@
add-content -force -path "$($env:workspace)\$($env:config_updates)" -value $reportval -encoding utf8
