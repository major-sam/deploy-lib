$unity_config = "c:\kernel\config\UnityConfig.config"

$type_email = "Kernel.Services.Infrastructure.Email.IEMailService, Kernel.Infrastructure"
$type_sms = "Kernel.Services.Infrastructure.SMS.ISMSService, Kernel.Infrastructure"

$map_email = "Kernel.Services.Infrastructure.FakeEMailService, Kernel.StubServices"
$map_sms = "Kernel.Services.Infrastructure.StubSMSService, Kernel.StubServices"

[xml]$content = (Get-Content -Path $unity_config -Encoding utf8)
$ns = $content.DocumentElement.NamespaceURI

# Меняем базовые значения для включения заглушек логирования кодов в рассылке по email и sms (Для тестировщиков)
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

# Добавляем новый узел "registry". Добавляет лог смс при регистрации ППС. (Для тестировщиков)
Write-Host "[INFO] Add new register node to $unity_config"
$register = $content.CreateElement('register', $ns)
$register.SetAttribute("type","Kernel.Notifications.ISmsRegistrationService, Kernel")
$register.SetAttribute("mapTo","Kernel.Notifications.SmsRegistrationServiceStub, Kernel")
$lifetime = $content.CreateElement('lifetime', $ns)
$lifetime.SetAttribute("type","singleton")
$register.AppendChild($lifetime) | Out-Null
$content.unity.container.AppendChild($register) | Out-Null

# Сохраняем конфиг
$content.Save($unity_config)
