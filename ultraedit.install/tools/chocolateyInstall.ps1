﻿$packageName    = 'ultraedit.install.23.10'
$installerType  = 'MSI' #only one of these: exe, msi, msu
$url            = 'http://www.ultraedit.com/files/msii/ue_english.msi' # download url
$silentArgs     = '/qn /norestart'
$validExitCodes = @(0)
$installlocation= Split-Path -parent $MyInvocation.MyCommand.Definition

## Make sure new installer is cached by adding version
Install-ChocolateyPackage $packageName $installerType $silentArgs $url  -validExitCodes $validExitCodes
