import-module au
$releases = 'http://www.aezay.dk/aezay/ssdz/'

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
    | Where-Object { $_ -match 'SSD-Z_[\d.]+.*\.zip' } `
    | Select-Object -First 1

    # the url looks like '/java-decompiler/jd-gui/releases/download/v1.6.3/jd-gui-1.6.3.jar'
    $file = $url32 -split '/' | Select-Object -Last 1 

    $version = [regex]::Match($file,'[\d.]+').value.trim('.')
    
    @{ URL32 = "http://www.aezay.dk/aezay/ssdz/$url32"; Version = $version ; ChecksumType32 = 'sha256' }
}

update-package -ChecksumFor none -NoCheckUrl # do not call chocolateyInstall to genereate checksum