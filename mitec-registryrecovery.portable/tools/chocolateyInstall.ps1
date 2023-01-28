$packageID           = 'mitec-registryrecovery.portable' # nuget package id
$url                 = 'http://www.mitec.cz/Downloads/WRR.zip' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'MiTec Registry Recovery.lnk'
$shortcutDescription = 'Load offline registry hives and dig out information'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -PackageName  $packageID `
                             -Url           $url `
                             -UnzipLocation $installlocation `
                             -Checksum      '7d3d05c5df58fca2d8e10195f588b7c71213e94b1fb29e3a4be092d6b4a20e65' `
                             -ChecksumType  'sha256'

$baseName = if (Get-OSArchitectureWidth -Compere 64) {'WRR64'} else {'WRR'}
Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq $baseName)
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
