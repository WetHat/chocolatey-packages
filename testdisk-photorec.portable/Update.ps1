import-module au
$releases = 'https://www.cgsecurity.org/wiki/TestDisk_Download'

function global:au_SearchReplace {
    @{
       '.\tools\chocolateyInstall.ps1' = @{
            '(?i)(\s*\$url\s+=\s+'')[^'']+'   = "`${1}$($Latest.URL32)"
            '(?i)(\s*\$url64\s+=\s+'')[^'']+' = "`${1}$($Latest.URL64)"
            '(?i)(-Checksum\s+'')[^'']*'      = "`${1}$($Latest.Checksum32)"
            '(?i)(-Checksum64\s+'')[^'']*'    = "`${1}$($Latest.Checksum32)"
        }
        '.\testdisk-photorec.portable.nuspec' = @{
            '(<releaseNotes>.*TestDisk_)[\d.]+(_Release</releaseNotes>)' = "`${1}$($Latest.Version)`${2}"
        }
     }
}

function global:au_BeforeUpdate() {
     $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
     $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64
  }

function global:au_GetLatest {

    $downloadPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $url32 = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match '-[\d.]+win\.zip' } `
    | Select-Object -First 1

    $url64 = $downloadPage.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -match '-[\d.]+win64\.zip' } `
    | Select-Object -First 1

    # the url looks like 'https://www.cgsecurity.org/Download_and_donate.php/testdisk-7.1.win.zip'
    $file32 = $url32 -split '/' | Select-Object -Last 1 
    $file64 = $url64 -split '/' | Select-Object -Last 1

    $version = [regex]::Match($file32,'([\d.]+)(?=\.win)').value.trim('.')
    
    @{ URL32 = "https://www.cgsecurity.org/$file32"
       URL64 = "https://www.cgsecurity.org/$file64"
       Version = $version
       ChecksumType32 = 'sha256'
       ChecksumType64 = 'sha256' }
}

update-package -ChecksumFor none # do not call chocolateyInstall to genereate checksum