[CmdletBinding()]
param(
    [Parameter()]
    [switch]$SkipPackages,

    [Parameter()]
    [switch]$SkipDotter,

    [Parameter()]
    [switch]$SkipKanata,

    [Parameter()]
    [switch]$ForceKanata
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Test-IsAdministrator {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [System.Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Resolve-RepoRoot {
    return (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..\..')).Path
}

function Resolve-CommandPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter()]
        [string[]]$FallbackPaths = @()
    )

    $command = Get-Command -Name $Name -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    foreach ($path in $FallbackPaths) {
        $expandedPath = [Environment]::ExpandEnvironmentVariables($path)
        if (Test-Path -LiteralPath $expandedPath) {
            return $expandedPath
        }
    }

    throw "Command not found: $Name"
}

if (-not (Test-IsAdministrator)) {
    throw 'Windows setup must be run from an elevated PowerShell session.'
}

$repoRoot = Resolve-RepoRoot
$windowsDir = $PSScriptRoot

if (-not $SkipPackages) {
    & (Join-Path -Path $windowsDir -ChildPath 'packages\Install.ps1')
}

if (-not $SkipKanata) {
    $kanataArgs = @{}
    if ($ForceKanata) {
        $kanataArgs.Force = $true
    }

    & (Join-Path -Path $windowsDir -ChildPath 'kanata\Install.ps1') @kanataArgs
}

if (-not $SkipDotter) {
    $dotterPath = Resolve-CommandPath `
        -Name 'dotter' `
        -FallbackPaths @('%LOCALAPPDATA%\Microsoft\WinGet\Links\dotter.exe')

    Push-Location -LiteralPath $repoRoot
    try {
        & $dotterPath deploy
    }
    finally {
        Pop-Location
    }
}

if (-not $SkipKanata) {
    & (Join-Path -Path $windowsDir -ChildPath 'kanata\RegisterScheduledTask.ps1')
}
