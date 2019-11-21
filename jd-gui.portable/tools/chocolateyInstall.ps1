$packageName         = 'jd-gui.portable' # nuget package id
$url                 = 'https://github.com/java-decompiler/jd-gui/releases/download/v1.6.5/jd-gui-1.6.5.jar' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'jD GUI.lnk'
$shortcutDescription = 'Java decompiler'

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'
$launcher            = Join-Path -Path $installlocation -ChildPath 'jD.bat'
$app                 = Join-Path -Path $installlocation -ChildPath 'jd.jar'

Get-ChocolateyWebFile -packageName  $packageName `
                      -fileFullPath $app        `
                      -url          $url `
                      -Checksum     'cca26873bf3541dac53beaba3220ffdbb2da9088d782d59cf0cba18da8e74113' `
                      -ChecksumType 'sha256'

# Generate a launch file
Write-Host "Generating Launch File"

@"
START javaw -jar $app
"@ | Out-File -FilePath $launcher -Encoding ASCII

## install a shortcut to the start menu to make this app discoverable
[string]$shortcutFolder = Join-Path -Path ([environment]::GetFolderPath([environment+specialfolder]::Programs)) `
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
                           -TargetPath $launcher `
                           -WorkingDirectory $installlocation `
                           -IconLocation (Join-Path -Path $appBase -ChildPath 'tools\jD-gui128x128.ico') `
                           -Description $shortcutDescription
