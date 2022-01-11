# Редактируем конфиг
$ServiceName = "SuperExpressService"
$ServiceFolderPath = "C:\Services\${ServiceName}"
$DataSourceKernel = "BaltBetM"
$DataSourceKernelWeb = "BaltBetWeb"


Write-Host -ForegroundColor Green "[INFO] Edit BaltBet.SuperExpressService configuration files..."
$config = Get-Content -Path "$ServiceFolderPath\appsettings.json" -Encoding UTF8
$config = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

$config.ConnectionStrings.Kernel = "server=localhost;Integrated Security=SSPI;MultipleActiveResultSets=true;Initial Catalog=${DataSourceKernel}"
$config.ConnectionStrings.KernelWeb = "server=localhost;Integrated Security=SSPI;MultipleActiveResultSets=true;Initial Catalog=${DataSourceKernelWeb}"

Set-Content -Path "$ServiceFolderPath\appsettings.json" -Encoding UTF8 -Value ($config | ConvertTo-Json -Depth 100)
