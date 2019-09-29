$packageName         = 'uniextract.portable' # arbitrary name for the package, used in messages
$url                 = 'http://www.legroom.net/files/software/uniextract161_noinst.rar' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'Universal Extractor.lnk'
$shortcutDescription = 'Decompress and extract files from any type of archive or installer'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'
$rar                 = Join-Path -Path $appBase -ChildPath 'uniextract.rar'
$unrar               = Join-Path -Path $appBase -ChildPath 'tools/unrar.exe'

# Download the self-extracting archive
Get-ChocolateyWebFile $packageName $rar $url 
# .. and run it to extract
Write-Host "Extracting $packageName ..."

Start-Process -FilePath $unrar `
              -Wait `
              -WindowStyle Hidden `
              -ArgumentList 'x',$rar,"$installlocation\"

Remove-Item -Path $unrar,$rar
           
Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'UniExtract')
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
