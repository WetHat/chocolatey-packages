$packageName              = 'instantwp.portable' # arbitrary name for the package, used in messages
$url                      = 'https://s3-eu-west-1.amazonaws.com/instantwp/downloads/InstantWP_4.4.2.exe' # download url
$installocation           = Split-Path -parent $MyInvocation.MyCommand.Definition
$shortcutRegistrationFile = 'shortcuts.txt' # we register shortcuts for removal on Uninstall here
$selfExtractingExe        = Join-Path -Path $installocation -ChildPath 'InstantWP_4.4.2.exe'
$validExitCodes           = @(0)
$silentArgs               = '/S' 

# Download the self-extracting archive
Get-ChocolateyWebFile $packageName $selfExtractingExe $url 
# .. and run it to extract
echo "Extracting $packageName ..."
Start-ChocolateyProcessAsAdmin $silentArgs $selfExtractingExe -validExitCodes $validExitCodes

# create .gui and .ignore files as appropriate
Get-ChildItem -Name $installocation -filter '*.exe' -Recurse `| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installocation -ChildPath $_
    if ($exe.BaseName -eq 'InstantWP')
    {
      echo '' >"$($exe.FullName).gui"
      $shortcutName = 'Instant WordPress.lnk'
      
      ## install a shortcut to the start menu to make this app discoverable
      [string]$shortcutFolder = Join-Path -Path $env:ALLUSERSPROFILE `
                                          -ChildPath 'Microsoft\Windows\Start Menu\Programs\Chocolatey Portable Apps'
      [string]$shortcut       = Join-Path -Path $shortcutFolder `                                          -ChildPath $shortcutName
      # register shortcut for removal on uninstall
      Out-File -InputObject $shortcut `
               -FilePath (Join-Path -Path $installocation -ChildPath $shortcutRegistrationFile)
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
          $lnk.TargetPath = $exe.FullName
          $lnk.WorkingDirectory = $exe.DirectoryName
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
      # ignore this executable
      echo '' >"$($exe.FullName).ignore"
    }
  }

# remove the selfextracting exe
Remove-Item -LiteralPath $selfExtractingExe -ErrorAction:SilentlyContinue