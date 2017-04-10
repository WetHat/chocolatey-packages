$packageID           = 'grepwin.portable' # nuget package id
$url                 = 'http://sourceforge.net/projects/grepwin/files/1.6.17/grepWin-1.6.17_portable.exe/download' # download url
$url64               = 'http://sourceforge.net/projects/grepwin/files/1.6.17/grepWin-x64-1.6.17_portable.exe/download' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'grepWin.lnk'
$shortcutDescription = 'Regular expression search and replace for Windows'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'
$app                 = Join-Path -Path $installlocation -ChildPath 'grepWin.exe'

Get-ChocolateyWebFile  -packageName  $packageName `
                       -fileFullPath $app `
                       -url $url `
                       -url64bit $url64 `
                       -Checksum       '506DB84F8D4D023BB943C1798264B12EDF9CFAAAA6FFAB6CD4463AEC0C49471C' `
                       -Checksum64     '9BE3E07084C0B0CEA01EE0E43234DBDCC451590D20E25CEC95CC4C0AB91DE4D4' `
                       -ChecksumType   'sha256' `

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'grepWin')
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
