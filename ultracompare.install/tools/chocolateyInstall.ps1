$packageName    = 'ultracompare.install'
$installerType  = 'MSI' #only one of these: exe, msi, msu
$url            = 'http://www.ultraedit.com/files/msii/uc_english.msi' # download url
$silentArgs     = '/qn /norestart'
$validExitCodes = @(0)
$installlocation= Split-Path -parent $MyInvocation.MyCommand.Definition

Install-ChocolateyPackage -packageName   $packageName `
                          -FileType      'MSI'        `
                          -SilentArgs     $silentArgs `
                          -Url            $url `
                          -Checksum       '57DDD8222136674B996387BBC7FED412200429C7BB704C883E365723923C3144' `
                          -ChecksumType   'sha256' `
                          -validExitCodes $validExitCodes
