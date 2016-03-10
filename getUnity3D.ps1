<#
    Script to install the latest version of Unity3D on agent
#>

$archiveContentFile = "$env:TEMP_DIR\content.html"
$dependenciesDir = "$env:DEPENDENCIES_DIR\Unity"

Write-Host "Checking for latest version of Unity3D"

# Create the dependencies directory if it does not exist 
if(!(Test-Path -Path $dependenciesDir))
{
    New-Item -ItemType directory -Path $dependenciesDir | Out-Null
}

# Fetch the download archieve page from unity3d.com
wget -OutFile $archiveContentFile https://unity3d.com/get-unity/download/archive

# Parse out the current version of the Unity3D editor
$regex = "http://netstorage.unity3d.com/unity/[a-z0-9]+/Windows32EditorInstaller/UnitySetup32-[0-9]+\.[0-9]+\.[0-9]+f[0-9]+\.exe"
$currentDownloadLink = Select-String -Path $archiveContentFile -Pattern $regex -AllMatches | Select-Object -First 1 | %{$_.Matches} | %{$_.Value}

$regex = "http://netstorage.unity3d.com/unity/[a-z0-9]+"
$currentRevision = $currentDownloadLink | Select-String -Pattern $regex -AllMatches | Select-Object -First 1 | %{$_.Matches} | %{$_.Value}

$lastSlashPos = $currentRevision.LastIndexOf("/");
$currentRevision = $currentRevision.Substring($lastSlashPos + 1)

$regex = "UnitySetup32-[0-9]+\.[0-9]+\.[0-9]+f[0-9]+"
$currentVersion = $currentDownloadLink | Select-String -Pattern $regex -AllMatches  | Select-Object -First 1 | %{$_.Matches} | %{$_.Value}

$regex = "[0-9]+\.[0-9]+\.[0-9]+f[0-9]+"
$currentVersionNumber = $currentVersion | Select-String -Pattern $regex -AllMatches  | Select-Object -First 1 | %{$_.Matches} | %{$_.Value}

Remove-Item -Path $archiveContentFile

if(!($currentVersionNumber))
{
    Add-AppveyorMessage -Category Error -Message "Cannot obtain the most current version of Unity3D."  
}

# Download Unity3D editor and Windows build support
wget -OutFile "$env:TEMP_DIR\$currentVersion.exe" $currentDownloadLink 
wget -OutFile "$env:TEMP_DIR\UnitySetup-Windows-Support-for-Editor-$currentVersionNumber.exe" "http://netstorage.unity3d.com/unity/$currentRevision/TargetSupportInstaller/UnitySetup-Windows-Support-for-Editor-$currentVersionNumber.exe"

# Install Unity3D editor and Windows build support
Start-Process -Wait -FilePath "$env:TEMP_DIR\$currentVersion.exe" -ArgumentList "/S /D=$dependenciesDir"
Start-Process -Wait -FilePath "$env:TEMP_DIR\$currentVersion\UnitySetup-Windows-Support-for-Editor-$currentVersionNumber.exe" -ArgumentList "/S /D=$dependenciesDir"

Add-AppveyorMessage -Category Information -Message "Installed: $currentVersion"
