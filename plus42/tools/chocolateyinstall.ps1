$packageID           = 'plus42'
$url                 = 'https://thomasokken.com/plus42/download/Plus42Windows.zip'
$shortcutLocation    = 'Portable Apps (Chocolatey)'
$shortcutName        = 'HP-42SE.lnk'
$shortcutDescription = 'HP-42S Enhanced Calculator Simulator.'

$ErrorActionPreference = 'Stop'; # stop on all errors
$appBase        = Split-Path -Parent `
                             -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -packageName   $packageID `
                             -Url           $url `
                             -UnzipLocation $installlocation `
                             -Checksum      '8b04de8bd8992f63ab8b4283a93c1519b11b1c9f71a129793bd441406a815148' `
                             -ChecksumType  'sha256'

$targetBasename = 'Plus42Decimal'

Write-Host "Creating shortcut for $targetBasename"

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_

    if ($exe.BaseName -eq $targetBasename) {
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
      if (![System.IO.Directory]::Exists( $shortcutFolder)) {
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

# copy some default skins

$skins = Join-Path -Path $appBase -ChildPath 'skins'
$appdata = Join-Path -Path ([environment]::GetFolderPath([environment+specialfolder]::ApplicationData)) `
                     -ChildPath 'Plus42'

New-Item -Path $appdata -ItemType Directory -ErrorAction:SilentlyContinue

if (Test-Path $appdata -PathType Container) {
    Copy-Item -Path "$skins/*" -Destination $appdata
}

