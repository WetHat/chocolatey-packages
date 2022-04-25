$packageName   = 'onenote-taggingkit-addin.install'
$url           = 'https://github.com/WetHat/OnenoteTaggingKit/releases/download/v4.0.81500/SetupTaggingKitWiX.4.0.81500.15722.msi'
$silentArgs    = '/qn' 
$validExitCodes = @(0,1603) 

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       '9350067a7b98eece63d24e46ffa60fcb648ab7059ff66eb905404a4c99fd2376' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
