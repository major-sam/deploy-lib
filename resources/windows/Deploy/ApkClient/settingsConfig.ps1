
$CurrentIpAddr =(Get-NetIPAddress -AddressFamily ipv4 |  Where-Object -FilterScript { $_.interfaceindex -ne 1}).IPAddress.trim()
$SettingsConfig = 'C:\ApkClient\Settings.xml'

if (Test-Path $SettingsConfig){
    $xmlconfig = [Xml](Get-Content $SettingsConfig)
    $xmlconfig.Settings.IP =$CurrentIpAddr
    $xmlconfig.Settings.LocalIP =$CurrentIpAddr
    $xmlconfig.Save($SettingsConfig)
}else{
    Write-Host "$SettingsConfig not exists"
}
