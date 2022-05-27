<#
CashBookService

Назначение
Хранение z-отчетов. Расчет оперативной кассовой книги. Формирование кассового листа (pdf)

Репозиторий
https://bitbucket.baltbet.ru:8445/projects/CASH/repos/cashbook/browse
#>


Import-module '.\scripts\sideFunctions.psm1'


# Редактируем конфиг
$ServiceName = "CashBookService"


Write-Host -ForegroundColor Green "[INFO] Edit BaltBet.CashBookService configuration files..."
$pathtojson = "C:\Services\CashBookService\appsettings.json"
$config = Get-Content -Path $pathtojson -Encoding UTF8
$json_appsetings = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

$json_appsetings.Serilog.WriteTo| %{ if ($_.Name -like 'File'){
	        $_.Args.path = "C:\logs\CashBookService\CashBookService-{Date}.log"   
			    }
}
$json_appsetings.Kestrel.EndPoints.HttpsInlineCertStore.Certificate.Location = "LocalMachine"
ConvertTo-Json $json_appsetings -Depth 4  | Format-Json | Set-Content $pathtojson -Encoding UTF8

