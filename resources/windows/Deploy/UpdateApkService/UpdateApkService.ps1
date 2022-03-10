Write-Host -ForegroundColor Green "[INFO] Deploy UpdateApkService..."

$ApkCacheFolder = "C:\ApkCacheFolder"
$configFile = "C:\Services\UpdateApk\UpdateApkService\Web.config"

# Прверяем существует ли директория, если нет - создаем
if(Test-Path -Path $ApkCacheFolder) {
    Write-Host -ForegroundColor Green "[INFO] $ApkCacheFolder exists..."
} else {
    Write-Host -ForegroundColor Green "[INFO] $ApkCacheFolder does not exist. Ctreate folder..."
    New-Item -Path $ApkCacheFolder -ItemType Directory
}

# Правим конфиг
$config = [xml](Get-Content -Path $configFile -Encoding utf8)
Write-Host -ForegroundColor Green "[INFO] Change ApkCacheFolder.value to $ApkCacheFolder "
($config.configuration.appSettings.add | Where-Object key -eq "apkCacheFolder").value = "$ApkCacheFolder"
$config.Save($configFile)
