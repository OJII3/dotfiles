[CmdletBinding()]
param(
    [Parameter()]
    [string]$ModuleListPath
)

$ErrorActionPreference = 'Stop'

if (-not $PSBoundParameters.ContainsKey('ModuleListPath') -or [string]::IsNullOrWhiteSpace($ModuleListPath)) {
    $ModuleListPath = Join-Path -Path $PSScriptRoot -ChildPath 'powershell.txt'
}

if (-not (Test-Path -LiteralPath $ModuleListPath)) {
    throw "PowerShell module list not found: $ModuleListPath"
}

$moduleNames = Get-Content -LiteralPath $ModuleListPath |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and -not $_.StartsWith('#') }

$failedModules = @()

foreach ($moduleName in $moduleNames) {
    if (Get-Module -ListAvailable -Name $moduleName) {
        Write-Host "  $moduleName already installed, skipping." -ForegroundColor Yellow
        continue
    }

    Write-Host "Installing PowerShell module $moduleName" -ForegroundColor Cyan

    try {
        Install-Module `
            -Name $moduleName `
            -Repository PSGallery `
            -Scope CurrentUser `
            -Force `
            -Confirm:$false `
            -ErrorAction Stop
        Write-Host "  Installed $moduleName" -ForegroundColor Green
    }
    catch {
        $failedModules += $moduleName
        Write-Warning "  Failed to install $moduleName`: $_"
    }
}

if ($failedModules.Count -gt 0) {
    throw "Failed to install PowerShell modules: $($failedModules -join ', ')"
}
