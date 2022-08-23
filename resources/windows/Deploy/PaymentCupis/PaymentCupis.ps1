Import-module '.\scripts\sideFunctions.psm1'


$redispasswd = $ENV:REDIS_CREDS_PSW
$shortRedisStr="$($env:REDIS_HOST),password=$redispasswd"
$rabbitpasswd = $env:RABBIT_CREDS_PSW
$shortRabbitStr="host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"
$dbname = "Cupis.GrpcHost"
$pathtojson = "C:\Services\Payments\PaymentCupisService\BaltBet.PaymentCupis.Grpc.Host\appsettings.json"
$DataSource = "localhost"
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 | Where-Object -FilterScript { $_.interfaceindex -ne 1 }).IPAddress.trim()
$defaultDomain = "bb-webapps.com"
$httpsAFServicePort = 7157
$AntifraudService = "https://$($env:COMPUTERNAME).$($defaultDomain):$httpsAFServicePort".ToLower()

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
$config.RabbitBusOptions.ConnectionString = $shortRabbitStr

# PAY-725
if($config.ConnectionStrings.AntifraudService) {
    Write-Host "[INFO] Found ConnectionStrings.AntifraudService"
    $config.ConnectionStrings.AntifraudService = $AntifraudService
}
if($config.AntifraudOptions.IsEnabled) {
    Write-Host "[INFO] Found AntifraudOptions.IsEnabled"
    $config.AntifraudOptions.IsEnabled = $false
}

ConvertTo-Json $config -Depth 4| Format-Json | Set-Content $pathtojson -Encoding UTF8
