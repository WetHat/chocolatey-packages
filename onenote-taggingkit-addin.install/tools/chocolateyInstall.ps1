$packageName   = 'onenote-taggingkit-addin.install'
$url           = 'http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=onenotetaggingkit&DownloadId=1638246&FileTime=131317915738630000'
$silentArgs    = '/qn /norestart'
$validExitCodes = @(0)

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'         `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       '97242E82194BB5E2A2690CBDAC9D50B8B97884151D1A016FD60FAD5F1587120C' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
