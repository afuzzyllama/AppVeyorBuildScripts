$vsPath = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\14.0\", "ShellFolder", $null);
Start-Process -Verb runAs -FilePath "$vsPath\Team Tools\Performance Tools\vsperfcmd.exe" -ArgumentList "/shutdown" 

Get-job | Remove-Job

Write-Host "Waiting 10s for vsperfmon to shutdown..."
Start-Sleep -s 10
