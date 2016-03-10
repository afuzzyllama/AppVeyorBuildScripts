<#
    This script will take all the files located in a directory named "ReleaseContents" in the build staging directory and place them in a zip file in the
    staging directory with a name  in the following format:

        RepoName.Major.Minor.BuildId.SourceVersion.zip
#>

Add-Type -Assembly System.IO.Compression.FileSystem
$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal

[System.IO.Compression.ZipFile]::CreateFromDirectory("$env:STAGING_DIR\ReleaseContents", ([string]::Format("{0}\{1}.{2}.zip", $env:STAGING_DIR, $env:APPVEYOR_PROJECT_NAME, $env:APPVEYOR_BUILD_VERSION)), $compressionLevel, $false <# include base directory? #>)
