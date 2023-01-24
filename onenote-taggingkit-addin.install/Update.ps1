import-module au
$releases = 'https://github.com/WetHat/OnenoteTaggingKit/releases/latest'

function global:au_SearchReplace {
    @{
       '.\tools\chocolateyInstall.ps1' = @{
            '(?i)(\s*\$url\s+=\s+'')[^'']+' = "`${1}$($Latest.URL32)"
            '(?i)(-Checksum\s+'')[^'']*'    = "`${1}$($Latest.Checksum32)"
        }
     }
}

function global:au_GetLatest {

    $latest = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $self = $latest.links `
    | ForEach-Object { $_.href } `
    | Where-Object { $_ -like '*/tag/v*' } `
    | Select-Object -First 1

    # the url looks like '/WetHat/OnenoteTaggingKit/releases/tag/v3.6'
    $version = [regex]::Match($self,'[\d.]+').value.trim('.')
    
    @{ URL32 = "https://github.com/WetHat/OnenoteTaggingKit/releases/download/v${version}/SetupTaggingKitWiX.${version}.msi"; Version = $version ; ChecksumType32 = 'sha256' }
}

update-package -ChecksumFor 32