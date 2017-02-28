$packageName         = 'diskdefrag.portable'
$url                 = 'http://www.auslogics.com/en/downloads/disk-defrag/ausdiskdefragportable.exe' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutDescription = 'Compact and fast harddisk defragmenter'

$shortcutName        = 'Auslogics Disk Defrag.lnk'
$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'
$app                 = Join-Path -Path $installlocation -ChildPath 'AuslogicsDiskDefrag.exe'

Get-ChocolateyWebFile -PackageName   $packageName `
                      -FileFullPath $app          `
                      -Url          $url           `
                      -Checksum     'A59A29078E5459A325F38D04126EAA4C5F3EA6F7A1112725C3DECE5969D749A9' `
                      -ChecksumType 'sha256'
Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'AuslogicsDiskDefrag')
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
