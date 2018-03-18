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
                          -Checksum64     '4382B05BBBB15BF97DBE27016BAF8615B8A0E478F3AD0EDDBD5F5933E957339D' `
                          -ChecksumType   'sha256' `
                          -ChecksumType64 'sha256' `
                          -validExitCodes $validExitCodes
