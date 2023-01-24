$packageName   = 'onenote-taggingkit-addin.install'
$url           = 'https://github.com/WetHat/OnenoteTaggingKit/releases/download/v5.0.8424/SetupTaggingKitWiX.5.0.8424.msi'
$silentArgs    = '/qn' 
$validExitCodes = @(0,1603) 

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       '09257f0190a8634a9b7f3dbe48027b7ae3c83dfd365a1b4640d593e429a52f30' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
