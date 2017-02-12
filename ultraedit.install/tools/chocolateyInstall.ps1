$packageName    = 'ultraedit.install.24.00'
$url            = 'http://www.ultraedit.com/files/msii/ue_english.msi' # download url
$silentArgs     = '/qn /norestart'
$validExitCodes = @(0)

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       '957CBC24854C359FA0A41E00064DA41E0EAB25E0A8D5DD67C6D4B310D2A89ADD' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
