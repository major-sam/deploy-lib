<#
    BaltBet.TicketServiceApi
    Скрипт для разворота BaltBet.TicketServiceApi.
    c:\Services\TicketService

    Дополнительно нужный правки в Web.config сайтов "UniRu","baltbetcom","baltbetru"
#>


$ServiceName = "TicketService"
$pathtojson = "C:\Services\TicketService\appsettings.json"
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()


# Редактирование конфигов
Write-Host -ForegroundColor Green "[INFO] Edit BaltBet.TicketServiceApi configuration files..."
$config = Get-Content -Path $pathtojson -Encoding UTF8
$json_appsetings = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json
$json_appsetings.Kestrel.EndPoints.Http.Url = "${IPAddress}:5037" 
ConvertTo-Json $json_appsetings -Depth 4  | Format-Json | Set-Content $pathtojson -Encoding UTF8

$reportval =@"
[$ServiceName]
$pathtojson
       .ConnectionStrings.Kernel = "server=localhost;Integrated Security=SSPI;MultipleActiveResultSets=true;Initial Catalog=${DataSourceKernel}"
       .ConnectionStrings.KernelWeb = "server=localhost;Integrated Security=SSPI;MultipleActiveResultSets=true;Initial Catalog=${DataSourceKernelWeb}"
"@
add-content -force -path "$($env:workspace)\$($env:config_updates)" -value $reportval -encoding utf8
