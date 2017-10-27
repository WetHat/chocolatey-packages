﻿$packageName         = 'instantwordpress' # nuget package ID
$url                 = 'https://github.com/corvideon/InstantWP/releases/download/v5.3.0/IWP-v5.3.0-Win.zip' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'Instant WordPress.lnk'
$shortcutDescription = 'Standalone, portable WordPress development environment'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$toolslocation     = Join-Path -Path $appBase -ChildPath 'tools'

$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -packageName   $packageName `
                             -Url           $url `
                             -UnzipLocation $installlocation `
                             -Checksum      '3879DA984BB63F488D4454E159C7CC565213D17B9B10F4EBB9010139A9C3656C' `
                             -ChecksumType  'sha256'
                             
# create .gui and .ignore files as appropriate
Get-ChildItem -Name $installlocation -include '*.bat','*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'Start-InstantWP')
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
                                 -Description $shortcutDescription `
                                 -IconLocation (Join-Path -Path $toolslocation IWP.ico)
    }
    else
    {
      # ignore this executable
      echo '' >"$($exe.FullName).ignore"
    }
  }
