$packageID           = 'free42'
$url                 = 'https://thomasokken.com/free42/download/Free42Windows.zip'
$shortcutLocation    = 'Portable Apps (Chocolatey)'
$shortcutName        = 'HP-42S.lnk'
$shortcutDescription = 'HP-42S Calculator Simulator.'

$ErrorActionPreference = 'Stop'; # stop on all errors
$appBase        = Split-Path -Parent `
                             -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -packageName   $packageID `
                             -Url           $url `
                             -UnzipLocation $installlocation `
                             -Checksum      'ad2140014146c71df40704b4dbba1e18e68837899161d672882a0372b9df7131' `
                             -ChecksumType  'sha256'

$targetBasename = 'Free42Decimal'

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
                     -ChildPath 'Free42'

New-Item -Path $appdata -ItemType Directory -ErrorAction:SilentlyContinue

if (Test-Path $appdata -PathType Container) {
    Copy-Item -Path "$skins/*" -Destination $appdata
}

