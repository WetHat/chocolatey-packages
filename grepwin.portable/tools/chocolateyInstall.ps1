$packageID           = 'grepwin.portable' # nuget package id
$url                 = 'https://sourceforge.net/projects/grepwin/files/1.7.0/grepWin-1.7.0_portable.exe/download' # download url
$url64               = 'https://sourceforge.net/projects/grepwin/files/1.7.0/grepWin-x64-1.7.0_portable.exe/download' # download url
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
                       -Checksum       '2F6DA8F4BF50EF889600A67291CD1EC1750753DC4E4F5C1FEEA368ED4D65E41A' `
                       -Checksum64     '6976F640CE6B70EE74FF4111CC884D17BA553A3CD2BE8227B8A2452CCB0546A8' `
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
