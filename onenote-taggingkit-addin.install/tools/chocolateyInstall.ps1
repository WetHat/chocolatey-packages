$packageName   = 'onenote-taggingkit-addin.install'
$url           = 'https://github.com/WetHat/OnenoteTaggingKit/releases/download/v3.3/SetupTaggingKitWiX.3.3.6631.38362.msi'
$silentArgs    = '/qn' 
$validExitCodes = @(0) 

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       'DFA08400711D6857982B0F0C397D340705E4232CCE75A2C7E8CEE7D268C34CA0' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes