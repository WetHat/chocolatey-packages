$packageName   = 'onenote-taggingkit-addin.install'
$installerType = 'MSI'
$url           = 'http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=onenotetaggingkit&DownloadId=1475008&FileTime=130821078494000000'
$silentArgs    = '/qn /norestart'
$validExitCodes = @(0)
Install-ChocolateyPackage $packageName $installerType $silentArgs "$url" -validExitCodes $validExitCodes
