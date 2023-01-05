import-module au
$releases = 'http://www.klinzmann.name/licensecrawler_download.htm'

function global:au_SearchReplace {
    @{
       '.\tools\chocolateyInstall.ps1' = @{
            '(?i)(\s*\$url\s+=\s+'')[^'']+' = "`${1}$($Latest.URL32)"
            '(?i)(-Checksum\s+'')[^'']*'    = "`${1}$($Latest.Checksum32)"
        }
     }
}

function global:au_GetLatest {

    $downloadPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $version = [regex]::Match($DownloadPage.RawContent,'(?<=Last Version:\s*)\d+\.\d+(?:\s*build-)\d+').Value
    $version = [regex]::Replace($version,'\s*build-','.')
    # unversioned url
    $url32 = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match 'licensecrawler\.zip' } `
    | Select-Object -First 1

    
    
    
    @{ URL32 = "http://www.klinzmann.name/$url32"; Version = $version ; ChecksumType32 = 'sha256' }
}

update-package -ChecksumFor 32  # do not call chocolateyInstall to genereate checksum