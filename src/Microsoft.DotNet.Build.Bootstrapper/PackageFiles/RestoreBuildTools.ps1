param([string]$RepoRoot = "", [string]$DotNetCliBin = "", [string]$TargetFramework = "net46")

$buildToolsProjectJson = "$PSScriptRoot\project.json"
$packagesDir = $RepoRoot + '\packages\'
$buildToolsDir = $packagesDir + 'Microsoft.DotNet.BuildTools\' + $TargetFramework
$buildToolsSemaphore = $buildToolsDir + '\BuildTools.semaphore'
$portableTargetsVersion = "0.1.1-dev"

If (-Not (Test-Path ($buildToolsSemaphore) -PathType Leaf)) {
	& "$DotNetCliBin\dotnet-restore" $buildToolsProjectJson

	# dotnet-publish calls dotnet-compile which uses the current directory instead of taking a path
	$oldLocation = Get-Location
	Set-Location $PSScriptRoot

	Write-Output "Running $DotNetCliBin\dotnet-publish -f $TargetFramework -r win7-x64 -o $buildToolsDir"
	& "$DotNetCliBin\dotnet-publish" -f $TargetFramework -r win7-x64 -o $buildToolsDir

	Set-Location $oldLocation


	# The .NET CLI doesn't yet support NuGet package contentFiles (a new feature in NuGet 3.3)
	# So here, we explicitly copy the portable targets from the NuGet package to the extensions folder
	if ($TargetFramework -eq "dnxcore50")
	{
		$PortableTargetsProjectJson = $RepoRoot + '\bin\obj\bootstrap\PortableTargets\project.json'

		$json = @"
{
"dependencies": {
	"Microsoft.Portable.Targets": "$portableTargetsVersion"
},
"frameworks": {
	"dnxcore50": { },
	"net46": { }
}
}
"@

		$jsonFolder = Split-Path -Parent $PortableTargetsProjectJson
		If (-Not (Test-Path $jsonFolder -PathType Container)) {
			New-Item -ItemType Directory -Force -Path $jsonFolder
		}
	
		Set-Content $PortableTargetsProjectJson $json
		
		& "$DotNetCliBin\dotnet-restore" $PortableTargetsProjectJson --packages $packagesDir
		
		$PortableExtensions = $packagesDir + "Microsoft.Portable.Targets\$portableTargetsVersion\contentFiles\any\any\Extensions"
		
		Copy-Item $PortableExtensions $buildToolsDir -recurse -force		
	}

	# Create Semaphore file to indicate that BuildTools is restored
	# Ideally we should use a version-specific semaphore and delete and re-restore the build tools if the version referenced has changed
    New-Item ($buildToolsSemaphore) -ItemType File
}