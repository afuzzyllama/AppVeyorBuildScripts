$nuspecFile = $args[0]

$nuspecXml = [xml](Get-Content $nuspecFile)
$nuspecXml.package.metadata.version = $env:APPVEYOR_BUILD_VERSION
$nuspecXml.Save($nuspecFile)

nuget pack $nuspecFile
