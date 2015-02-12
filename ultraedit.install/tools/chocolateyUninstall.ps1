$packageName    = 'ultraedit.install'
$namePattern    = 'Ultraedit*'
$versionPattern = '21.30*'

Get-WmiObject -Class 'Win32_Product' `
| Where-Object { $_.Name -like $namePattern -and $_.Version -like $versionPattern } `
| ForEach-Object {
    Write-Host "Uninstalling $($_.Name) version $($_.Version)"
    $_.Uninstall()
  }