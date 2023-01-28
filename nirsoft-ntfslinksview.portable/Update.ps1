import-module au
$releases = 'https://www.nirsoft.net/utils/ntfs_links_view.html'

function global:au_SearchReplace {
    @{
       '.\tools\chocolateyInstall.ps1' = @{
            '(?i)(\s*\$url32\s*=\s*'')[^'']+' = "`${1}$($Latest.URL32)" 
            '(?i)(\s*\$url64\s*=\s*'')[^'']+' = "`${1}$($Latest.URL64)"
            '(?i)(-Checksum\s*'')[^'']*'      = "`${1}$($Latest.Checksum32)"
            '(?i)(-Checksum64\s*'')[^'']*'    = "`${1}$($Latest.Checksum64)"
        }
     }
}

function global:au_GetLatest {

    $downloadPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $version = [regex]::Match($DownloadPage.RawContent,'(?<=NTFSLinksView\s*v\s*)\d+[.\d]+').Value
    # unversioned url
    
    $url32 = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match 'ntfslinksview\.zip' } `
    | Select-Object -First 1

    $url64 = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match 'ntfslinksview-x64\.zip' } `
    | Select-Object -First 1
    
    @{ 
        URL32 = "https://www.nirsoft.net/utils/$url32"
        ChecksumType32 = 'sha256'
        URL64 = "https://www.nirsoft.net/utils/$url64"
        ChecksumType64 = 'sha256'
        Version = $version }
}

update-package -ChecksumFor all  # do not call chocolateyInstall to genereate checksum