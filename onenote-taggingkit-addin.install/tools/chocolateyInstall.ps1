$packageName   = 'onenote-taggingkit-addin.install'
$url           = 'https://github.com/WetHat/OnenoteTaggingKit/releases/download/v5.0.8427/SetupTaggingKitWiX.5.0.8427.msi'
$silentArgs    = '/qn' 
$validExitCodes = @(0,1603) 

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       'e2696801c3133152ce1e59551c0e12a2e776b1e7543d2e05044153b2841bb780' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
