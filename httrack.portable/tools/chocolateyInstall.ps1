﻿$packageName         = 'httrack.portable' # arbitrary name for the package, used in messages
$url                 = 'http://download.httrack.com/httrack-noinst-3.48.19.zip' # download url
$url64               = 'http://download.httrack.com/httrack_x64-noinst-3.48.19.zip' # 64bit URL here or remove - if installer decides, then use $url
$installlocation     = Split-Path -parent $MyInvocation.MyCommand.Definition
$shortcutLocation    = 'Microsoft\Windows\Start Menu\Programs\Chocolatey'
$shortcutRegistry    = 'shortcuts.txt' # we register shortcuts for removal on Uninstall here
$shortcutName        = 'HTTrack Website Copier.lnk'
$shortcutDescription = 'Free and easy-to-use offline browser utility'

Install-ChocolateyZipPackage $packageName $url $installlocation $url64

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'WinHTTrack')
    {
      echo '' >"$($exe.FullName).gui"

      ## install a shortcut to the start menu to make this app discoverable
      [string]$shortcutFolder = Join-Path -Path $env:ALLUSERSPROFILE `
                                          -ChildPath $shortcutLocation 
      [string]$shortcut       = Join-Path -Path $shortcutFolder `
      # register shortcut for removal on uninstall
      Out-File -InputObject $shortcut `
               -FilePath (Join-Path -Path $installlocation -ChildPath $shortcutRegistry)
      if (![System.IO.Directory]::Exists( $shortcutFolder))
      {
        [System.IO.Directory]::CreateDirectory($shortcutFolder) >$null
      }
       <# TODO: use this when it becomes available in chocolatey
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
          echo "Created Start Menu Shortcut: $shortcutname"
      }
      catch
      {
        echo 'Shortcut creation failed..'
        # It is not a showstopper, if shortcut creation fails
      }
    }
    else
    {
       echo '' >"$($exe.FullName).ignore"
    }
  }