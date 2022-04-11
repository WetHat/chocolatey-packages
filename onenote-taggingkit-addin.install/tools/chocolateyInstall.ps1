$packageName   = 'onenote-taggingkit-addin.install'
$url           = 'https://github.com/WetHat/OnenoteTaggingKit/releases/download/v4.0.81360/SetupTaggingKitWiX.4.0.81360.38002.msi'
$silentArgs    = '/qn' 
$validExitCodes = @(0,1603) 

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       'fc929c93bc688705c0667f10e449dbf4390b55da0d10dca520b83524f540a75e' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
