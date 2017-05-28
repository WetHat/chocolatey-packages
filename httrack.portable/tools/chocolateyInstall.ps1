$packageName         = 'httrack.portable' # arbitrary name for the package, used in messages
$url                 = 'http://download.httrack.com/httrack-noinst-3.49.2.zip' # download url
$url64               = 'http://download.httrack.com/httrack_x64-noinst-3.49.2.zip' # 64bit URL here or remove - if installer decides, then use $url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'HTTrack Website Copier.lnk'
$shortcutDescription = 'Free and easy-to-use offline browser utility'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -packageName   $packageName `
                             -Url           $url `
                             -Url64bit      $url64 `
                             -UnzipLocation $installlocation `
                             -Checksum      '5124A9AD6C48A4BE956598E99F988F41DB5ACD40010AD94B24E2B477D5CCA17C' `
                             -Checksum64    '67E706F0A70370A65ED254D3B20A0643469AC3DBB8A927ADC3D097CB1A08D8AA' `
                             -ChecksumType  'sha256'

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'WinHTTrack')
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
