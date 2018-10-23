$packageID           = 'testdisk-photorec.portable' # nuget package id
$url                 = 'http://www.cgsecurity.org/testdisk-7.1.WIP.zip' # download url
$shortcutLocation    = 'Chocolatey'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage $packageID $url $installlocation

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'testdisk_win' )
    {
      $shortcutName        = 'TestDisk.lnk'
      $shortcutDescription = 'recover lost partitions and/or make non-booting disks bootable'
      $createShortcut=$true
    }
    elseif ($exe.BaseName -eq 'photorec_win' )
    {
      $shortcutName        = 'PhotoRec.lnk'
      $shortcutDescription = 'Signature based file recovery utility'
      $createShortcut=$true
    }
    elseif ($exe.BaseName -eq 'qphotorec_win' )
    {
      $shortcutName        = 'PhotoRec GUI.lnk'
      $shortcutDescription = 'Signature based file recovery utility with GUI'
      $createShortcut=$true
    }
    else
    {
      $createShortcut=$false
    }

    if ($createShortcut)
    {
      $createShortcut=$false
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
