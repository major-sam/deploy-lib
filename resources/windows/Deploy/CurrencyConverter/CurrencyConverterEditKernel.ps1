$configFile = "C:\Kernel\settings.xml"
$ccGrpcPort = 50004


$ifKernekConfigExist = (Test-Path -Path $configFile)

$config = [xml](Get-Content -Path $configFile -Encoding utf8)

$PaymentConverter = ($config.Settings.PaymentConverterSettings | Where-Object serverAddress -ne $null) | Out-Null

if($ifKernekConfigExist) {
    Write-Host -ForegroundColor Green "[INFO] ${configFile} exists."
    if($PaymentConverter) {
        Write-Host -ForegroundColor Green "[INFO] Edit PaymentConverterSettings.serverAddress in ${configFile}."
        $config.Settings.PaymentConverterSettings.serverAddress = "localhost:${ccGrpcPort}"
        $config.Save($configFile)
    } else {
        Write-Host -ForegroundColor Green "[INFO] Add PaymentConverterSettings to ${configFile}"
        $PaymentConverterSettings = $config.CreateElement("PaymentConverterSettings")
        $PaymentConverterSettings.SetAttribute("serverAddress","localhost:${ccGrpcPort}")
        $PaymentConverterSettings.SetAttribute("channelPoolSize","4")
        $config.Settings.AppendChild($PaymentConverterSettings)
        $config.Save($configFile)
    }
} else {
    Write-Host -ForegroundColor Green "[WARN] ${configFile} does not exist."
}