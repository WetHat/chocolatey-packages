﻿$packageName         = 'gpu-z.portable' # arbitrary name for the package, used in messages
$url                 = 'http://us1-dl.techpowerup.com/SysInfo/GPU-Z/GPU-Z.1.10.0.exe' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'TechPowerUp GPU-Z.lnk'
$shortcutDescription = 'Provides vital information about your video card and graphics processor'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'
$app                 = Join-Path -Path $installlocation -ChildPath 'GPU-Z.exe'

Get-ChocolateyWebFile -PackageName   $packageName `
                      -FileFullPath $app          `
                     -Url          $url           `
                     -Checksum     'ECEDC38B1377C540DD20206CEBE0733B44B371D62B954F4CB3CC875E953776F7' `
                     -ChecksumType 'sha256'

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'GPU-Z')
    {
      echo '' >"$($exe.FullName).gui"

      ## install a shortcut to the start menu to make this app discoverable
      [string]$shortcutFolder = Join-Path -Path "$($env:APPDATA)\Microsoft\Windows\Start Menu\Programs" `
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
