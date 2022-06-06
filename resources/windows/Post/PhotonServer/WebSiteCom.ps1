$websiteComFolder = "C:\inetpub\WebSiteCom"

Write-Host -ForegroundColor Green "[INFO] Copy games"
$gamesDestFolder = Join-Path -Path $websiteComFolder -ChildPath "Scripts\Games"
if (!(Test-Path $gamesDestFolder)){ New-Item -Type Directory -Path $gamesDestFolder -Verbose }
Copy-Item `
    -Path "\\server\tcbuild$\BaltCasino\GaltonBoard\V18_prod\Client\RockClimberSlots_V1" `
    -Destination $gamesDestFolder `
    -Verbose 

[xml]$config = Get-Content -Encoding utf8 -Path "$($websiteComFolder)\Web.config"
$config.configuration.'casino-games'.enabled = "true"
$config.configuration.'casino-games'.SetAttribute("isDebugPhoton", "true")
$config.configuration.'casino-games'.games

$gamesFolder = Get-ChildItem -Path $gamesDestFolder -Directory
$counter = 0
foreach ($gameFolder in $gamesFolder) {
    $scriptUrls = Get-Item -Path "$($gamesFolder.FullName)\*" -Include "*.js"
    $jsonUrl = Get-Item -Path "$($gamesFolder.FullName)\*" -Include "*.json"
    $changeParams = @{
        "name"      = $gameFolder.Name
        "url"       = $gameFolder.Name
        "scriptUrl" = $scriptUrls.FullName 
        "jsonUrl"   = $jsonUrl.FullName
        "banner"    = $banner.FullName
        "title"    = $gameFolder.Name
    }
    
    # Проверяем, существует ли элемент в конфиге
    try { $config.configuration.'casino-games'.games.game[$counter].GetType() | Out-Null }
    catch {
        $node = $config.configuration.'casino-games'.games.LastChild.Clone()
        $config.configuration.'casino-games'.games.AppendChild($node)
    }

    # Подставляем значения для атрибутов
    foreach ($param in $changeParams.Keys) {
        $config.configuration.'casino-games'.games.game[$counter].$param = $changeParams.$param
    }

    $counter += 1
}
$scriptUrls = Get-Item -Path $gamesDestFolder


