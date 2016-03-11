$coverageXml = $args[0]

$coveralls = "$env:DEPENDENCIES_DIR\coveralls.net\src\csmacnz.Coveralls\bin\Debug\csmacnz.Coveralls.exe"
& $coveralls --exportcodecoverage -i $coverageXml -o $coverageXml.json --useRelativePaths --repoToken $env:COVERALLS_REPO_TOKEN 
