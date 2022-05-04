import-module '.\scripts\sideFunctions.psm1'

[xml]$kernelSettings = Get-Content -Encoding UTF8 -Path "C:\Kernel\Settings.xml"
$kernelSettings.Settings.PushNotificationSettings.IsBetsEnabled = 'true'
$kernelSettings.Save("C:\Kernel\Settings.xml")

$AchievementServiceFolder = "C:\Services\AchievementService\"
RegisterWinService("$($AchievementServiceFolder)\BaltBet.AchievementService.Host.exe")