$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Steel Bank Common Lisp'
  fileType      = 'MSI' #only one of these: MSI or EXE (ignore MSU for now)
  # MSI
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1605, 1614, 1641) # https://msdn.microsoft.com/en-us/library/aa376931(v=vs.85).aspx
 
}
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | % {
    $packageArgs['file'] = "$($_.UninstallString)" #NOTE: You may need to split this if it contains spaces, see below

    if ($packageArgs['fileType'] -eq 'MSI') {
      $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"

      $packageArgs['file'] = ''

    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}

$sbclhome = $env:SBCL_HOME
$target = join-Path $sbclhome 'sbcl.exe'
Uninstall-ChocolateyEnvironmentVariable -VariableName 'SBCL_HOME' -VariableType 'Machine'
Uninstall-BinFile -Name 'sbcl' -Path $target

$shortcut = Join-Path [environment]::GetFolderPath([environment+specialfolder]::Programs) 'sbcl'
Remove-Item $shortcut -Force
