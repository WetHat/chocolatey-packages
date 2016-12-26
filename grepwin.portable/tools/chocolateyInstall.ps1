$packageID           = 'grepwin.portable' # nuget package id
$url                 = 'http://sourceforge.net/projects/grepwin/files/1.6.16/grepWin-1.6.16_portable.exe/download' # download url
$url64               = 'http://sourceforge.net/projects/grepwin/files/1.6.16/grepWin-x64-1.6.16_portable.exe/download' # download url
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
                       -Checksum       'BD94BDAC516DD54B0293E49393634D96CDFA162F953015B72D5E85C663252206' `
                       -Checksum64     '4728B4C2468AD4F4559F37AA7B0AF70135CC54A619A2358D06C074083ABCFDB9' `
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
