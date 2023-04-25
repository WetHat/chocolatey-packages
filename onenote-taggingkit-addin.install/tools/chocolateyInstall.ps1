$packageName   = 'onenote-taggingkit-addin.install'
$url           = 'https://github.com/WetHat/OnenoteTaggingKit/releases/download/v5.1.8514/SetupTaggingKitWiX.5.1.8514.msi'
$silentArgs    = '/qn' 
$validExitCodes = @(0,1603) 

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       'f36d206b350d90c540cbe5e84572aedb84794a6fa537a4e469c4a66f3875a110' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
