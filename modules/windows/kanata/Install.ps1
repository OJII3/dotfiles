[CmdletBinding()]
param(
    [Parameter()]
    [string]$InstallDir = (Join-Path -Path $HOME -ChildPath '.local\bin'),

    [Parameter()]
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$binaryName = 'kanata.exe'
$destPath = Join-Path -Path $InstallDir -ChildPath $binaryName

if ((Test-Path -LiteralPath $destPath) -and -not $Force) {
    Write-Host "$binaryName is already installed at $destPath. Use -Force to overwrite." -ForegroundColor Yellow
    return
}

$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/jtroo/kanata/releases/latest'
$tag = $release.tag_name
Write-Host "Latest kanata release: $tag" -ForegroundColor Cyan

$arch = if ([Environment]::Is64BitOperatingSystem) { 'x64' } else { 'arm64' }
$assetName = "windows-binaries-$arch.zip"
$asset = $release.assets | Where-Object { $_.name -eq $assetName }

if (-not $asset) {
    throw "Asset '$assetName' not found in release $tag."
}

$tempDir = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "kanata-$tag"
$zipPath = Join-Path -Path $tempDir -ChildPath $assetName

if (-not (Test-Path -LiteralPath $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
}

Write-Host "Downloading $assetName ..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath

Write-Host 'Extracting ...' -ForegroundColor Cyan
Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force

$sourceName = "kanata_windows_gui_winIOv2_$arch.exe"
$sourcePath = Join-Path -Path $tempDir -ChildPath $sourceName

if (-not (Test-Path -LiteralPath $sourcePath)) {
    throw "Expected binary '$sourceName' not found in archive."
}

if (-not (Test-Path -LiteralPath $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

Copy-Item -LiteralPath $sourcePath -Destination $destPath -Force
Write-Host "Installed kanata $tag to $destPath" -ForegroundColor Green

Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
