# Отправка запроса в UniAuthService
# Если не вызвать, КРМ циклически перенаправляет страницу, пока не зайдешь на сайт UniRu
# Для первого запроса 404 - норма, во втором запросе должен быть 200

$url = "https://${env:COMPUTERNAME}.bb-webapps.com:449".ToLower()
Write-Host "Get request for UniAuthService " $url
curl.exe $url --verbose

Write-Host "Get request for health ${url}/health"
curl.exe "${url}/health" --verbose