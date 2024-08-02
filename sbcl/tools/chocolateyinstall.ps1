$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'MSI'
  url           = 'http://prdownloads.sourceforge.net/sbcl/sbcl-2.4.7-x86-64-windows-binary.msi'
  softwareName  = 'Steel Bank Common Lisp*'
  checksum      = '24ae4f4cde8d589ef05d5972381ae7f90a86cdf6f93d768982395cda95bffce9'
  checksumType  = 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
}

Install-ChocolateyPackage @packageArgs

$sbclhome = Join-Path ([environment]::GetFolderPath([environment+specialfolder]::ProgramFiles)) `
                      -ChildPath 'Steel Bank Common Lisp'

$target = Join-Path $sbclhome -ChildPath 'sbcl.exe'
$icon = Join-Path $toolsDir -ChildPath 'sbcl.ico'
$shortcut = Join-Path ([environment]::GetFolderPath([environment+specialfolder]::Programs)) -ChildPath 'sbcl.lnk'
Install-ChocolateyShortcut -ShortcutFilePath $shortcut `
                           -Targetpath $target `
                           -IconLocation $icon `
                           -WorkingDirectory ([environment]::GetFolderPath([environment+specialfolder]::UserProfile))`
                           -Description 'Steel Bank Common Lisp (SBCL)'

Install-ChocolateyEnvironmentVariable -variableName "SBCL_HOME" -variableValue $sbclhome -variableType 'Machine'

## Set up a file association
## - https://docs.chocolatey.org/en-us/create/functions/install-chocolateyfileassociation
#Install-ChocolateyFileAssociation

Install-BinFile -Name 'sbcl' -path $target
