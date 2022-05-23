$serviceName = "WidgetService"
$targetDir = "C:\Services\BaltWidgets\${serviceName}"
$wsXmlfile = "C:\Services\BaltWidgets\WidgetService\Widget.Service.xml"

$xml_temp = @"
<?xml version="1.0"?>
<doc>
    <assembly>
        <name>Widget.Service</name>
    </assembly>
    <members>
    </members>
</doc>
"@

if (Test-path($targetDir)) {
    if (!(Test-path($wsXmlfile))) {
        Write-host "[INFO] $wsXmlfile does not exist. Creating..."
        $xml_temp | Set-Content $wsXmlfile -Encoding UTF8
    } else {
        Write-host "[INFO] $wsXmlfile exists."
    }   
}