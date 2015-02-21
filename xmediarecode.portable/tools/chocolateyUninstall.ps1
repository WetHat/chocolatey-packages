$installocation = Split-Path -parent $MyInvocation.MyCommand.Definition
$shortcutRegistry = Join-Path -Path $installocation -ChildPath 'shortcuts.txt'

Get-Content -LiteralPath $shortcutRegistry -ErrorAction:SilentlyContinue `
| Where-Object { -not [string]::IsNullOrEmpty($_) } `
| ForEach-Object {
    echo "Removing Shortcut: $_"
    Remove-Item -LiteralPath $_ -ErrorAction:SilentlyContinue
  }