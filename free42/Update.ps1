import-module au
$releases = 'https://thomasokken.com/free42'

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

    # unversioned url
    $url32 = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match 'Free42Windows\.zip' } `
    | Select-Object -First 1

    $version = [regex]::Match($DownloadPage.RawContent,'(?<=<b>)\d+\.\d+\.\d+[a-z]*(?=</b> for A)').Value
    
    $version = [regex]::Replace($version,'a$','.1')
    @{ URL32 = "https://thomasokken.com/free42/$url32"; Version = $version ; ChecksumType32 = 'sha256' }
}

update-package -ChecksumFor 32  # do not call chocolateyInstall to genereate checksum