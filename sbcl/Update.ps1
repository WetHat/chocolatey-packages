import-module au
$releases = 'http://www.sbcl.org/platform-table.html'

function global:au_SearchReplace {
    @{
       '.\tools\chocolateyInstall.ps1' = @{
            '(?i)(\s*url\s*=\s*'')[^'']+'  = "`${1}$($Latest.URL64)"
            '(?i)(checksum\s*=\s*'')[^'']*' = "`${1}$($Latest.Checksum64)"
        }
     }
}

function global:au_GetLatest {

    $downloadPage = Invoke-WebRequest -Uri $releases

    $url = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -like '*64-windows-binary.msi' } `
    | Select-Object -First 1

    $version = [regex]::Match($DownloadPage.RawContent,'(?<=sbcl-)\d+\.\d+\.\d+').Value
    
    @{ URL64 = $url; Version = $version ; ChecksumType64 = 'sha256' }
}

update-package -ChecksumFor 64