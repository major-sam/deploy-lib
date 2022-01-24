
# Редактируем конфиг
$ServiceName = "ActionLogService"
$ServiceFolderPath = "C:\Services\${ServiceName}"
$Catalog = "BaltBetM"


Write-Host -ForegroundColor Green "[INFO] Edit BaltBet.ActionLogService configuration files..."
$config = Get-Content -Path "$ServiceFolderPath\appsettings.json" -Encoding UTF8
$config = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

$config.Serilog.WriteTo[1].Args.path = "C:\logs\ActionLogService\ActionLogService-.log"
$config.Settings.Database = "data source=localhost;initial catalog=${Catalog};Integrated Security=true;MultipleActiveResultSets=True;"

Set-Content -Path "$ServiceFolderPath\appsettings.json" -Encoding UTF8 -Value ($config | ConvertTo-Json -Depth 100)

$reportVal =@"
[$ServiceName]
Serilog.WriteTo[1].Args.path = "C:\logs\ActionLogService\ActionLogService-.log"
Settings.Database = "data source=localhost;initial catalog=${Catalog};Integrated Security=true;MultipleActiveResultSets=True;"
$('='*60)

"@

Add-Content -force -Path "$($env:WORKSPACE)\$($env:CONFIG_UPDATES)" -value $reportVal -Encoding utf8
