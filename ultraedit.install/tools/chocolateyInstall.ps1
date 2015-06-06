$packageName    = 'ultraedit.install'
$installerType  = 'MSI' #only one of these: exe, msi, msu
$url            = 'http://www.ultraedit.com/files/msii/ue_english.msi' # download url
$silentArgs     = '/qn /norestart'
$validExitCodes = @(0) 
$installlocation= Split-Path -parent $MyInvocation.MyCommand.Definition

Install-ChocolateyPackage $packageName $installerType $silentArgs $url  -validExitCodes $validExitCodes
