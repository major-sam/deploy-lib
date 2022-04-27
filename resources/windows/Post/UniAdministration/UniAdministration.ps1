Import-module '.\scripts\sideFunctions.psm1'

#get release params
###vars
$targetDir = "C:\inetpub\ClientWorkPlace\UniRu"
$webConfig = "$targetDir\Web.config"
$dbname = "UniAdministration"

###
#XML values replace UniRu
####
Write-Host -ForegroundColor Green "[INFO] Edit web.config of $webConfig"
$webdoc = [Xml](Get-Content $webConfig)
($webdoc.configuration.connectionStrings.add | where {
	$_.name -eq 'AdministrationContext' 
	}).connectionString = "data source=localhost;initial catalog=${dbname};Integrated Security=true;MultipleActiveResultSets=True;"


$webdoc.Save($webConfig)

Write-Host -ForegroundColor Green "[INFO] Done"
