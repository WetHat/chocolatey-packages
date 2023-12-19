import-module au
$releases = 'https://netbeans.apache.org/front/main/download/index.html'

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
        '.\apache-netbeans.portable.nuspec' = @{
            '(?<=<releaseNotes>)[^<>]+' = $Latest.ReleaseNotesURL
        }
     }
}

function global:au_GetLatest {

    $versionsPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

    # Find the download page for the latest version
    $downloadPageurl = $versionsPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match '/nb\d+$' } `
    | Select-Object -First 1 `


    # the url looks like: '/download/nb111/nb111.html'
    $downloadPage = Invoke-WebRequest -Uri "https://netbeans.apache.org/${downloadPageurl}" -UseBasicParsing

    # Find the release notes link
    $releaseNotesUrl = $versionsPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match 'nb\d+/$' } `
    | Select-Object -First 1


    # Find link to a page listing the mirrors that can be used to download that version
    $mirrorPageUrl = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match 'http.*-bin\.zip$' } `
    | Select-Object -First 1

    ## the url looks like: https://www.apache.org/dyn/closer.cgi/netbeans/netbeans/11.1/netbeans-11.1-bin.zip

    $file = $mirrorPageUrl -split '/' | Select-Object -Last 1
    [string]$version = [regex]::Match($file,'[\d.]+').value.trim('.')

    $url = "https://downloads.apache.org/netbeans/netbeans/${version}/netbeans-${version}-bin.zip"

    $chocoversion = $version

    # make sure the version is well formed
    if (!$version.Contains('.')) {
      $chocoversion = $version + '.0.0'
    }

    @{ URL32 = $url
       Version = $chocoversion
       ChecksumType32 = 'sha256'
       ReleaseNotesURL = "https://github.com/apache/netbeans/releases/tag/$version"
     }
}

update-package -ChecksumFor 32