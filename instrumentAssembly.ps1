. $env:BUILD_SCRIPTS_DIR\sharedFunctions.ps1

$assemblyToInstrument = $args[0]

$version = Locate-VSVersion
$vsComnDir = [Environment]::GetEnvironmentVariable("VS$($version)COMNTools")
$vsinstr = "$($vsComnDir)..\..\Team Tools\Performance Tools\vsinstr.exe"

if((Test-Path $vsinstr) -eq $false)
{
    Add-AppveyorMessage -Category Error -Message "Cannot find vsinstr at '$vsinstr'"
    $host.SetShouldExit(1)
}

Start-Process -FilePath $vsinstr -ArgumentList "-coverage $assemblyToInstrument" -NoNewWindow -Wait

if((Test-Path "$assemblyToInstrument.orig") -eq $false)
{
    Add-AppveyorMessage -Category Error -Message "$assemblyToInstrument was not instrumented"
    $host.SetShouldExit(1)
}
