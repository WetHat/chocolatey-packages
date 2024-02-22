$packageID           = 'apache-netbeans.portable'
$url                 = 'https://downloads.apache.org/netbeans/netbeans/21/netbeans-21-bin.zip'
$shortcutLocation    = 'Portable Apps (Chocolatey)'
$shortcutName        = 'Apache Netbeans.lnk'
$shortcutDescription = 'Apache NetBeans development environment, tooling platform, and application framework.'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage -packageName   $packageID `
                             -Url           $url `
                             -UnzipLocation $installlocation `
                             -Checksum      '7a71a9683c526a847c1ff43bc9403d5c01c50b739e3c5170feffb2aa7fbaf7fd' `
                             -ChecksumType  'sha256'
$targetBasename = 'netbeans'
if (Get-OSArchitectureWidth -compare 64)
{
   $targetBasename += '64' 
}

echo "Creating shortcut for $(Get-OSArchitectureWidth) bit Netbeans"
    
Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    
    if ($exe.BaseName -eq $targetBasename)
    {
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
