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
    Write-Host 'No packages to install. Update the package list and rerun.' -ForegroundColor Yellow
    return
}

foreach ($packageId in $packages) {
    Write-Host "Installing $packageId" -ForegroundColor Cyan

    $listArgs = @('list', '--id', $packageId, '--exact')
    $listOutput = winget @listArgs 2>&1 | Out-String
    if ($LASTEXITCODE -eq 0 -and $listOutput -match [Regex]::Escape($packageId)) {
        Write-Host "  $packageId already installed, skipping." -ForegroundColor Yellow
        continue
    }

    $installArgs = @(
        'install',
        '--id', $packageId,
        '--exact',
        '--silent',
        '--accept-package-agreements',
        '--accept-source-agreements',
        '--disable-interactivity'
    )

    winget @installArgs
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 0) {
        Write-Host "  Installed $packageId" -ForegroundColor Green
    }
    elseif ($exitCode -eq 0x8A15000F -or $exitCode -eq 0x8A15003B) {
        Write-Host "  $packageId already installed (winget exit code $exitCode), skipping." -ForegroundColor Yellow
    }
    else {
        Write-Warning "  winget install failed for $packageId (exit code $exitCode)"
    }
}
