<#
.SYNOPSIS
    Regenerates a workspace with the built Fabric 1.20.1 generator under MCreator 2026.3.

.DESCRIPTION
    This is a thin wrapper around the headless GenHarness used by the migration
    work. The harness and the MCreator application classes are test assets of
    the workspace and are not part of the plugin ZIP. The plugin ZIP and the
    workspace are provided explicitly so the script stays independent from the
    legacy _verify layout.

.PARAMETER Workspace
    Path to a .mcreator workspace file or to the workspace directory.

.PARAMETER PluginZip
    Plugin ZIP to install into the isolated smoke-test plugin folder.

.PARAMETER MCreatorPath
    MCreator 2026.3 EAP installation directory (contains jdk/, lib/, plugins/).
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string] $Workspace,
    [string] $PluginZip = '',
    [string] $MCreatorPath = '',
    [string] $HarnessDir = '',
    [string] $AppDir = '',
    [string] $GradleCacheJson = ''
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$workspaceRoot = Split-Path -Parent $repoRoot

if (-not $PluginZip) {
    $PluginZip = Join-Path $repoRoot 'build\generator-fabric-1.20.1.zip'
}
if (-not $MCreatorPath) {
    $MCreatorPath = Join-Path $workspaceRoot 'MCreatorEAP2026344621'
}
if (-not $HarnessDir) {
    $HarnessDir = Join-Path $workspaceRoot '_verify\harness-2026.3'
}
if (-not $AppDir) {
    $AppDir = Join-Path $workspaceRoot '_verify\app-2026.3'
}
if (-not $GradleCacheJson) {
    $GradleCacheJson = Join-Path $workspaceRoot '_verify\gradle-cache.json'
}

if (-not (Test-Path -LiteralPath $PluginZip)) {
    throw "Plugin ZIP not found: $PluginZip"
}
if (-not (Test-Path -LiteralPath (Join-Path $HarnessDir 'GenHarness.class'))) {
    throw "GenHarness.class not found in: $HarnessDir"
}
if (-not (Test-Path -LiteralPath $AppDir)) {
    throw "MCreator 2026.3 application classes not found in: $AppDir"
}
if (-not (Test-Path -LiteralPath $MCreatorPath)) {
    throw "MCreator path not found: $MCreatorPath"
}

$workspaceFile = $Workspace
if (Test-Path -LiteralPath $Workspace -PathType Container) {
    $candidate = Get-ChildItem -LiteralPath $Workspace -Filter '*.mcreator' -File | Select-Object -First 1
    if ($null -eq $candidate) {
        throw "No .mcreator file found in workspace directory: $Workspace"
    }
    $workspaceFile = $candidate.FullName
}
if (-not (Test-Path -LiteralPath $workspaceFile)) {
    throw "Workspace file not found: $workspaceFile"
}

$smokeRoot = Join-Path $workspaceRoot 'caches\smoke'
$workDir = Join-Path $smokeRoot 'workdir'
$workPlugins = Join-Path $workDir 'plugins'
$mcreatorHome = Join-Path $smokeRoot 'mcreator-home'
$emptyPlugins = Join-Path $smokeRoot 'empty-plugins'
$tmpFolder = Join-Path $smokeRoot 'tmp'
if (Test-Path -LiteralPath $workDir) {
    Remove-Item -LiteralPath $workDir -Recurse -Force
}
New-Item -ItemType Directory -Path $workPlugins -Force | Out-Null
New-Item -ItemType Directory -Path $mcreatorHome -Force | Out-Null
New-Item -ItemType Directory -Path $emptyPlugins -Force | Out-Null
New-Item -ItemType Directory -Path $tmpFolder -Force | Out-Null

# Copy only the MCreator platform plugins needed by the harness. Do not copy
# other generator plugins: an installed 1.21.x generator could provide the same
# common.*.yaml base-type definitions and shadow the 1.20.1 definitions.
foreach ($platformPlugin in @('mcreator-core.zip', 'mcreator-localization.zip', 'mcreator-themes.zip', 'mcreator-link.zip', 'forge-config-api-port.zip')) {
    $source = Join-Path $MCreatorPath "plugins\$platformPlugin"
    if (Test-Path -LiteralPath $source) {
        Copy-Item -LiteralPath $source -Destination $workPlugins
    }
}
Copy-Item -LiteralPath $PluginZip -Destination (Join-Path $workPlugins (Split-Path -Leaf $PluginZip))

$java = Join-Path $MCreatorPath 'jdk\bin\java.exe'
if (-not (Test-Path -LiteralPath $java)) {
    $java = Join-Path $MCreatorPath 'jdk\bin\java'
}
if (-not (Test-Path -LiteralPath $java)) {
    throw "No Java executable found under: $MCreatorPath\jdk"
}

$classpath = "$HarnessDir;$AppDir;$(Join-Path $MCreatorPath 'lib\*')"

$env:JAVA_TOOL_OPTIONS = "-Djna.tmpdir=$tmpFolder -Djava.io.tmpdir=$tmpFolder"
$env:MCREATOR_PLUGINS_FOLDER = $emptyPlugins
$env:MCREATOR_HOME = $mcreatorHome
if (Test-Path -LiteralPath $GradleCacheJson) {
    $env:GEN_GRADLE_CACHE_JSON = $GradleCacheJson
}

Write-Host "[smoke-test] workspace: $workspaceFile"
Write-Host "[smoke-test] plugin: $PluginZip"
Write-Host "[smoke-test] MCreator: $MCreatorPath"

Push-Location $workDir
try {
    & $java --add-opens java.base/java.lang=ALL-UNNAMED --enable-native-access=ALL-UNNAMED `
        -cp $classpath GenHarness $workspaceFile load
    exit $LASTEXITCODE
}
finally {
    Pop-Location
}
