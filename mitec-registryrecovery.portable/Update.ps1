import-module au
$releases = 'http://www.mitec.cz/'
$download = 'http://www.mitec.cz/Downloads'

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

    $version = [regex]::Match($releasesPage.RawContent,'(?<=MiTeC Windows Registry Recovery.*)\d\.[.\d]+').Value
    
    @{ URL32 = "$download/WRR.zip"; Version = $version ; ChecksumType32 = 'sha256' }
}

update-package -ChecksumFor 32  # do not call chocolateyInstall to genereate checksum