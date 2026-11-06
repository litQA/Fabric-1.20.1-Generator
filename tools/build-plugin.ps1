<#
.SYNOPSIS
    Builds the Fabric 1.20.1 generator plugin for MCreator 2026.3.

.DESCRIPTION
    The build counter is persisted in build-number.txt. Every invocation of
    this script consumes one build number, including failed builds: the next
    number and the matching pluginVersion are written before Gradle starts.

    All Gradle caches are redirected to <workspace>/caches/gradle. The Gradle
    distribution is the local reference_resources/gradle-9.8.0-bin.zip.

.PARAMETER GradleArgs
    Additional arguments passed to Gradle after exportPlugin.
#>
[CmdletBinding()]
param(
    [switch] $NewDelivery,
    [string[]] $GradleArgs = @()
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$workspaceRoot = Split-Path -Parent $repoRoot
$gradleProperties = Join-Path $repoRoot 'gradle.properties'
$buildNumberFile = Join-Path $repoRoot 'build-number.txt'

if (-not (Test-Path -LiteralPath $gradleProperties)) {
    throw "gradle.properties not found: $gradleProperties"
}

$javaHome = Join-Path $workspaceRoot 'jdk-25'
if (-not (Test-Path -LiteralPath (Join-Path $javaHome 'bin\javac.exe'))) {
    $javaHome = Join-Path $workspaceRoot 'MCreatorEAP2026344621\jdk'
}
if (-not (Test-Path -LiteralPath (Join-Path $javaHome 'bin\javac.exe'))) {
    throw 'No JDK found. Expected <workspace>/jdk-25 or <workspace>/MCreatorEAP2026344621/jdk.'
}

$cacheRoot = Join-Path $workspaceRoot 'caches\gradle'
New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null

$env:JAVA_HOME = $javaHome
$env:GRADLE_USER_HOME = $cacheRoot

$versionLine = Select-String -LiteralPath $gradleProperties -Pattern '^pluginVersion=' | Select-Object -First 1
if ($null -eq $versionLine) {
    throw "pluginVersion is missing from $gradleProperties"
}

$currentVersion = $versionLine.Line.Substring('pluginVersion='.Length).Trim()
$pattern = '^(?<major>\d{4}\.\d+)-(?<majorVersion>\d+)\.(?<minorVersion>\d+)\.(?<patch>\d+)\.(?<build>\d+)(?<suffix>-[A-Za-z]+)?$'
$match = [regex]::Match($currentVersion, $pattern)
if (-not $match.Success) {
    throw "Unsupported pluginVersion format: $currentVersion"
}

$currentBuild = 0
if (Test-Path -LiteralPath $buildNumberFile) {
    $currentBuild = [int64](Get-Content -LiteralPath $buildNumberFile -Raw).Trim()
}
$nextBuild = $currentBuild + 1
$nextPatch = [int]$match.Groups['patch'].Value
if ($NewDelivery) {
    $nextPatch++
}
$nextVersion = '{0}-{1}.{2}.{3}.{4}{5}' -f `
    $match.Groups['major'].Value,
    $match.Groups['majorVersion'].Value,
    $match.Groups['minorVersion'].Value,
    $nextPatch,
    $nextBuild,
    $match.Groups['suffix'].Value

# Persist the consumed build number before Gradle starts. A failed build still
# consumes the number, so the next invocation always moves forward.
$updated = foreach ($line in (Get-Content -LiteralPath $gradleProperties)) {
    if ($line -match '^pluginVersion=') {
        "pluginVersion=$nextVersion"
    }
    else {
        $line
    }
}
Set-Content -LiteralPath $gradleProperties -Value $updated -Encoding ascii
Set-Content -LiteralPath $buildNumberFile -Value $nextBuild -Encoding ascii

Write-Host "[build-plugin] MCreator plugin version: $nextVersion"
if ($NewDelivery) {
    Write-Host "[build-plugin] Delivery patch bumped: $($match.Groups['patch'].Value) -> $nextPatch"
}
Write-Host "[build-plugin] JAVA_HOME: $env:JAVA_HOME"
Write-Host "[build-plugin] GRADLE_USER_HOME: $env:GRADLE_USER_HOME"

$gradlew = Join-Path $repoRoot 'gradlew.bat'
$gradleExitCode = 1
Push-Location $repoRoot
try {
    $arguments = @(
        '-g', $cacheRoot,
        '--no-daemon',
        '--no-watch-fs',
        '--rerun-tasks',
        'exportPlugin'
    ) + $GradleArgs
    & $gradlew @arguments
    $gradleExitCode = $LASTEXITCODE
}
finally {
    Pop-Location
}

$artifact = Join-Path $repoRoot 'build\generator-fabric-1.20.1.zip'
if ($gradleExitCode -ne 0) {
    Write-Host "[build-plugin] Gradle failed with exit code $gradleExitCode"
    Write-Host "[build-plugin] Build number $nextBuild is consumed; the next build will use $($nextBuild + 1)."
    exit $gradleExitCode
}
if (-not (Test-Path -LiteralPath $artifact)) {
    throw "Expected artifact not found: $artifact"
}

Write-Host "[build-plugin] Artifact: $artifact"
Write-Host ("[build-plugin] SHA-256: " + (Get-FileHash -LiteralPath $artifact -Algorithm SHA256).Hash)
