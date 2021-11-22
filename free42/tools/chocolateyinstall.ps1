﻿$packageID           = free42
$url                 = 'https://thomasokken.com/free42/download/Free42Windows.zip'
$shortcutLocation    = 'Portable Apps (Chocolatey)'
$shortcutName        = 'Free42.lnk'
$shortcutDescription = 'HP-42S Calculator Simulator.'

$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir            = (Split-Path -parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $toolsDir -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $toolsDir  -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -packageName   $packageID `
                             -Url           $url `
                             -UnzipLocation $installlocation `
                             -Checksum      'abab148efbbf60c13b39755b949eea887435508d15dc0fca6939eeb04c3ec003' `
                             -ChecksumType  'sha256'

$targetBasename = 'Free42Decimal'

Write-Host "Creating shortcut for $targetBasename"
    
Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    
    if ($exe.BaseName -eq $targetBasename)
    {
      echo '' >"$($exe.FullName).gui"

      ## install a shortcut to the start menu to make this app discoverable
      [string]$shortcutFolder = Join-Path -Path ([environment]::GetFolderPath([environment+specialfolder]::Programs)) `
                                          -ChildPath $shortcutLocation
      [string]$shortcut       = Join-Path -Path $shortcutFolder `
                                          -ChildPath $shortcutName
      # register shortcut for removal on uninstall
      Out-File -InputObject $shortcut `
               -Append `
               -FilePath $shortcutRegistry
      if (![System.IO.Directory]::Exists( $shortcutFolder))
      {
        [System.IO.Directory]::CreateDirectory($shortcutFolder) >$null
      }

      Install-ChocolateyShortcut -ShortcutFilePath $shortcut `
                                 -Targetpath $exe.FullName `
                                 -WorkingDirectory $exe.DirectoryName `
                                 -Description $shortcutDescription
    }
    else
    {
       echo '' >"$($exe.FullName).ignore"
    }
  }
  
