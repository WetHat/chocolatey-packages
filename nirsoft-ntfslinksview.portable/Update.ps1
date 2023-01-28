import-module au
$releases = 'https://www.nirsoft.net/utils/ntfs_links_view.html'

function global:au_SearchReplace {
    @{
       '.\tools\chocolateyInstall.ps1' = @{
            '(?i)(\s*\$url\s+=\s+'')[^'']+'      = "`${1}$($Latest.URL32)"
            '(?i)(-Checksum\s+'')[^'']*'         = "`${1}$($Latest.Checksum32)"
            '(?i)(\s*\$url64Bit\s+=\s+'')[^'']+' = "`${1}$($Latest.URL64)"
            '(?i)(-Checksum64\sb'')[^'']*'       = "`${1}$($Latest.Checksum64)"
        }
     }
}

function global:au_GetLatest {

    $downloadPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $version = [regex]::Match($DownloadPage.RawContent,'(?<=NTFSLinksView\s*v\s*)\d+[.\d]+').Value
    # unversioned url
    
    $url32 = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match 'ntfslinkview\.zip' } `
    | Select-Object -First 1

    $url32 = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match 'ntfslinkview-64\.zip' } `
    | Select-Object -First 1
    
    @{ 
        URL32 = "https://www.nirsoft.net/utils/$url32"
        ChecksumType32 = 'sha256'
        URL64 = "https://www.nirsoft.net/utils/$url64"
        ChecksumType64 = 'sha256'
        Version = $version }
}

update-package -ChecksumFor 32  # do not call chocolateyInstall to genereate checksum