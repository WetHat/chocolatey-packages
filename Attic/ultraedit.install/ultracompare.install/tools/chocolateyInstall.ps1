﻿$packageName    = 'ultracompare.install'
$installerType  = 'MSI' #only one of these: exe, msi, msu
$url            = 'https://downloads.ultraedit.com/main/uc/win/uc_english.msi' # download 
$url64          = 'https://downloads.ultraedit.com/main/uc/win/uc_english_64.msi' # download url
$silentArgs     = '/qn /norestart'
$validExitCodes = @(0)
$installlocation= Split-Path -parent $MyInvocation.MyCommand.Definition

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Url64          $url64 `
                          -Checksum       'B96EDC4DA9140C4EEE6D761085CDC8DA64A962CA08581594A8FB4AC8F13CDF79' `
                          -Checksum64     '9A7F76140F5DC608E2F3C6D779542B757B1C0ABF011A19379182EA81BA51723B' `
                          -ChecksumType   'sha256' `
                          -ChecksumType64 'sha256' `
                          -validExitCodes $validExitCodes
