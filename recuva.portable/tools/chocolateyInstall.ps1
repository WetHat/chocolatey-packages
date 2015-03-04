﻿$packageName      = 'recuva.portable' # nuget ID
$url              = 'http://www.piriform.com/recuva/download/portable/downloadfile' # download url
$shortcutLocation = 'Microsoft\Windows\Start Menu\Programs\Chocolatey'
$shortcutDescription = 'Recuva File Recovery'
# if we could get to the command line options, we could set this properly 
[bool]$forceX86 = $false

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'
Install-ChocolateyZipPackage $packageName $url $installlocation

$bitness = Get-ProcessorBits

Get-ChildItem -name $installlocation -filter '*.exe' `
| ForEach-Object {
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
      # ignore executable if is not for current platform
      echo '' >"$($exe.FullName).ignore"
    }
  }