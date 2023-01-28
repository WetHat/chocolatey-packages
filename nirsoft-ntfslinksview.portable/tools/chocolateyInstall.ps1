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
                             -Checksum      '1ab71ce2c8ef2e58aafa569f5d3766be63d401bc1a1aed6aea21418550f314af' `
                             -ChecksumType  'sha256' `
                             -Url64bit       $url64 `
                             -ChecksumType64 'sha256' `
                             -Checksum64     '2be8f8789340db249723811e89a78d2ce92d81aea18ac7760b251c3e68e6b224' `
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
                                 -Description $shortcutDescription
    }
    else
    {
       echo '' >"$($exe.FullName).ignore"
    }
  }
