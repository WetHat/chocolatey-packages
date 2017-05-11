$packageName   = 'onenote-taggingkit-addin.install'
$installVersion='3.0.6257.15479'
$silentArgs    = '/qn /norestart'
$validExitCodes = @(0)
$tools=Split-Path -Parent $MyInvocation.MyCommand.Definition
$installer='SetupTaggingKitWiX.3.0.6257.15479.msi'

Install-ChocolateyInstallPackage -packageName   $packageName `
                          -FileType      'MSI'               `
                          -File           (Join-Path $tools "SetupTaggingKitWiX.$installVersion.msi") `
                          -SilentArgs     $silentArgs  `
                          -validExitCodes $validExitCodes
