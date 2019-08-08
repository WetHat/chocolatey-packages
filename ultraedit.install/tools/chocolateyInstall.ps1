$packageName    = 'ultraedit.install'
$url            = 'https://downloads.ultraedit.com/main/ue/win/ue_english.msi' # download url
$url64          = 'https://downloads.ultraedit.com/main/ue/win/ue_english_64.msi' # download url
$silentArgs     = '/qn /norestart'
$validExitCodes = @(0)

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Url64          $url64 `
                          -Checksum       '6EE1730F6C79298FF1AA6CFB01A525E570F16BDF357C3B04420B23DF57821F12' `
                          -Checksum64     'B203D3E2B7B654B5836E1D452A06FBF3352B319429E2199B3AAFF2687DDBF109' `
                          -ChecksumType   'sha256' `
                          -ChecksumType64 'sha256' `
                          -validExitCodes $validExitCodes
