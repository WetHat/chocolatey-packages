$packageName    = 'ultracompare.install'
$namePattern    = 'UltraCompare*'

Get-WmiObject -Class 'Win32_Product' `
| Where-Object { $_.Name -like $namePattern } `
| ForEach-Object {
    Write-Host "Uninstalling $($_.Name) version $($_.Version)"
    $_.Uninstall()
  }