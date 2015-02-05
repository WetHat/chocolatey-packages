$installocation = Split-Path -parent $MyInvocation.MyCommand.Definition
$shortcutRegistered = Join-Path -Path $installocation -ChildPath 'shortcuts.txt'

# remove all registered shortcuts
Get-Content -LiteralPath $shortcutRegistered `
| ForEach-Object 
    echo "Removing Shortcut: $_"
    [System.IO.File]::Delete($_)
  }