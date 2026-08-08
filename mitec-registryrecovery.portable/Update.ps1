import-module au
$releases = 'https://www.mitec.cz/wp/mwrr/'
$download = 'https://www.mitec.cz/wp/files'

function global:au_SearchReplace {
    @{
       '.\tools\chocolateyInstall.ps1' = @{
            '(?i)(\s*\$url\s+=\s+'')[^'']+' = "`${1}$($Latest.URL32)"
            '(?i)(-Checksum\s+'')[^'']*'    = "`${1}$($Latest.Checksum32)"
        }
     }
}

function global:au_GetLatest {
    $releasesPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $version = [regex]::Match($releasesPage.RawContent,'(?<=Version History.*?)*\d\.[.\d]+').Value
    @{ URL32 = "$download/WRR.zip"; Version = $version ; ChecksumType32 = 'sha256' }
}

update-package -ChecksumFor 32  # do not call chocolateyInstall to genereate checksum