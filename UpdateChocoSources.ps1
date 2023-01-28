param (
  [string]$source = 'WetHat.dev' # private source name
)

[string]$apikey = Get-Content ghk.txt

######################################
# The list of packages for Chocolatey.
######################################
$chocoPackages = @(
    'apache-netbeans.portable'
    'instantwordpress'
    'sbcl'
    'ssd-z.portable'
    'free42'
    'onenote-taggingkit-addin.install'
)

################################################
# The list of packages for the local repository.
################################################
$devPackages = @(
    'testdisk-photorec.portable'
    'plus42'
    'licensecrawler.portable'
    'nirsoft-ntfslinksview.portable'
    'nirsoft-alternatestreamview.portable'
    'mitec-registryrecovery.portable'
)

####################################################

Write-Information "*** Updating $source package repository" -InformationAction Continue

# Location of the private repository on disk
$sourceLocation = choco source list | Where-Object {
                    $_.StartsWith($source) } `
                  | ForEach-Object {
                    $parts = [regex]::Split($_,"\s[-|]\s")
                    $parts[1]
                  }

# Process all folders and move dev packages to the given source
foreach ($package in $devPackages) {
    if (Test-Path -Path "$package/*.nupkg") {
        Write-Information "$package/*.nupkg -> $source" -InformationAction Continue
        Move-Item -Path "$package/*.nupkg" -Destination $sourceLocation -Force
    } else {
        Write-Information "No nupkg found for package '$package'" -InformationAction Continue
    }
}
Write-Information ([System.Environment]::NewLine) -InformationAction Continue
Write-Information '*** Pushing Chocolatey packages (choco push)' -InformationAction Continue

foreach ($package in $chocoPackages) {
    # read the nuspec file to determine the version
    $nuspec = "${package}/${package}.nuspec"
    if (Test-Path -Path $nuspec) {
         [xml]$nuspecXML = Get-Content -Path $nuspec
         $version = $nuspecXML.package.metadata.version
         $nupkg="${package}/${package}.$version.nupkg"
         if (Test-Path -Path $nupkg) {
            choco push $nupkg --api-key $apikey
            if ($?) {
                Write-Information "$nupkg -> Chocolatey" -InformationAction Continue
                Remove-Item -Path $nupkg
            } else {
                Write-Error "$nupkg -> Chocolatey failed!" -InformationAction Continue
            }
        } else {
            Write-Information "No nupkg found for version $version of package '$package'" -InformationAction Continue
        }
    }
}