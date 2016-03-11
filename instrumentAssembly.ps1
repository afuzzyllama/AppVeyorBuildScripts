$assemblyToInstrument = $args[0]
<#
$vsPath = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\14.0\", "ShellFolder", $null);


if((Test-Path "$vsPath\Team Tools\Performance Tools\vsinstr.exe") -eq $false)
{
    Add-AppveyorMessage -Category Error -Message "Cannot find vsinstr.exe at '$vsPath\Team Tools\Performance Tools\vsinstr.exe'"
    exit 1
}
#>
function Locate-VSVersion()
{
	#Find the latest version
	$regPath = "HKLM:\SOFTWARE\Microsoft\VisualStudio"
	if (-not (Test-Path $regPath))
	{
		return $null
	}
	
	$keys = Get-Item $regPath | %{$_.GetSubKeyNames()} -ErrorAction SilentlyContinue
	$version = Get-SubKeysInFloatFormat $keys | Sort-Object -Descending | Select-Object -First 1

	if ([string]::IsNullOrWhiteSpace($version))
	{
		return $null
	}
	return $version
}

function Get-SubKeysInFloatFormat($keys)
{
	[decimal]$decimalKey
	$targetKeys = @()      # New array
	foreach ($key in $keys)
	{
		if([decimal]::TryParse($key, $decimalKey) -eq $true)
		{
			$targetKeys += [decimal] $decimalKey
		}
	}

	return $targetKeys
}


$version = Locate-VSVersion
$vsComnDir = [Environment]::GetEnvironmentVariable([string]::Format("VS{0}0COMNTools", $version))
$vsinstr = "$vsComnDir\..\Team Tools\Performance Tools\vsinstr.exe"

if((Test-Path $vsinstr) -eq $false)
{
    Add-AppveyorMessage -Category Error -Message "Cannot find vsinstr at '$vsinstr'"
}

Start-Process -FilePath $vsinstr -ArgumentList "-coverage $assemblyToInstrument" -NoNewWindow -Wait

if((Test-Path "$assemblyToInstrument.orig") -eq $false)
{
    Add-AppveyorMessage -Category Error -Message "$assemblyToInstrument was not instrumented"
}
