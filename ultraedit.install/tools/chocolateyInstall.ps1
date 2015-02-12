$packageName    = 'ultraedit.install'
$installerType  = 'MSI' #only one of these: exe, msi, msu
$url            = 'http://www.ultraedit.com/files/msii/ue_english.msi' # download url
$silentArgs     = '/qn' # "/s /S /q /Q /quiet /silent /SILENT /VERYSILENT" # try any of these to get the silent installer #msi is always /quiet
$validExitCodes = @(0) #please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx
$installlocation= Split-Path -parent $MyInvocation.MyCommand.Definition
# main helpers - these have error handling tucked into them already
# installer, will assert administrative rights

# if removing $url64, please remove from here
Install-ChocolateyPackage $packageName $installerType $silentArgs $url  -validExitCodes $validExitCodes
