$packageName         = 'nirsoft-ntfslinksview.portable'
$url64                 'https://www.nirsoft.net/utils/ntfslinksview-x64.zip' # download url
$url32                 'https://www.nirsoft.net/utils/ntfslinksview.zip' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'NTFSlinksView.lnk'
$shortcutDescription = 'Shows a list of all symbolic links and junctions in the specified folder, and their target paths'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -PackageName    $packageName `
                             -Url            $url
                             -Checksum      's' `
                             -ChecksumType  'sha256' `
                             -Url64bit       $url64 `
                             -ChecksumType64 'sha256'
                             -Checksum64     'a' `
                             -UnzipLocation $installlocation

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
