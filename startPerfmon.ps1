. $env:BUILD_SCRIPTS_DIR\sharedFunctions.ps1

$outputFile = $args[0]

$version = Locate-VSVersion
$vsComnDir = [Environment]::GetEnvironmentVariable("VS$($version)COMNTools")
$vsperfcmd = "$($vsComnDir)..\..\Team Tools\Performance Tools\vsperfcmd.exe"


$vsPath = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\14.0\", "ShellFolder", $null);
Start-Process -FilePath $vsperfcmd -ArgumentList "/Start:coverage /Output:$outputFile" 

#wait for VSPerfCmd to start up
Write-Host "Waiting 5s for vsperfmon to start up..."
Start-Sleep -s 5

$counter = 0
while($counter -lt 6)
{
    $e = Start-Process -Verb runAs -FilePath $vsperfcmd -ArgumentList "/status" -PassThru -Wait

    if ($e.ExitCode -eq 0){
        break       
    }

    if ($e.ExitCode -eq 1 -and $counter -lt 5){
        Write-Host "Still waiting. Give it 5s more ($counter)..."
        Start-Sleep -s 5
        $counter++
        continue
    }
    else
    {
        Add-AppveyorMessage -Category Error -Message "Cannot start vsperfmon" 
        $host.SetShouldExit(1)
        exit 1
    }
}

