import-module au
$releases = 'http://www.sbcl.org/platform-table.html'

function global:au_SearchReplace {
    @{
       '.\tools\chocolateyInstall.ps1' = @{
            '(?i)(\s*url64\s*=\s*'')[^'']+'  = "`${1}$($Latest.URL64)"
            '(?i)(checksum64\s*=\s*'')[^'']*' = "`${1}$($Latest.Checksum64)"
        }
     }
}

function global:au_BeforeUpdate() {
     $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64
  }

function global:au_GetLatest {

    $downloadPage = Invoke-WebRequest -Uri $releases

    # unversioned url
    $url64 = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -like '*64-windows-binary.msi' } `
    | Select-Object -First 1

    $version = [regex]::Match($DownloadPage.RawContent,'(?<=sbcl-)\d+\.\d+\.\d+').Value
    
    @{ URL64 = $url64; Version = $version ; ChecksumType64 = 'sha256' }
}

update-package -ChecksumFor 64  # do not call chocolateyInstall to genereate checksum