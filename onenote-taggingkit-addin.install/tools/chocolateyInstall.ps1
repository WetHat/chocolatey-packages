$packageName   = 'onenote-taggingkit-addin.install'
$url           = 'https://github.com/WetHat/OnenoteTaggingKit/releases/download/v4.0.81350/SetupTaggingKitWiX.4.0.81350.23044.msi'
$silentArgs    = '/qn' 
$validExitCodes = @(0,1603) 

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       '81cdad957caffd08b3d52a0dfddd983824211df89d0bbbe9aec1a57869241db3' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
