Invoke-Expression (& 'C:\Program Files\starship\bin\starship.exe' init powershell --print-full-init | Out-String)
Set-PSReadLineOption -BellStyle None -EditMode Emacs

function ghqfzf {
    $repo = $(ghq list | fzf)
    Set-Location ( Join-Path $(ghq root) $repo)
}

Set-PSReadLineKeyHandler -Chord Ctrl+] -ScriptBlock {
    ghqfzf
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

function Request-Module {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [string]$Repository = 'PSGallery',
        [switch]$ForceImport
    )

    if (-not (Get-Module -ListAvailable -Name $Name)) {
        try {
            Write-Host "Installing PowerShell module '$Name' from $Repository..." -ForegroundColor Yellow
            Install-Module -Name $Name -Repository $Repository -Scope CurrentUser -Force -Confirm:$false -ErrorAction Stop
        }
        catch {
            Write-Warning "Failed to install module '$Name': $_"
            return $false
        }
    }

    try {
        if ($ForceImport) {
            Import-Module -Name $Name -Force -ErrorAction Stop
        }
        else {
            Import-Module -Name $Name -ErrorAction Stop
        }
        return $true
    }
    catch {
        Write-Warning "Failed to import module '$Name': $_"
        return $false
    }
}

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module
Request-Module -Name 'Microsoft.WinGet.CommandNotFound' -ForceImport > $null
#f45873b3-b655-43a6-b217-97c00aa0db58

$abbrModuleLoaded = Request-Module -Name 'Abbr' -ForceImport
if ($abbrModuleLoaded) {
    ealias g 'git'
}

# Install-Module -Name PSFzf
$psFzfModuleLoaded = Request-Module -Name 'PSFzf' -ForceImport
if ($psFzfModuleLoaded) {
    Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
}
