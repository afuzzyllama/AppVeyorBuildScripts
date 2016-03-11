$vsPath = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\14.0\", "ShellFolder", $null);

Start-Job -ArgumentList $args[0] -scriptblock { 

    $outputFile = $args[0]
    $vsPath = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\14.0\", "ShellFolder", $null);
    Start-Process -Verb runAs -FilePath "$vsPath\Team Tools\Performance Tools\vsperfcmd.exe" -ArgumentList "/Start:coverage /Output:$outputFile /CrossSession /User:Everyone" 

} 

#wait for VSPerfCmd to start up
Write-Host "Waiting 5s for vsperfmon to start up..."
Start-Sleep -s 5

$counter = 0
while($counter -lt 6)
{
    $e = Start-Process -Verb runAs -FilePath "$vsPath\Team Tools\Performance Tools\vsperfcmd.exe" -ArgumentList "/status" -PassThru -Wait

    if ($e.ExitCode -eq 0){
        break       
    }

    if ($e.ExitCode -eq 1 -and $counter -lt 5){
        Write-Host "Still waiting. Give it 5s more ($counter)..."
        Start-Sleep -s 5
        $counter++
        continue
    }

    Add-AppveyorMessage -Category Error -Message "Cannot start vsperfmon" 
    $host.SetShouldExit(1)
}

