$packageName   = 'onenote-taggingkit-addin.install'
$installerType = 'MSI'
$url           = 'http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=onenotetaggingkit&DownloadId=1459876&FileTime=130778237038200000'
$silentArgs    = '/qn /norestart' 
$validExitCodes = @(0)
Install-ChocolateyPackage $packageName $installerType $silentArgs "$url" -validExitCodes $validExitCodes