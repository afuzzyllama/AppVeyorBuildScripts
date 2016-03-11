$assemblyToInstrument = $args[0]

function Locate-VSVersion()
{
	#Find the latest version
	$regPath = "HKLM:\SOFTWARE\Microsoft\VisualStudio"
	if (-not (Test-Path $regPath))
	{
		return $null
	}
	
	$keys = Get-Item $regPath | %{$_.GetSubKeyNames()} -ErrorAction SilentlyContinue
	$version = Get-LatestVersion $keys

	if ([string]::IsNullOrWhiteSpace($version))
	{
		return $null
	}
	return $version
}

function Get-LatestVersion($keys)
{
	[decimal]$decimalKey = $null
	[decimal]$latestVersion = 0.0
	[string]$latestVersionString = "00"
	foreach ($key in $keys)
	{
		if([decimal]::TryParse($key, [ref]$decimalKey) -eq $true)
		{
			if($latestVersion -lt $decimalKey)
			{
				$latestVersion = $decimalKey
				$latestVersionString = $key.Replace(".", "")
			}
		}
	}

	return $latestVersionString
}

$version = Locate-VSVersion
Write-Host "VS$($version)COMNTools"
$vsComnDir = [Environment]::GetEnvironmentVariable("VS$($version)COMNTools")
Write-Host [Environment]::GetEnvironmentVariable("VS$($version)COMNTools")
$vsinstr = "$vsComnDir\..\Team Tools\Performance Tools\vsinstr.exe"
Write-Host $vsinstr

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
