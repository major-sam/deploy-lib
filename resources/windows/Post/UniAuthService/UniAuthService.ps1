#Import-module '.\scripts\sideFunctions.psm1'

#$IPAddress = (Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
#$uasPort = 449

# Меняем строки соединений в конфиге UniRu
# Перемещено в deploy\Uni\UniRu.ps1

# Меняем строки соединений в конфиге UniRuWebApi
# Перемещено в deploy\Uni\UniRu.ps1

# Меняем строки соединений в конфиге WebSiteRu
# Перемещено в deploy\Web\WebSite.ps1

Write-Host -ForegroundColor Green "[INFO] Move to deploy\Uni\ deploy\WebSite\"