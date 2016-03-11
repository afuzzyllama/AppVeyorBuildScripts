. $env:BUILD_SCRIPTS_DIR\sharedFunctions.ps1

$version = Locate-VSVersion
$vsComnDir = [Environment]::GetEnvironmentVariable("VS$($version)COMNTools")
$vsperfcmd = "$($vsComnDir)..\..\Team Tools\Performance Tools\vsperfcmd.exe"

Start-Process -Verb runAs -FilePath $vsperfcmd -ArgumentList "/shutdown" 

Write-Host "Waiting 10s for vsperfmon to shutdown..."
Start-Sleep -s 10
