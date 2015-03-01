$packageName       = 'calibre.portable' # arbitrary name for the package, used in messages
$url               = 'http://download.calibre-ebook.com/2.20.0/calibre-portable-installer-2.20.0.exe' # download url
$installlocation   = Split-Path -parent $MyInvocation.MyCommand.Definition
$shortcutLocation  = 'Microsoft\Windows\Start Menu\Programs\Chocolatey'
$shortcutRegistry  = 'shortcuts.txt' # we register shortcuts for removal on uninstall here
$selfExtractingExe = Join-Path -Path $installlocation -ChildPath 'calibre-portable-installer.exe'
$validExitCodes    = @(0)
$launcher          = Join-Path -path $installlocation -ChildPath 'calibre-portable.bat'
$shortcutName      = 'Calibre.lnk'

# main helpers - these have error handling tucked into them already
# installer, will assert administrative rights
# Download the self-extracting archive
Get-ChocolateyWebFile $packageName $selfExtractingExe $url 
# .. and run it to extract
Write-Host "Extracting $packageName ..."
Start-ChocolateyProcessAsAdmin $env:TEMP $selfExtractingExe -validExitCodes $validExitCodes

$stagingFolder = (Join-Path -Path $env:TEMP -ChildPath 'Calibre Portable')

Move-Item -Path (Join-Path -Path $stagingFolder -ChildPath '*') `
          -Destination $installlocation

# remove the staging folder 
Remove-Item -LiteralPath $stagingFolder -ErrorAction:SilentlyContinue

# remove the selfextracting exe
Remove-Item -LiteralPath $selfExtractingExe -ErrorAction:SilentlyContinue

# Generate a launch file
@"
@echo ON

set CALIBRE_CONFIG_DIRECTORY=%APPDATA%\Calibre
Set CALIBRE_TEMP_DIR=%TEMP%

cd Calibre
set PATH=%cd%
echo %cd%	
START /belownormal Calibre.exe
"@ | Out-File -FilePath $launcher -Encoding ASCII
  
## install a shortcut to the start menu to make this app discoverable
[string]$shortcutFolder = Join-Path -Path $env:ALLUSERSPROFILE `
                                    -ChildPath $shortcutLocation
[string]$shortcut       = Join-Path -Path $shortcutFolder `
                                    -ChildPath $shortcutName
# register shortcut for removal on uninstall
Out-File -InputObject $shortcut `
         -Append `
         -FilePath (Join-Path -Path $installlocation -ChildPath $shortcutRegistry)
if (![System.IO.Directory]::Exists( $shortcutFolder))
{
  [System.IO.Directory]::CreateDirectory($shortcutFolder) >$null
}

<# TODO: use this when it becomes available in chocolatey
Install-ChocolateyShortcut -ShortcutFilePath $shortcut `
                            -WorkingDirectory $exe.FullName
                            ...
#>
try
{
    $wscript = New-Object -ComObject WScript.Shell
    $lnk =  $wscript.CreateShortcut($shortcut)
    $lnk.TargetPath       = $launcher
    $lnk.WorkingDirectory = $installlocation
    $lnk.Description      = 'Calibre e-book library manager'
    $lnk.IconLocation     = "$(Join-Path -Path $installlocation -ChildPath 'Calibre\Calibre.exe'),0"
    $lnk.WindowStyle      = 7 # 7 = minimized; 1 = normal
    $lnk.Save()
    Write-Host "Created Start Menu Shortcut: $shortcutname"
}
catch
{
  Write-Host 'Shortcut creation failed..'
  # It is not a showstopper, if shortcut creation fails
}

# ignore all executables
Get-ChildItem -Name $installlocation -filter '*.exe' -Recurse `
| ForEach-Object {
    [System.IO.FileInfo]$exe = Join-Path -Path $installlocation -ChildPath $_
    echo '' >"$($exe.FullName).ignore"
  }