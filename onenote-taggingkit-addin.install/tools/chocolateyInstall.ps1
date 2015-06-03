$packageName   = 'onenote-taggingkit-addin.install'
$installerType = 'MSI' #only one of these: exe, msi, msu
$url           = 'http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=onenotetaggingkit&DownloadId=1459876&FileTime=130778237038200000'
$silentArgs    = '/qn' 
$validExitCodes = @(0) #please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx

# main helpers - these have error handling tucked into them already
# installer, will assert administrative rights

# if removing $url64, please remove from here
Install-ChocolateyPackage $packageName $installerType $silentArgs "$url" -validExitCodes $validExitCodes