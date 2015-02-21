$packageName         = 'speccy.portable' # arbitrary name for the package, used in messages
$url                 = 'http://www.piriform.com/speccy/download/portable/downloadfile' # download url
$installlocation     = Split-Path -parent $MyInvocation.MyCommand.Definition
$shortcutLocation    = 'Microsoft\Windows\Start Menu\Programs\Chocolatey'
$shortcutRegistry    = 'shortcuts.txt' # we register shortcuts for removal on Uninstall here
$shortcutDescription = 'Advanced System Information Tool'

Install-ChocolateyZipPackage $packageName $url $installlocation

$bitness = Get-ProcessorBits

Get-ChildItem -name $installlocation -filter '*.exe' `| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    [bool]$publish = $false
    [string]$shortcutName=''
    if ($exe.BaseName -eq 'Speccy64')
    {
      $shortcutName = 'Speccy (64bit).lnk'
      # we got the 64 bit executable
      $publish = $bitness -eq 64
    }
    elseif ($exe.BaseName -eq 'Speccy')
    {
      # we got the 32-bit executable
      $shortcutName = 'Speccy.lnk'
      $publish = $bitness -eq 32
    }
    
    if ($publish)
    {
      # Inform chocolatey that this is exe has gui
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
    else
    {
      # ignore executable if is not for current platform
      echo '' >"$($exe.FullName).ignore"
    }
  }