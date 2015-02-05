$packageName = 'recuva.portable' # nuget ID
$url = 'http://www.piriform.com/recuva/download/portable/downloadfile' # download url
$shortcutRegistrationFile = 'shortcuts.txt' # we register shortcuts for remocal on Uninstall here

[string]$installocation = Split-Path -parent $MyInvocation.MyCommand.Definition

# if we could get to the command line options, we could set this properly 
[bool]$forceX86 = $false

Install-ChocolateyZipPackage $packageName $url $installocation

$bitness = Get-ProcessorBits

Get-ChildItem -name $installocation -filter '*.exe' `| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installocation -ChildPath $_
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
      echo "Creating Shortcut: $shortcutname"
      # Inform chocolatey that this is exe has gui
      echo '' >"$($exe.FullName).gui"
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
      $wscript = New-Object -ComObject WScript.Shell
      $lnk =  $wscript.CreateShortcut($shortcut)
      $lnk.TargetPath = $exe.FullName
      $lnk.WorkingDirectory = $exe.DirectoryName
      $lnk.Save()        
    }
    else
    {
      # ignore executable if is not for current platform
      echo '' >"$($exe.FullName).ignore"
    }
  }