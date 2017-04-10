$packageName         = 'httrack.portable' # arbitrary name for the package, used in messages
$url                 = 'http://download.httrack.com/httrack-noinst-3.49.1.zip' # download url
$url64               = 'http://download.httrack.com/httrack_x64-noinst-3.49.1.zip' # 64bit URL here or remove - if installer decides, then use $url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'HTTrack Website Copier.lnk'
$shortcutDescription = 'Free and easy-to-use offline browser utility'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -packageName   $packageName `
                             -Url           $url `
                             -Url64bit      $url64 `
                             -UnzipLocation $installlocation `
                             -Checksum      '4C1A4DC8D2628BFCF0CF5B2FD688895539DDCB871A48B633FB66FBD667D7B957' `
                             -Checksum64    '33830FD1C84E1BE9F0552417B73294D564799EAB4447671DEE481F256B43C54C' `
                             -ChecksumType  'sha256'

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'WinHTTrack')
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
