$unity_config = "c:\kernel\config\UnityConfig.config"

$type_email = "Kernel.Services.Infrastructure.Email.IEMailService, Kernel.Infrastructure"
$type_sms = "Kernel.Services.Infrastructure.SMS.ISMSService, Kernel.Infrastructure"

$map_email = "Kernel.Services.Infrastructure.FakeEMailService, Kernel.StubServices"
$map_sms = "Kernel.Services.Infrastructure.StubSMSService, Kernel.StubServices"

[xml]$content = (Get-Content -Path $unity_config -Encoding utf8)

$content.unity.container.register | % {
    if ($_.type -eq $type_email) {
        Write-Host "[INFO] Enable FakeEmail in $unity_config"
        $_.mapTo = $map_email
    }
    if ($_.type -eq $type_sms) {
        Write-Host "[INFO] Enable FakeSMS in $unity_config"
        $_.mapTo = $map_sms
    }
}

# Сохраняем конфиг
$content.Save("c:\kernel\config\UnityConfig.config")
