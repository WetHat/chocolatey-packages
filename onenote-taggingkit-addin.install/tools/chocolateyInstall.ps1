$packageName   = 'onenote-taggingkit-addin.install'
$url           = 'https://github.com/WetHat/OnenoteTaggingKit/releases/download/v5.1.8437/SetupTaggingKitWiX.5.1.8437.msi'
$silentArgs    = '/qn' 
$validExitCodes = @(0,1603) 

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       'efd8b2e67e270e54464ddbc4e2dd493ca1741b8cb801560f0e858286ff48d0ad' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
