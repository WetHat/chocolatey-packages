$packageName    = 'ultraedit.install'
$url            = 'https://downloads.ultraedit.com/main/ue/win/ue_english.msi' # download url
$silentArgs     = '/qn /norestart'
$validExitCodes = @(0)

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       '69B5242327C2B308156EC439439EE3C2119B84927EE628084FDED54F2CDD1DEB' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
