$packageName         = 'inkscape.portable' # arbitrary name for the package, used in messages
$url                 = 'https://inkscape.global.ssl.fastly.net/media/resources/file/Inkscape-0.91-1-win32.7z' # download url
$url64               = 'https://inkscape.global.ssl.fastly.net/media/resources/file/Inkscape-0.91-1-win64.7z' # 64bit URL here or remove - if installer decides, then use $url
$installlocation     = Split-Path -parent $MyInvocation.MyCommand.Definition
$shortcutLocation    = 'Microsoft\Windows\Start Menu\Programs\Chocolatey'
$shortcutRegistry    = 'shortcuts.txt' # we register shortcuts for removal on Uninstall here
$shortcutDescription = 'Powerful, free vector graphics (svg) design tool'

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
      [string]$shortcutFolder = Join-Path -Path $env:ALLUSERSPROFILE `
                                          -ChildPath $shortcutLocation 
      [string]$shortcut       = Join-Path -Path $shortcutFolder `
                                          -ChildPath $shortcutName
      # register shortcut for removal on uninstall
      Out-File -InputObject $shortcut `
               -Append `
               -FilePath (Join-Path -Path $installlocation -ChildPath $shortcutRegistry)
      if (![System.IO.Directory]::Exists( $shortcutFolder))
      {
        [System.IO.Directory]::CreateDirectory($shortcutFolder) >$null
      }
       <# TODO: use this when it becomes available in chocolatey
      Install-ChocolateyShortcut -ShortcutFilePath $shortcut `
                                 -WorkingDirectory $exe.FullName
                                 ...
      #>
      try
      {
          $wscript = New-Object -ComObject WScript.Shell
          $lnk =  $wscript.CreateShortcut($shortcut)
          $lnk.TargetPath       = $exe.FullName
          $lnk.WorkingDirectory = $exe.DirectoryName
          $lnk.Description      = $shortcutDescription
          $lnk.Save()
          Write-Host "Created Start Menu Shortcut: $shortcutname"
      }
      catch
      {
        Write-Host 'Shortcut creation failed..'
        # It is not a showstopper, if shortcut creation fails
      }
    }
    else
    {
       echo '' >"$($exe.FullName).ignore"
    }
  }
