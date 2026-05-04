[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter()]
    [string]$TaskName = 'Kanata',

    [Parameter()]
    [string]$KanataPath = (Join-Path -Path $HOME -ChildPath '.local\bin\kanata.exe'),

    [Parameter()]
    [string]$ConfigPath = (Join-Path -Path $HOME -ChildPath '.config\kanata\default.kbd'),

    [Parameter()]
    [ValidateSet('Highest', 'Limited')]
    [string]$RunLevel = 'Highest',

    [Parameter()]
    [switch]$KeepLegacyRunEntry
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Test-IsAdministrator {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [System.Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Path -LiteralPath $KanataPath)) {
    throw "kanata executable not found: $KanataPath"
}

if (-not (Test-Path -LiteralPath $ConfigPath)) {
    throw "kanata config not found: $ConfigPath"
}

if ($RunLevel -eq 'Highest' -and -not (Test-IsAdministrator)) {
    throw 'Registering a highest-privilege scheduled task requires an elevated PowerShell session. Re-run this script as administrator.'
}

$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$legacyRunPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
$workingDirectory = Split-Path -Path $ConfigPath -Parent

$action = New-ScheduledTaskAction `
    -Execute $KanataPath `
    -Argument "--cfg `"$ConfigPath`" --no-wait" `
    -WorkingDirectory $workingDirectory

$trigger = New-ScheduledTaskTrigger -AtLogOn -User $currentUser

$principal = New-ScheduledTaskPrincipal `
    -UserId $currentUser `
    -LogonType Interactive `
    -RunLevel $RunLevel

$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -ExecutionTimeLimit (New-TimeSpan -Seconds 0) `
    -MultipleInstances IgnoreNew `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 1)

$task = New-ScheduledTask `
    -Action $action `
    -Trigger $trigger `
    -Principal $principal `
    -Settings $settings `
    -Description 'Launch kanata keyboard remapper at user logon.'

if ($PSCmdlet.ShouldProcess($TaskName, 'Register scheduled task')) {
    Register-ScheduledTask -TaskName $TaskName -InputObject $task -Force | Out-Null
    Write-Host "Registered scheduled task '$TaskName' for $currentUser."
    Write-Host "Action: $KanataPath --cfg `"$ConfigPath`" --no-wait"

    if (-not $KeepLegacyRunEntry -and (Test-Path -Path $legacyRunPath)) {
        $legacyRunItem = Get-ItemProperty -Path $legacyRunPath -ErrorAction SilentlyContinue
        if ($legacyRunItem -and $legacyRunItem.PSObject.Properties.Match($TaskName).Count -gt 0) {
            Remove-ItemProperty -Path $legacyRunPath -Name $TaskName
            Write-Host "Removed legacy startup command '$TaskName' from HKCU Run."
        }
    }
}
