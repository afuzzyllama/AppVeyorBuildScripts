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
