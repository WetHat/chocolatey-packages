import-module au
$releases = 'http://netbeans.apache.org/download/index.html'
$mirror = 'http://mirror.netcologne.de/apache.org'

function Test-Url([string] $Url)
{
    try
    {
        $statusCode = (Invoke-WebRequest -Uri $Url -UseBasicParsing -DisableKeepAlive -Method Head).StatusCode
    }
    catch [Net.WebException]
    {
        $statusCode = [int]$_.Exception.Response.StatusCode
    }

    return $StatusCode -eq 200
}

function global:au_SearchReplace {
    @{
       '.\tools\chocolateyInstall.ps1' = @{
            '(?i)(\s*\$url\s+=\s+'')[^'']+' = "`${1}$($Latest.URL32)"
            '(?i)(-Checksum\s+'')[^'']*'    = "`${1}$($Latest.Checksum32)"
        }
     }
}

function global:au_GetLatest {

    $versionsPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

    # Find the download page for the latest version
    $downloadPageurl = $versionsPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match 'nb\d+\.html$' } `
    | Select-Object -First 1
   
    # the url looks like: '/download/nb111/nb111.html'
    $downloadPage = Invoke-WebRequest -Uri "http://netbeans.apache.org${downloadPageurl}" -UseBasicParsing
    
    # Find link to a page listing the mirrors that can be used to download that version 
    $mirrorPageUrl = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match 'http.*-bin\.zip$' } `
    | Select-Object -First 1
    
    ## the url looks like: https://www.apache.org/dyn/closer.cgi/netbeans/netbeans/11.1/netbeans-11.1-bin.zip
    $mirrorsPage =  Invoke-WebRequest -Uri $mirrorPageUrl -UseBasicParsing 

    # Get the first life url from the list of mirrors.
    $url32 = $mirrorsPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match 'http.*-bin\.zip$' -and (Test-Url $_) } `
    | Select-Object -First 1
    
    # The url looks like: http://mirror.netcologne.de/apache.org/netbeans/netbeans/11.1/netbeans-11.1-bin.zip

    $file = $url32 -split '/' | Select-Object -Last 1
    $version = [regex]::Match($file,'[\d.]+').value.trim('.')
   
    @{ URL32 = $url32; Version = $version ; ChecksumType32 = 'sha256' }
}

update-package -ChecksumFor 32