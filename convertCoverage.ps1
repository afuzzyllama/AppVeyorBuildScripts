$coverageFile = $args[0]

$vsPath = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\14.0\", "ShellFolder", $null);
Add-Type -Path "$vsPath\Common7\IDE\PrivateAssemblies\Microsoft.VisualStudio.Coverage.Analysis.dll"

$coverageInfo = [Microsoft.VisualStudio.Coverage.Analysis.CoverageInfo]::CreateFromFile($coverageFile)
$data = $coverageInfo.BuildDataSet($null)
$data.ExportXml([string]::Format("{0}xml",$coverageFilePath))
