$assemblyToInstrument = $args[0]
$vsPath = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\14.0\", "ShellFolder", $null);


if((Test-Path "$vsPath\Team Tools\Performance Tools\vsinstr.exe") -eq $false)
{
    Add-AppveyorMessage -Category Error -Message "Cannot find vsinstr.exe at '$vsPath\Team Tools\Performance Tools\vsinstr.exe'"
}

Start-Process -FilePath "$vsPath\Team Tools\Performance Tools\vsinstr.exe" -ArgumentList "-coverage $assemblyToInstrument" -NoNewWindow -Wait

if((Test-Path "$assemblyToInstrument.orig") -eq $false)
{
    Add-AppveyorMessage -Category Error -Message "$assemblyToInstrument was not instrumented"
}
