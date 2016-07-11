$packageName         = 'calibre.portable' # arbitrary name for the package, used in messages
$url                 = 'http://download.calibre-ebook.com/2.62.0/calibre-portable-installer-2.62.0.exe' # download url
$shortcutLocation    = 'Chocolatey'
$shortcutName        = 'Calibre E-Book Manager.lnk'
$shortcutDescription = 'Calibre e-book library manager'
$validExitCodes      = @(0)

$appBase             = Split-Path -Parent `
                                  -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$choco               = Split-Path -Parent (Split-Path -Parent $appBase)
$installlocation     = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry    = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'
$launcher            = Join-Path -Path $installlocation -ChildPath 'calibre-portable.bat'

## We install to a staging folder first so that calibre does not complain
## about the path being too long
Install-ChocolateyPackage $packageName 'EXE' $choco $url -validExitCodes $validExitCodes

Write-Host "Moving calibre into place ..."
Remove-Item -Path $installlocation `
            -Force `
            -Recurse `
            -ErrorAction:SilentlyContinue
New-Item -Path $installlocation `
         -ItemType Directory `
         -ErrorAction:SilentlyContinue
Move-Item -Path (Join-Path -Path $choco -ChildPath 'Calibre Portable\Calibre\*') `
          -Destination $installlocation `
          -Force

Write-Host "Cleaning up Staging folder ..."
Remove-Item -Force `
            -Recurse `
            -Path (Join-Path -Path $choco -ChildPath 'Calibre Portable')

# Generate a launch file
Write-Host "Generating Launch File"

@"
@echo ON

set CALIBRE_CONFIG_DIRECTORY=%APPDATA%\Calibre
Set CALIBRE_TEMP_DIR=%TEMP%

cd Calibre
set PATH=%cd%

START /belownormal Calibre.exe
"@ | Out-File -FilePath $launcher -Encoding ASCII

## install a shortcut to the start menu to make this app discoverable
[string]$shortcutFolder = Join-Path -Path "$($env:APPDATA)\Microsoft\Windows\Start Menu\Programs" `
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
                           -IconLocation (Join-Path -Path $installlocation -ChildPath 'Calibre.exe') `
                           -Description $shortcutDescription

# ignore all executables
Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    echo '' >"$($exe.FullName).ignore"
  }
