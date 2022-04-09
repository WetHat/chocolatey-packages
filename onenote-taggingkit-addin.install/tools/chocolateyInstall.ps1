$packageName   = 'onenote-taggingkit-addin.install'
$url           = 'https://github.com/WetHat/OnenoteTaggingKit/releases/download/v4.0.30319/SetupTaggingKitWiX.4.0.30319.42000.msi'
$silentArgs    = '/qn' 
$validExitCodes = @(0,1603) 

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       '8d387e89d225e6ac1de8af1fd059caf2df6ba25bd9ff08f963f94137adb688f8' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
