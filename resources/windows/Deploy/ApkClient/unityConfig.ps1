$unityConfig = "C:\ApkClient\UnityConfig.config"
$xmlconfig = [Xml](Get-Content $unityConfig)

$register =  $xmlconfig.unity.container.register | Where-Object type -eq "CashSystem.Apk.BetFiscalization.Interfaces.IFiscalizationService, CashSystem.Apk"
$register.constructor.param | % { if ($_.name -eq "isFiscal") { $_.value = "True" }}
$xmlconfig.Save($unityConfig)