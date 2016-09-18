$packageName         = 'ssd-z.portable' # arbitrary name for the package, used in messages
$url                 = 'https://www.techpowerup.com/forums/attachments/ssd-z_16-09-09wip-rar.78637/' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'SSD-Z.lnk'
$shortcutDescription = 'Detailed info about your solid-state disks and harddriveschoco pack'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -packageName  $packageName `
                             -Url          $url         `
                             -UnzipLocation $installlocation `
                             -Checksum      '96DB95387CA0F37206A5DF7AC9E8F8AFEDDFB6D0997643926479A8155BA64C50' `
                             -ChecksumType  'sha256'

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'SSD-Z')
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
