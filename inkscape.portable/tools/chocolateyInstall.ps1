$packageName         = 'inkscape.portable' # arbitrary name for the package, used in messages
$url                 = 'https://inkscape.org/gallery/item/10686/Inkscape-0.92.1.7z' # download url
$url64               = 'https://inkscape.org/gallery/item/10687/Inkscape-0.92.1-x64.7z' # 64bit URL
$shortcutLocation    = 'Chocolatey'
$shortcutDescription = 'Powerful, free vector graphics (svg) design tool'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -packageName    $packageName `
                             -Url            $url `
                             -Url64          $url64 `
                             -UnzipLocation  $installlocation `
                             -Checksum       '78E524F584C63D062FCA525E0AE4D689B2CF5F1CAD355BA0FFB42E5E328C94A3' `
                             -ChecksumType   'sha256' `
                             -Checksum64     '480A4B6BD03C5BB15B91059B4CE40BAA1C2908A21C955722FD26285F64096729' `
                             -ChecksumType64 'sha256'

$bitness = Get-ProcessorBits

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_

    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    [bool]$publish = $false
    [string]$shortcutName=''
    if ($exe.BaseName -eq 'inkscape')
    {
      $publish = $true
      if ($bitness -eq 64)
      {
        $shortcutName = 'Inkscape (64-bit).lnk'
      }
      else
      {
        $shortcutName = 'Inkscape (32-bit).lnk'
      }
    }

    if ($publish)
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
