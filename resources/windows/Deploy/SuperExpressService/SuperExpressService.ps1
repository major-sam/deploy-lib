import-module '.\scripts\sideFunctions.psm1'
# Редактируем конфиг
$ServiceName = "SuperExpressService"
$appsettings = "C:\Services\SuperExpressService\appsettings.json"
$DataSourceKernel = "BaltBetM"
$DataSourceKernelWeb = "BaltBetWeb"


Write-Host -ForegroundColor Green "[INFO] Edit BaltBet.SuperExpressService configuration files..."
$config = Get-Content -Path $appsettings -Encoding UTF8
$config = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

$config.ConnectionStrings.Kernel = "server=localhost;Integrated Security=SSPI;MultipleActiveResultSets=true;Initial Catalog=${DataSourceKernel}"
$config.ConnectionStrings.KernelWeb = "server=localhost;Integrated Security=SSPI;MultipleActiveResultSets=true;Initial Catalog=${DataSourceKernelWeb}"
ConvertTo-Json $config -Depth 4  | Format-Json | Set-Content $appsettings -Encoding UTF8

$reportval =@"
[$ServiceName]
$config
       .ConnectionStrings.Kernel = "server=localhost;Integrated Security=SSPI;MultipleActiveResultSets=true;Initial Catalog=${DataSourceKernel}"
       .ConnectionStrings.KernelWeb = "server=localhost;Integrated Security=SSPI;MultipleActiveResultSets=true;Initial Catalog=${DataSourceKernelWeb}"
$('='*60)

"@
add-content -force -path "$($env:workspace)\$($env:config_updates)" -value $reportval -encoding utf8
