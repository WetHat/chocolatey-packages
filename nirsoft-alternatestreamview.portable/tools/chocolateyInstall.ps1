$packageName         = 'nirsoft-alternatestreamview.portable'
$url32               = 'https://www.nirsoft.net/utils/alternatestreamview.zip' # download url
$url64               = 'https://www.nirsoft.net/utils/alternatestreamview-x64.zip' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'NTFSlinksView.lnk'
$shortcutDescription = 'Shows a list of all symbolic links and junctions in the specified folder, and their target paths'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -PackageName    $packageName `
                             -Url            $url32 `
                             -Checksum      '6a4600134b0b3f641b5b2694315c32db71f11b2d22aaeac027ae55101033d0b1' `
                             -ChecksumType  'sha256' `
                             -Url64bit       $url64 `
                             -ChecksumType64 'sha256' `
                             -Checksum64     'ad1f0edb2202ec1a736d9266b18b241eac5542c350578a3a8cdb4dd8b14ff37d' `
                             -UnzipLocation $installlocation

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'AlternateStreamView')
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
