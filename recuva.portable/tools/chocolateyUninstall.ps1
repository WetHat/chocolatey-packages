$appBase          = Split-Path -Parent `
                               -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$installlocation  = Join-Path -Path $appBase -ChildPath 'App'
$shortcutRegistry = Join-Path -Path $appBase -ChildPath 'shortcuts.txt'

Get-Content -LiteralPath $shortcutRegistry -ErrorAction:SilentlyContinue `
| Where-Object { -not [string]::IsNullOrEmpty($_) } `
| ForEach-Object {
    Write-Host "Removing Shortcut: $_"
    Remove-Item -LiteralPath $_ -ErrorAction:SilentlyContinue
  }
