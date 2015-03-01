﻿$packageName         = 'uniextract.portable' # arbitrary name for the package, used in messages
$url                 = 'http://www.legroom.net/files/software/uniextract161_noinst.rar' # download url
$installlocation     = Split-Path -parent $MyInvocation.MyCommand.Definition
$shortcutLocation    = 'Microsoft\Windows\Start Menu\Programs\Chocolatey'
$shortcutRegistry    = 'shortcuts.txt' # we register shortcuts for removal on Uninstall here
$shortcutName        = 'Universal Extractor.lnk'
$shortcutDescription = 'Decompress and extract files from any type of archive or installer'
$rar                 = Join-Path -Path $installlocation -ChildPath 'uniextract.rar'
$unrar               = Join-Path -Path $installlocation -ChildPath 'unrar.exe'
# Download the self-extracting archive
Get-ChocolateyWebFile $packageName $rar $url 
# .. and run it to extract
Write-Host "Extracting $packageName ..."

Start-Process -FilePath $unrar `
              -Wait `
              -ArgumentList 'x',$rar,"$installlocation\"

Remove-Item -Path $unrar,$rar
           
Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    if ($exe.BaseName -eq 'UniExtract')
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