$packageName   = 'onenote-taggingkit-addin.install'
$url           = 'https://github.com/WetHat/OnenoteTaggingKit/releases/download/v4.0.8132/SetupTaggingKitWiX.4.0.8132.30888.msi'
$silentArgs    = '/qn' 
$validExitCodes = @(0,1603) 

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       '31ae4b7287618efe64239130d5c3d0f32db8d8f09bdd962829c934ea8a9144e4' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
