# Сервис корректировки сумм ставок, принятых на ППС, через формирование чеков коррекции (.Net6)
# На проде как служба
# Описание: https://confluence.baltbet.ru:8444/pages/viewpage.action?pageId=84532336
# Задача: https://jira.baltbet.ru:8443/browse/PAY-553

Import-module '.\scripts\sideFunctions.psm1'

$ServiceName = "CashRegisterOperationService"

# Правим конфиг
Write-Host -ForegroundColor Green "[INFO] Edit CashRegisterOperationService configuration files..."
$pathtojson = "C:\Services\CashRegisterOperationService\appsettings.json"
$config = Get-Content -Path $pathtojson -Encoding UTF8
$json_appsetings = $config -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' | ConvertFrom-Json

$json_appsetings.Serilog.WriteTo| %{ if ($_.Name -like 'File'){
	        $_.Args.path = "C:\logs\CashRegisterOperationService\CashRegisterOperationService-.log"   
			    }
}

ConvertTo-Json $json_appsetings -Depth 4  | Format-Json | Set-Content $pathtojson -Encoding UTF8

$reportVal =@"
[$ServiceName]
$config
	.Serilog.WriteTo| %{ if ($_.Name -like 'File'){
			$_.Args.path = "C:\logs\CashBookService\CashBookService-{Date}.log"   
		}
	.Kestrel.EndPoints.HttpsInlineCertStore.Certificate.Location = "LocalMachine"
"@

Add-Content -force -Path "$($env:WORKSPACE)\$($env:CONFIG_UPDATES)" -value $reportVal -Encoding utf8
