import-module au
$releases = 'https://github.com/corvideon/InstantWP/releases'

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

    $url32 = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -like '*-Win.zip' } `
    | Select-Object -First 1

    # the url looks like '/corvideon/InstantWP/releases/download/v5.3.6/IWP-v5.3.6-Win.zip'
    $file = $url32 -split '/' | Select-Object -Last 1

    $version = [regex]::Match($file,'[\d.]+').value.trim('.')

    @{ URL32 = "https://github.com$url32"; Version = $version ; ChecksumType32 = 'sha256' }
}

update-package -ChecksumFor 32