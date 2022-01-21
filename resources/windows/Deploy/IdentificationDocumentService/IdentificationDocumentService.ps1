Import-module '.\scripts\sideFunctions.psm1'

$DownloadFolderPath = "C:\DownloadsCPS"
$ConfigFilePath = "C:\Services\IdentificationDocumentService\IdentificationDocumentService.exe.config"

# Проверяем наличие каталога для загрузки документов
Write-Host -ForegroundColor Green "[INFO] Check if $DownloadFolderPath exists..."
if (-Not (Test-Path $DownloadFolderPath)) {
    Write-Host -ForegroundColor Green "[INFO] Folder $DownloadFolderPath does not exist. Create..."
    New-Item -ItemType Directory -Path $DownloadFolderPath
}

# Правим конфиг
Write-Host -ForegroundColor Green "[INFO] Edit config IdentificationServiceCPS $ConfigFilePath ..."

[xml]$conf = (Get-Content -Path $ConfigFilePath -Encoding utf8)

($conf.configuration.appSettings.add | Where-Object key -eq "BaseAddress").SetAttribute("value","http://localhost:8123")
($conf.configuration.appSettings.add | Where-Object key -eq "UploadFolder" ).SetAttribute("value","C:\DownloadsCPS")
($conf.configuration.appSettings.add | Where-Object key -eq "SQLServerComFilesPath").SetAttribute("value","C:\DownloadsCPS")
($conf.configuration.appSettings.add | Where-Object key -eq "SQLServerCpsFilesPath" ).SetAttribute("value","C:\DownloadsCPS")
($conf.configuration.log4net.appender | Where-Object name -eq "GlobalLogFileAppender" ).file.SetAttribute("value","C:\Logs\IdentificationDocumentService\")

$conf.Save($ConfigFilePath)

Write-Host -ForegroundColor Green "[INFO] IdentificationService deployed"

$reportVal =@"
[IdentificationDocumentService]
$ConfigFilePath
    configuration.appSettings.add | Where-Object key -eq "BaseAddress").SetAttribute("value","http://localhost:8123")
    configuration.appSettings.add | Where-Object key -eq "UploadFolder" ).SetAttribute("value","C:\DownloadsCPS")
    configuration.appSettings.add | Where-Object key -eq "SQLServerComFilesPath").SetAttribute("value","C:\DownloadsCPS")
    configuration.appSettings.add | Where-Object key -eq "SQLServerCpsFilesPath" ).SetAttribute("value","C:\DownloadsCPS")
    configuration.log4net.appender | Where-Object name -eq "GlobalLogFileAppender" ).file.SetAttribute("value","C:\Logs\IdentificationDocumentService\")
"@

Add-Content -force -Path "$($env:WORKSPACE)\$($env:CONFIG_UPDATES)" -value $reportVal -Encoding utf8
