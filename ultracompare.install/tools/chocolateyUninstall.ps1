$namePattern    = 'UltraCompare*'

Get-WmiObject -Class 'Win32_Product' `
| Where-Object { $_.Name -like $namePattern  } `
| ForEach-Object {
    $retcode = $_.Uninstall()
    if ($retcode.ReturnValue -ne 0)
    {
      throw "Uninstallation of $($_.Name) - $($_.Version) failed with error code: $($retcode.ReturnValue)"
    } 
    Write-Host "Uninstalled $($_.Name) - $($_.Version)"
  }