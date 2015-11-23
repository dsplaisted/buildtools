param([string]$RepoRoot = "", [string]$DotNetCliBin = "", [string]$TargetFramework = "net45")

$buildToolsProjectJson = "$PSScriptRoot\project.json"
$packagesDir = $RepoRoot + '\packages\'
$buildToolsDir = $packagesDir + 'Microsoft.DotNet.BuildTools\' + $TargetFramework
$buildToolsSemaphore = $buildToolsDir + '\BuildTools.semaphore'

If (-Not (Test-Path ($buildToolsSemaphore) -PathType Leaf)) {
	& "$DotNetCliBin\dotnet-restore" $buildToolsProjectJson

	# dotnet-publish calls dotnet-compile which uses the current directory instead of taking a path
	$oldLocation = Get-Location
	Set-Location $PSScriptRoot

	Write-Output "Running $DotNetCliBin\dotnet-publish -f $TargetFramework -r win7-x64 -o $buildToolsDir"
	& "$DotNetCliBin\dotnet-publish" -f $TargetFramework -r win7-x64 -o $buildToolsDir

	Set-Location $oldLocation

	# Create Semaphore file to indicate that BuildTools is restored
	# Ideally we should use a version-specific semaphore and delete and re-restore the build tools if the version referenced has changed
    New-Item ($buildToolsSemaphore) -ItemType File
}