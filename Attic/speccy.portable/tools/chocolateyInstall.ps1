$packageName         = 'speccy.portable.1.30.730' # includes version as download url is version neutral
$url                 = 'http://www.piriform.com/speccy/download/portable/downloadfile' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutDescription = 'Advanced System Information Tool'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -PackageName   $packageName `
                             -Url           $url       `
                             -UnzipLocation $installlocation `
                             -Checksum      '0548389AA922FE1E740294E3E7C63341D4B32980ADEC9CB31B4EEBA8F487D67F' `
                             -ChecksumType  'sha256'

$bitness = Get-ProcessorBits

Get-ChildItem -name $installlocation -filter '*.exe' `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    [bool]$publish = $false
    [string]$shortcutName=''
    if ($exe.BaseName -eq 'Speccy64')
    {
      $shortcutName = 'Speccy (64bit).lnk'
      # we got the 64 bit executable
      $publish = $bitness -eq 64
    }
    elseif ($exe.BaseName -eq 'Speccy')
    {
      # we got the 32-bit executable
      $shortcutName = 'Speccy.lnk'
      $publish = $bitness -eq 32
    }

    if ($publish)
    {
      # Inform chocolatey that this is exe has gui
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
      # ignore executable if is not for current platform
      echo '' >"$($exe.FullName).ignore"
    }
  }
