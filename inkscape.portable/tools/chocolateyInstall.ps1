$packageName         = 'inkscape.portable' # arbitrary name for the package, used in messages
$url                 = 'https://inkscape.global.ssl.fastly.net/media/resources/file/Inkscape-0.91-1-win32.7z' # download url
$url64               = 'https://inkscape.global.ssl.fastly.net/media/resources/file/Inkscape-0.91-1-win64.7z' # 64bit URL here or remove - if installer decides, then use $url
$shortcutLocation    = 'Chocolatey'
$shortcutDescription = 'Powerful, free vector graphics (svg) design tool'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Install-ChocolateyZipPackage $packageName $url $installlocation $url64

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
