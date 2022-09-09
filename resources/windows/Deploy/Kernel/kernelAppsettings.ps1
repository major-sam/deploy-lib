import-module '.\scripts\sideFunctions.psm1'

$ProgressPreference = 'SilentlyContinue'
$targetDir = 'C:\Kernel'
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$pathtojson = "$targetDir\appsettings.json "
$rabbitpasswd = $env:RABBIT_CREDS_PSW
$shortRabbitStr="host=$($ENV:RABBIT_HOST);username=$($ENV:RABBIT_CREDS_USR);password=$rabbitpasswd"

# Kernel ports
$kernel_ports_dict = @{
    'kernel-webapi' = 8081
    'kernel-remoting' = 8082
    'kernel-signalr' = 8201
    'UniGrpcServer' = 32418
}

$kestrel_http_port = 8081
$host_address = "localhost"
$fqdn = "$ENV:COMPUTERNAME.bb-webapps.com".ToLower()
$http_healthcheck_address = "http://${fqdn}:${kestrel_http_port}/health"
$grpc_healthcheck_address = "${fqdn}"

###### edit json files

Write-Host -ForegroundColor Green "[INFO] Edit json files"
$json_appsetings = Get-Content -Raw -path $pathtojson | % { $_ -replace '[\s^]//.*', "" } | ConvertFrom-Json 
$HttpsInlineCertStore = '
    {     }
'| ConvertFrom-Json 

$json_appsetings.Kestrel.EndPoints.Http.Url = "http://+:${kestrel_http_port}"
$json_appsetings.Kestrel.EndPoints.HttpsInlineCertStore =  $HttpsInlineCertStore
$json_appsetings.ConnectionStrings.RabbitMQ = $shortRabbitStr

$json_appsetings.Consul.Services | % {
    $sname = $_.ConsulConfig.ServiceName

    write-host "[INFO] Set ConsulConfig.HostAddress for $sname"
    $_.ConsulConfig.HostAddress = $host_address
    
    write-host "[INFO] Set ConsulConfig.Port for $sname"
    $_.ConsulConfig.Port = $kernel_ports_dict[$sname]
    
    write-host "[INFO] Set ServiceCheckConfig.Address for $sname"
    if($_.ServiceCheckConfig.Type -eq 'Grpc') {
        $_.ServiceCheckConfig.Address = "${grpc_healthcheck_address}:$($_.ConsulConfig.Port)"
    } else {
        $_.ServiceCheckConfig.Address = $http_healthcheck_address
    }
}

ConvertTo-Json $json_appsetings -Depth 5 | Format-Json | Set-Content $pathtojson -Encoding UTF8
Write-Host -ForegroundColor Green "[INFO] $pathtojson renewed with json depth $jsonDepth"
