$packageName   = 'onenote-taggingkit-addin.install'
$url           = 'https://github.com/WetHat/OnenoteTaggingKit/releases/download/v3.2/SetupTaggingKitWiX.3.2.6401.32978.msi'
$silentArgs    = '/qn' 
$validExitCodes = @(0) 

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       '902311369FADED39AF475CC881DA38F7A1C30F9EF1B6159815979DAE61E13D96' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes