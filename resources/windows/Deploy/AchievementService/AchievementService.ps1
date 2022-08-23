import-module '.\scripts\sideFunctions.psm1'


$rabbitpasswd = $env:RABBIT_CREDS_PSW
$shortRabbitStr="host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"
$pathtojson = "C:\Services\AchievementService\appsettings.json"
$jsonDepth = 5

Write-Host -ForegroundColor Green "[info] edit json files"
$config = Get-Content -Encoding utf8 -Path $pathtojson | ConvertFrom-Json 
$config.RabbitMqConnection.Host = "$($shortRabbitStr);publisherConfirms=true;timeout=5;virtualhost=/"

$config.Serilog.WriteTo | % {
    if ($_.Name -eq 'File' ){
        $_.Args.path = "C:\Logs\AchievementService\AchievementService.log"
    }
}

$config.ConnectionStrings.KernelDb = "data source=$($env:COMPUTERNAME);initial catalog=BaltBetM;Integrated Security=true;MultipleActiveResultSets=True;"
$config.ConnectionStrings.AchievementDb = "data source=$($env:COMPUTERNAME);initial catalog=AchievementService;Integrated Security=true;MultipleActiveResultSets=True;"

ConvertTo-Json $config -Depth $jsonDepth| Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "$pathtojson renewed with json depth $jsonDepth"
