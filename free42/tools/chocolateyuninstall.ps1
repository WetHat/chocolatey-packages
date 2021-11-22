$toolsDir         = Split-Path -Parent `
                               -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$shortcutRegistry = Join-Path -Path $toolsDir   -ChildPath 'shortcuts.txt'

Get-Content -LiteralPath $shortcutRegistry -ErrorAction:SilentlyContinue `
| Where-Object { -not [string]::IsNullOrEmpty($_) } `
| ForEach-Object {
    Write-Host "Removing Shortcut: $_"
    Remove-Item -LiteralPath $_ -ErrorAction:SilentlyContinue
  }
  
Write-Host "Cleaning up $toolsDir ..."
Remove-Item -Force `
            -Recurse `
            -Exclude '*.nupkg','*install.ps1' `
            -LiteralPath $toolsDir