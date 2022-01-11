<#
В deploy.json добавить следующий блок:
{
    "name": "IdentificationDocumentService",
    "source": ".\\scripts\\deploy\\IdentificationDocumentService.ps1"
    "deployDir": "c:\\Services\\"
}
#>

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

$BaseAddress = $conf.configuration.appSettings.add | Where-Object key -eq "BaseAddress"
$BaseAddress.SetAttribute("value","http://localhost:8123")

$UploadFolder = $conf.configuration.appSettings.add | Where-Object key -eq "UploadFolder"
$UploadFolder.SetAttribute("value","C:\DownloadsCPS")

$SQLServerComFilesPath = $conf.configuration.appSettings.add | Where-Object key -eq "SQLServerComFilesPath"
$SQLServerComFilesPath.SetAttribute("value","C:\DownloadsCPS")

$SQLServerCpsFilesPath = $conf.configuration.appSettings.add | Where-Object key -eq "SQLServerCpsFilesPath"
$SQLServerCpsFilesPath.SetAttribute("value","C:\DownloadsCPS")

$GlobalLog = $conf.configuration.log4net.appender | Where-Object name -eq "GlobalLogFileAppender"
$GlobalLog.file.SetAttribute("value","C:\Logs\IdentificationDocumentService\")

$conf.Save($ConfigFilePath)

Write-Host -ForegroundColor Green "[INFO] IdentificationService deployed"