<#
    BaltBet.TicketServiceApi
    Скрипт для разворота BaltBet.TicketServiceApi.
    c:\Services\TicketService

    Дополнительно нужный правки в Web.config сайтов "UniRu","baltbetcom","baltbetru"
#>


$ServiceName = "TicketService"
$ServiceFolderPath = "C:\Services\${ServiceName}"
$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()


# Редактирование конфигов
Write-Host -ForegroundColor Green "[INFO] Edit BaltBet.TicketServiceApi configuration files..."
(Get-Content -Encoding UTF8 -Path "${ServiceFolderPath}\appsettings.json") -replace "localhost:5037","${IPAddress}:5037" | Set-Content -Encoding UTF8 -Path "${ServiceFolderPath}\appsettings.json" 

Write-Host -ForegroundColor Green "[INFO] Print BaltBet.TicketServiceApi configuration files..."
Get-Content -Encoding UTF8 -Path "${ServiceFolderPath}\appsettings.json"
