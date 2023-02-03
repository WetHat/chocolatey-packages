$packageName   = 'onenote-taggingkit-addin.install'
$url           = 'https://github.com/WetHat/OnenoteTaggingKit/releases/download/v5.1.8434/SetupTaggingKitWiX.5.1.8434.msi'
$silentArgs    = '/qn' 
$validExitCodes = @(0,1603) 

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       '9b5f9992cab2c5a4c5f838480332453fedf4d938cefc8002ec03178b654e2500' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
