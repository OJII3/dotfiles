Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Resolve-StartupCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Command,

        [Parameter(Mandatory = $true)]
        [string]
        $HomeDirectory
    )

    $expandedTilde = [regex]::Replace(
        $Command,
        '(?<=^|\s)~(?=[\\/]|$)',
        { param($match) $HomeDirectory }
    )

    return [Environment]::ExpandEnvironmentVariables($expandedTilde)
}

$startupRegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'

$startupCommands = @(
    [pscustomobject]@{
        Name    = 'AutoHotkeyDefault'
        Command = 'ahk ~/.config/autohotokey/default.ahk'
        Comment = 'Launch the primary AutoHotkey script.'
    }
)

if (-not (Test-Path -Path $startupRegistryPath)) {
    New-Item -Path $startupRegistryPath -Force | Out-Null
}

foreach ($entry in $startupCommands) {
    if ([string]::IsNullOrWhiteSpace($entry.Name)) {
        throw "Startup command entry is missing a 'Name'."
    }

    if ([string]::IsNullOrWhiteSpace($entry.Command)) {
        throw "Startup command entry '$($entry.Name)' is missing a 'Command'."
    }

    $resolvedCommand = Resolve-StartupCommand -Command $entry.Command -HomeDirectory $HOME

    $registryItem = Get-ItemProperty -Path $startupRegistryPath -ErrorAction SilentlyContinue
    $currentValue = $null
    if ($registryItem -and $registryItem.PSObject.Properties.Match($entry.Name).Count -gt 0) {
        $currentValue = $registryItem.PSObject.Properties[$entry.Name].Value
    }

    if ($currentValue -ne $resolvedCommand) {
        Set-ItemProperty -Path $startupRegistryPath -Name $entry.Name -Value $resolvedCommand
        Write-Host "Registered startup command '$($entry.Name)' as: $resolvedCommand"
    }
    else {
        Write-Host "Startup command '$($entry.Name)' is already up to date."
    }
}

Write-Host "Processed $($startupCommands.Count) startup command(s)."
