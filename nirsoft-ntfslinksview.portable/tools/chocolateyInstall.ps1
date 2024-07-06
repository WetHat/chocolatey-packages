$packageName         = 'nirsoft-ntfslinksview.portable'
$url32               = 'https://www.nirsoft.net/utils/ntfslinksview.zip' # download url
$url64               = 'https://www.nirsoft.net/utils/ntfslinksview-x64.zip' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'NTFSlinksView.lnk'
$shortcutDescription = 'Shows a list of all symbolic links and junctions in the specified folder, and their target paths'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -PackageName    $packageName `
                             -Url            $url32 `
                             -Checksum      '135ff2daa3424044f836794c059da6c7272efe42ad4dee49409d037e32de0388' `
                             -ChecksumType  'sha256' `
                             -Url64bit       $url64 `
                             -ChecksumType64 'sha256' `
                             -Checksum64     'd3184683dc1116a38bb4c632d1883e48850883b1300c2144c96eedca48679aad' `
                             -UnzipLocation $installlocation

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'NTFSLinksView')
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
