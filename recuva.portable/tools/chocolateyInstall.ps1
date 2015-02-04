$packageName = 'recuva.portable'
$url = 'http://www.piriform.com/recuva/download/portable/downloadfile' # download url

$installocation = Split-Path -parent $MyInvocation.MyCommand.Definition
$parameters=$env:chocolateyPackageParameters
echo $parameters > c:\otto.txt

[bool]$forceX86 = $false


Install-ChocolateyZipPackage $packageName $url $installocation

$bitness = Get-ProcessorBits

Get-ChildItem -name $installocation -filter '*.exe' `| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installocation -ChildPath $_
    [bool]$keep = $false
    [string]$shortcutName=''
    if ($exe.BaseName -like '*64')
    {
      $shortcutName = 'Recuva (64bit).lnk'
      # we got the 64 bit executable
      $keep = $bitness -eq 64
    }
    else
    {
      # we got the 32-bit executable
      $shortcutName = 'Recuva.lnk'
      $keep = $bitness -eq 32
    }
    echo "Shortcut name: $shortcutname - $keep"
    if ($keep)
    {
      # Inform chocolatey that this is exe has gui
      echo '' >"$($exe.FullName).gui"
      ## install a shortcut to the start menu
      $shortcutFolder = Join-Path -Path $env:ALLUSERSPROFILE `
                                  -ChildPath 'Microsoft\Windows\Start Menu\Programs\Portable Apps'
      $shortcut = Join-Path -Path $shortcutFolder `                            -ChildPath $shortcutName
      # register shortcut for removal
      Out-File -InputObject $shortcut `
               -FilePath (Join-Path -Path $installocation -ChildPath 'shortcut.txt')
      if (![System.IO.Directory]::Exists( $shortcutFolder))
      {
        [System.IO.Directory]::CreateDirectory($shortcutFolder)
      }
      <# Note yet available ?!      Install-ChocolateyShortcut -ShortcutFilePath $shortcut `
                                 -WorkingDirectory $installocation
       #>            
    }
    else
    {
      # ignore executable if is not for current platform
      echo '' >"$($exe.FullName).ignore"
    }
  }