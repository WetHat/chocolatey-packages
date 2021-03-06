import-module au
$releases = 'https://github.com/java-decompiler/jd-gui/releases'

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

    $url32 = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match '\d\.jar' } `
    | Select-Object -First 1

    # the url looks like '/java-decompiler/jd-gui/releases/download/v1.6.3/jd-gui-1.6.3.jar'
    $file = $url32 -split '/' | Select-Object -Last 1 

    $version = [regex]::Match($file,'[\d.]+').value.trim('.')
    
    @{ URL32 = "https://github.com$url32"; Version = $version ; ChecksumType32 = 'sha256' }
}

update-package -ChecksumFor none # do not call chocolateyInstall to genereate checksum