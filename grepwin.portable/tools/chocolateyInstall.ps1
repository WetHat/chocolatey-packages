$packageID           = 'grepwin.portable' # nuget package id
$url                 = 'http://sourceforge.net/projects/grepwin/files/1.6.15/grepWin-1.6.15_portable.exe/download' # download url
$url64               = 'http://sourceforge.net/projects/grepwin/files/1.6.15/grepWin-x64-1.6.15_portable.exe/download' # download url
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
                       -Checksum       'A14A9A3B69CA47895550C0A571C2ABD63CFFB856882D729EBB5585C7ADAC1562' `
                       -Checksum64     '7F552196EFF4DF1F91E783A3C6C08B1C1E590EB19F7AFC4F908B6A9091941863' `
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
