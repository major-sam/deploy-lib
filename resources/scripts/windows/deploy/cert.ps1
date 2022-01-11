# Добавляем сертификат в корневое хранилище 
# CERT FILES PROVIDED BY JENKINS
Write-Host -ForegroundColor Green "[INFO] Add certificate 'gkbaltbet-ca' to Root Trusted"
certutil.exe -addstore root $env:GKBALTBETCA
Push-Location $env:WORKSPACE
$Secure_String_Pwd = ConvertTo-SecureString "BaltbetBB" -AsPlainText -Force
Import-PfxCertificate -FilePath $env:BBWEBAPPS -CertStoreLocation Cert:\LocalMachine\My -Password $Secure_String_Pwd

Push-Location $env:WORKSPACE

# Добавляем новый сертификат в Windows
Write-Host -ForegroundColor Green "[INFO] Add new test.wcf.host.pfx certificate"
$Secure_String_Pwd = ConvertTo-SecureString "12345" -AsPlainText -Force
Import-PfxCertificate -FilePath $env:WCFHOST -CertStoreLocation Cert:\LocalMachine\My -Password $Secure_String_Pwd

Push-Location $env:WORKSPACE

Write-Host -ForegroundColor Green "[INFO] Add new client.test.kernel.pfx certificate"
$Secure_String_Pwd = ConvertTo-SecureString "123456" -AsPlainText -Force
Import-PfxCertificate -FilePath $env:CLIENTTESTKERNEL -CertStoreLocation Cert:\LocalMachine\My -Password $Secure_String_Pwd

Push-Location $env:WORKSPACE

Write-Host -ForegroundColor Green "[INFO] Add Test Cupis certificate"
certutil.exe -addstore root $env:TESTCUPISCA
$Secure_String_Pwd = ConvertTo-SecureString "$($env:CUPIS_GRPC_CERT_PASS)" -AsPlainText -Force
Import-PfxCertificate -FilePath $env:TESTCUPISCERT -CertStoreLocation Cert:\LocalMachine\My -Password $Secure_String_Pwd

Push-Location $env:WORKSPACE

Write-Host -ForegroundColor Green "[INFO] Add new test.payment.service.pfx certificate"
$Secure_String_Pwd = ConvertTo-SecureString "123456" -AsPlainText -Force
Import-PfxCertificate -FilePath $env:TESTPAYMENTSERVICE -CertStoreLocation Cert:\LocalMachine\My -Password $Secure_String_Pwd

Push-Location $env:WORKSPACE
