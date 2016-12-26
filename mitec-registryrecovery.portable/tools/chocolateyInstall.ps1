$packageID           = 'mitec-registryrecovery.portable.1.5.5' # nuget package id includes version because download url does not
$url                 = 'http://www.mitec.cz/Downloads/WRR.zip' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'MiTec Registry Recovery.lnk'
$shortcutDescription = 'Load offline registry hives and dig out information'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -PackageName  $packageID `
                             -Url           $url `
                             -UnzipLocation $installlocation `
                             -Checksum      '281125724E2690216A02CC36E26AA006D9F3A64DFAA454625B7584CB6E053329' `
                             -ChecksumType  'sha256'

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'WRR')
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
