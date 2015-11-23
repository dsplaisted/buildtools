param([string]$ProjectDir = "")

function RestoreToolRuntime
{
    $toolRuntimeProjectJson = $BuildToolsDir + 'tool-runtime\project.json'
    & $dotNetCmd restore $toolRuntimeProjectJson
    & $dotNetCmd publish $toolRuntimeProjectJson -f dnxcore50 -r win7-x64 -o $ToolRuntimeDir

    # Create Semaphore file to indicate that ToolRuntime is restored
    New-Item ($ToolRuntimeDir + '\ToolRuntime.semaphore') -ItemType File
}

$ToolRuntimeDir = $ProjectDir + '\bin\obj\Windows_NT.AnyCPU.Debug\ToolRuntime'

If (-Not (Test-Path ($ToolRuntimeDir + '\ToolRuntime.semaphore') -PathType Leaf)) { RestoreToolRuntime }