nuget.exe restore $env:DEPENDENCIES_DIR\coveralls.net\src\csmacnz.Coveralls.sln -Verbosity quiet
msbuild $env:DEPENDENCIES_DIR\coveralls.net\src\csmacnz.Coveralls.sln /logger:"C:\Program Files\AppVeyor\BuildAgent\Appveyor.MSBuildLogger.dll" /p:Configuration=Release /p:Platform="Any CPU" /v:minimal
Add-AppveyorMessage -Category Information -Message "Installed: Coveralls.NET develop branch"
       
