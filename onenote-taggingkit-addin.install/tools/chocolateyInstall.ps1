$packageName   = 'onenote-taggingkit-addin.install'
$url           = 'https://github.com/WetHat/OnenoteTaggingKit/releases/download/v3.4/SetupTaggingKitWiX.3.4.6897.30653.msi'
$silentArgs    = '/qn' 
$validExitCodes = @(0) 

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       '953B2A7FF8CE3FC3422887CF5E0BD0E916E39130CAC89B86EAE18A259F5DFFA3' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes