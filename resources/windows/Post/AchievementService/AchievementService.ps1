import-module '.\scripts\sideFunctions.psm1'

[xml]$kernelSettings = Get-Content -Encoding UTF8 -Path "C:\Kernel\Settings.xml"
$kernelSettings.Settings.PushNotificationSettings.IsBetsEnabled = 'true'
$kernelSettings.Save("C:\Kernel\Settings.xml")

$serviceBin = Get-Item -Path "C:\Services\AchievementService\AchievementService.exe"
$serviceName = RegisterWinService($serviceBin)

Start-Service -Name $serviceName -Verbose
