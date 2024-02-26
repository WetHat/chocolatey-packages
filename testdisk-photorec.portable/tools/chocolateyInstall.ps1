$packageID           = 'testdisk-photorec.portable' # nuget package id
$url                 = 'https://www.cgsecurity.org/testdisk-7.2.win.zip' # download url
$url64               = 'https://www.cgsecurity.org/testdisk-7.2.win64.zip'
$shortcutLocation    = 'Portable Apps (Chocolatey)'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -packageName  $packageName `
                             -Url          $url         `
                             -Url64        $url64       `
                             -UnzipLocation $installlocation `
                             -Checksum      '0718a4529611e5f8b6d5fcb873279d23a0b212b18bcf72291f3b47351bfc7126' `
                             -Checksum64    'e97e203ce77b6b1a3a37d01beccf069dc6c4632b579ffbb82ae739cdda229f38' `
                             -ChecksumType  'sha256'
                             
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
