$packageName         = 'licensecrawler.portable'
$url                 = 'http://www.klinzmann.name/files/licensecrawler.zip' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'LicenseCrawler.lnk'
$shortcutDescription = 'Discover application product keys, serial numbers, or licenses'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -PackageName   $packageName `
                             -Url           $url `
                             -UnzipLocation $installlocation `
                             -Checksum      '07c963b22426c9672b625a83fae832a7d3a67718d44e6d6f3d1bcefc0d885205' `
                             -ChecksumType  'sha256'

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'LicenseCrawler')
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
                                 -RunAsAdmin
    }
    else
    {
       echo '' >"$($exe.FullName).ignore"
    }
  }
