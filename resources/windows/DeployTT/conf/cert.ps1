# Добавляем сертификат в корневое хранилище
Write-Host "[INFO] Add certificate 'adfs' to Root Trusted"
certutil.exe -addstore root  $env:TTADFS
certutil.exe -addstore -f "My" $env:TTADFS
