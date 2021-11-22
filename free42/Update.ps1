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

function global:au_BeforeUpdate() {
     $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
  }

function global:au_GetLatest {

    $downloadPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

    # unversioned url
    $url32 = 'https://thomasokken.com/free42/download/Free42Windows.zip' `

    $version = [regex]::Match($DownloadPage.RawContent,'(?<=<b>)\d+\.\d+\.\d+').Value
    
    @{ URL32 = "$url32"; Version = $version ; ChecksumType32 = 'sha256' }
}

update-package -ChecksumFor none -NoCheckUrl # do not call chocolateyInstall to genereate checksum