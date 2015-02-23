$installocation = Split-Path -parent $MyInvocation.MyCommand.Definition
$shortcutsRegistered = Join-Path -Path $installocation -ChildPath 'shortcuts.txt'

Get-Content -LiteralPath $shortcutsRegistered  -ErrorAction:SilentlyContinue `
| Where-Object { -not [string]::IsNullOrEmpty($_) } `
| ForEach-Object {
    Write-Host "Removing Shortcut: $_"
    Remove-Item -LiteralPath $_ -ErrorAction:SilentlyContinue
  }