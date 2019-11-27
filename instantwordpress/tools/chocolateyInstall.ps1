$packageName         = 'instantwordpress' # nuget package ID
$url                 = 'https://github.com/webtoolsgroup/InstantWP/releases/download/v5.3.6/IWP-v5.3.6-Win.zip' # download url
$shortcutLocation    = 'Portable Apps (chocolatey)'
$shortcutName        = 'Instant WordPress.lnk'
$shortcutDescription = 'Standalone, portable WordPress development environment'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$toolslocation       = Join-Path -Path $appBase -ChildPath 'tools'

$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -packageName   $packageName `
                             -Url           $url `
                             -UnzipLocation $installlocation `
                             -Checksum      '1e11d51aad5f11930f0bb42cdda718d672b64a9b050c953519a9c5b821b20cc2' `
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
