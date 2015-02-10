$packageName      = 'recuva.portable' # nuget ID
$url              = 'http://www.piriform.com/recuva/download/portable/downloadfile' # download url
$shortcutLocation = 'Microsoft\Windows\Start Menu\Programs\Chocolatey'
$shortcutRegistry = 'shortcuts.txt' # we register shortcuts for removal on Uninstall here
$installlocation  = Split-Path -parent $MyInvocation.MyCommand.Definition

# if we could get to the command line options, we could set this properly 
[bool]$forceX86 = $false

Install-ChocolateyZipPackage $packageName $url $installlocation

$bitness = Get-ProcessorBits

Get-ChildItem -name $installlocation -filter '*.exe' `| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    [bool]$publish = $false
    [string]$shortcutName=''
    if ($exe.BaseName -like '*64')
    {
      $shortcutName = 'Recuva (64bit).lnk'
      # we got the 64 bit executable
      $publish = $bitness -eq 64
    }
    else
    {
      # we got the 32-bit executable
      $shortcutName = 'Recuva.lnk'
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
          $lnk.Description      = 'Recuva File Recovery'
          $lnk.Save()
          echo "Created Start Menu Shortcut: $shortcutname"
      }
      catch
      {
        # It is not a showstopper, if shortcut creation fails
      }
    }
    else
    {
      # ignore executable if is not for current platform
      echo '' >"$($exe.FullName).ignore"
    }
  }