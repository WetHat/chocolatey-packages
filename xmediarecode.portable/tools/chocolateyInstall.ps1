$packageName         = 'xmediarecode.portable'
$url                 = 'http://www.xmedia-recode.de/download/XMediaRecode3217.zip' # download url
$installlocation     = Split-Path -parent $MyInvocation.MyCommand.Definition
$shortcutLocation    = 'Microsoft\Windows\Start Menu\Programs\Chocolatey'
$shortcutRegistry    = 'shortcuts.txt' # we register shortcuts for removal on Uninstall here
$shortcutName        = 'Xmedia Recode.lnk'
$shortcutDescription = 'Video / Audio Transcoder' 
Install-ChocolateyZipPackage $packageName $url $installlocation

Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'XMedia Recode')
    {
      echo '' >"$($exe.FullName).gui"

      ## install a shortcut to the start menu to make this app discoverable
      [string]$shortcutFolder = Join-Path -Path $env:ALLUSERSPROFILE `
                                          -ChildPath $shortcutLocation 
      [string]$shortcut       = Join-Path -Path $shortcutFolder `                                          -ChildPath $shortcutName
      # register shortcut for removal on uninstall
      Out-File -InputObject $shortcut `
               -FilePath (Join-Path -Path $installlocation -ChildPath $shortcutRegistry)
      if (![System.IO.Directory]::Exists( $shortcutFolder))
      {
        [System.IO.Directory]::CreateDirectory($shortcutFolder) >$null
      }
       <# TODO: use this when it becomes available in chocolatey      Install-ChocolateyShortcut -ShortcutFilePath $shortcut `
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
  }
