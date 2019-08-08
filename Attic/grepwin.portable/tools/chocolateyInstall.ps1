$packageID           = 'grepwin.portable' # nuget package id
$url                 = 'https://sourceforge.net/projects/grepwin/files/1.7.1/grepWin-1.7.1_portable.exe/download' # download url
$url64               = 'https://sourceforge.net/projects/grepwin/files/1.7.1/grepWin-x64-1.7.1_portable.exe/download' # download url
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
                       -Checksum       'D5C546FEA88D82DC4C14BCF4E01B4282FC4CB990CEE694E8E3062F86BEF6A62D' `
                       -Checksum64     '5800479B3F186D70FA1E6EB955BC148F27D123DD379BF95A8208291A2D56126F' `
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
