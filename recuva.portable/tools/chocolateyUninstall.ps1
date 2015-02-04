$installocation = Split-Path -parent $MyInvocation.MyCommand.Definition
$shortcutRegistered = Join-Path -Path $installocation -ChildPath 'shortcut.txt'
[System.IO.FileInfo]$shortcut = Get-Content -LiteralPath $shortcutRegistered
echo "Removing Start Menu Shortcut $($shortcut.Name)"
if ($shortcut.Exists)
{
  $shortcut.Delete()
}