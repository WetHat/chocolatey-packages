$packageName         = 'cpu-z.portable'
$url                 = 'http://download.cpuid.com/cpu-z/cpu-z_1.78-en.zip' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutDescription = 'Information on some of the main devices of your system'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -packageName   $packageName `
                             -Url           $url `
                             -UnzipLocation $installlocation `
                             -Checksum      'C564D37F017FD7B58DB72B0A56607943FAE3887A21DDBED46DBBC7CB507E4FB7' `
                             -ChecksumType  'sha256'

$bitness = Get-ProcessorBits

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_

    [bool]$publish = $false
    [string]$shortcutName=''

    if ($exe.BaseName -eq 'cpuz_x64')
    {
      $shortcutName = 'CPU-Z System Information (64bit).lnk'
      # we got the 64 bit executable
      $publish = $bitness -eq 64
    }
    elseif ($exe.BaseName -eq 'cpuz_x32')
    {
      # we got the 32-bit executable
      $shortcutName = 'CPU-Z System Information.lnk'
      $publish = $bitness -eq 32
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
