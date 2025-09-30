[CmdletBinding()]
param(
    [Parameter()]
    [string]$PackageListPath
)

$ErrorActionPreference = 'Stop'

if (-not $PSBoundParameters.ContainsKey('PackageListPath') -or [string]::IsNullOrWhiteSpace($PackageListPath)) {
    $PackageListPath = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'winget-packages.txt'
}

if (-not (Get-Command -Name 'winget' -ErrorAction SilentlyContinue)) {
    throw 'winget is not available. Install winget or run this script on Windows 10/11 with winget support.'
}

if (-not (Test-Path -LiteralPath $PackageListPath)) {
    throw "Package list not found: $PackageListPath"
}

$packages = Get-Content -LiteralPath $PackageListPath |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and -not $_.StartsWith('#') }

if (-not $packages) {
    Write-Host 'No packages to upgrade. Update the package list and rerun.' -ForegroundColor Yellow
    return
}

foreach ($packageId in $packages) {
    Write-Host "Checking $packageId" -ForegroundColor Cyan

    $listArgs = @('list', '--id', $packageId, '--exact')
    $listOutput = winget @listArgs 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0 -or -not ($listOutput -match [Regex]::Escape($packageId))) {
        Write-Host "  $packageId is not installed via winget, skipping." -ForegroundColor Yellow
        continue
    }

    $upgradeArgs = @(
        'upgrade',
        '--id', $packageId,
        '--exact',
        '--silent',
        '--accept-package-agreements',
        '--accept-source-agreements',
        '--disable-interactivity'
    )

    winget @upgradeArgs
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 0) {
        Write-Host "  Upgraded $packageId" -ForegroundColor Green
    }
    elseif ($exitCode -eq 0x8A150010) {
        Write-Host "  No updates available for $packageId" -ForegroundColor DarkGray
    }
    else {
        Write-Warning "  winget upgrade failed for $packageId (exit code $exitCode)"
    }
}
