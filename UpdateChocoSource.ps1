param (
  [string]$source = 'WetHat.dev'
)

$sourceLocation = choco source list | Where-Object {
                    $_.StartsWith($source) } `
                  | ForEach-Object {
                    $parts = [regex]::Split($_,"\s[-|]\s")
                    $parts[1]
                  }
# Process all folders and move dev packages to the given source
foreach ($dir in (Get-ChildItem $PSScriptRoot -Directory)) {
     choco list $dir.Name -s $source `
     | Where-Object { $_ -like '*packages found*'} `
     | ForEach-Object {
         $parts = $_ -split ' '
         if ([int]$parts[0] -gt 0) {
            Get-ChildItem $dir -File -Filter '*.nupkg'`
            | ForEach-Object {
                Write-Host "$($_.Name) -> $source"
                Move-Item $_.FullName -Destination $sourceLocation -Force
              } 
         }
       } 
}