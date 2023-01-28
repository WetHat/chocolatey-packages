import-module au
$releases = 'https://github.com/java-decompiler/jd-gui/releases/latest'

function global:au_SearchReplace {
    @{
       '.\tools\chocolateyInstall.ps1' = @{
            '(?i)(\s*\$url\s+=\s+'')[^'']+' = "`${1}$($Latest.URL32)"
            '(?i)(-Checksum\s+'')[^'']*'    = "`${1}$($Latest.Checksum32)"
        }
     }
}

function global:au_BeforeUpdate() {
     $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
  }

function global:au_GetLatest {

    $downloadPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $latest = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match '/tag/v\d' } `
    | Select-Object -First 1

    # the url looks like '/java-decompiler/jd-gui/releases/tag/v1.6.6'

    $version = [regex]::Match($latest,'[\d.]+').value.trim('.')


    @{ URL32 = "https://github.com/java-decompiler/jd-gui/releases/download/v${version}/jd-gui-${version}.jar"; Version = $version ; ChecksumType32 = 'sha256' }
}

update-package -ChecksumFor none # do not call chocolateyInstall to genereate checksum