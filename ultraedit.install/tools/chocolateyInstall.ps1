$packageName    = 'ultraedit.install.24.00'
$url            = 'https://downloads.ultraedit.com/main/ue/win/ue_english.msi' # download url
$silentArgs     = '/qn /norestart'
$validExitCodes = @(0)

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       'E6C5358F6A9F02FC1934A624F5916B88DF1B014780FC7AB09B0685680C5B97CD' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
