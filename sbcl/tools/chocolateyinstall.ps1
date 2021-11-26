$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'MSI' #only one of these: exe, msi, msu
  url64         = 'http://prdownloads.sourceforge.net/sbcl/sbcl-2.1.10-x86-64-windows-binary.msi'
  softwareName  = 'Steel Bank Common Lisp'
  checksum64    = 'e4e7cb3d9b49d01038b67e5272d5477a427154979d7731227d5204f7c720550c'
  checksumType  = 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
}

Install-ChocolateyPackage @packageArgs 

$sbclhome = Join-Path [environment]::GetFolderPath([environment+specialfolder]::ProgramFiles) -ChildPath

$target = Join-Path $sbclhome "sbcl.exe"
$icon = Join-Path $toolsDir "sbcl.ico"
$shortcut = Join-Path [environment]::GetFolderPath([environment+specialfolder]::Programs) 'sbcl'
Install-ChocolateyShortcut -ShortcutFilePath $shortcut `
                           -Targetpath $target `
                           -IconLocation $icon `
                        -WorkingDirectory [environment]::GetFolderPath([environment+specialfolder]::UserProfile)`
                           -Description 'Steel Bank Common Lisp (SBCL)'

Install-ChocolateyEnvironmentVariable -variableName "SBCL_HOME" -variableValue $sbclhome -variableType = 'Machine'

## Set up a file association
## - https://docs.chocolatey.org/en-us/create/functions/install-chocolateyfileassociation
#Install-ChocolateyFileAssociation

## Adding a shim when not automatically found - Cocolatey automatically shims exe files found in package directory.
## - https://docs.chocolatey.org/en-us/create/functions/install-binfile
## - https://docs.chocolatey.org/en-us/create/create-packages#how-do-i-exclude-executables-from-getting-shims
Install-BinFile -Name 'sbcl' -path $target
