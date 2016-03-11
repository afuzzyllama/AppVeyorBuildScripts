<#
    Script to install the most current version of ImageMagick on agent
#>
$ErrorActionPreference = "Stop"
Write-Host "Getting latest version of ImageMagick"

Add-Type -Assembly System.IO.Compression.FileSystem

$archiveContentFile = "$env:TEMP_DIR\content.html"
$dependenciesDir = "$env:DEPENDENCIES_DIR\ImageMagick"

# Create the dependencies directory if it does not exist 
if(!(Test-Path -Path $dependenciesDir))
{
    New-Item -ItemType directory -Path $dependenciesDir | Out-Null
}

# Fetch the download page from imagemagick.org
wget -OutFile $archiveContentFile http://www.imagemagick.org/script/binary-releases.php

# Parse out the current version of the ImageMagick
$regex = "http://www.imagemagick.org/download/binaries/ImageMagick-[0-9]+\.[0-9]+\.[0-9]+-[0-9]+-portable-Q16-x86\.zip"
$currentDownloadLink = Select-String -Path $archiveContentFile -Pattern $regex -AllMatches | Select-Object -First 1 | %{$_.Matches} | %{$_.Value}

$regex = "ImageMagick-[0-9]+\.[0-9]+\.[0-9]+-[0-9]+-portable-Q16-x86"
$currentVersion = $currentDownloadLink | Select-String -Pattern $regex -AllMatches  | Select-Object -First 1 | %{$_.Matches} | %{$_.Value}

Remove-Item -Path $archiveContentFile

if(!($currentVersion))
{
    Add-AppveyorMessage -Category Error -Message "Cannot obtain the most current version of ImageMagick."  
    $host.SetShouldExit(1)
}
    
# Download ImageMagick
wget -OutFile "$env:TEMP_DIR\$currentVersion.zip" $currentDownloadLink 

# Install ImageMagick 
[System.IO.Compression.ZipFile]::ExtractToDirectory("$env:TEMP_DIR\$currentVersion.zip", "$dependenciesDir")

Add-AppveyorMessage -Category Information -Message "Installed: $currentVersion"
