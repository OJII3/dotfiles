function Initialize-StarshipCached {
    $starshipExe = 'C:\Program Files\starship\bin\starship.exe'
    if (-not (Test-Path $starshipExe)) {
        return
    }

    $cacheDir = Join-Path $env:LOCALAPPDATA 'starship'
    $cacheFile = Join-Path $cacheDir 'init-powershell.ps1'

    $cacheMissing = -not (Test-Path $cacheFile)
    $cacheStale = $false
    if (-not $cacheMissing) {
        $cacheStale = (Get-Item $cacheFile).LastWriteTimeUtc -lt (Get-Item $starshipExe).LastWriteTimeUtc
    }

    try {
        if ($cacheMissing -or $cacheStale) {
            if (-not (Test-Path $cacheDir)) {
                New-Item -Path $cacheDir -ItemType Directory -ErrorAction Stop | Out-Null
            }

            & $starshipExe init powershell --print-full-init | Set-Content -Path $cacheFile -Encoding UTF8 -ErrorAction Stop
        }

        . $cacheFile
    }
    catch {
        # Cache write can fail in restricted environments; fall back to direct init.
        Invoke-Expression (& $starshipExe init powershell --print-full-init | Out-String)
    }
}

function Add-ToPathIfMissing {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PathToAdd
    )

    $pathEntries = $env:PATH -split ';'
    if ($pathEntries -notcontains $PathToAdd) {
        $env:PATH = "$PathToAdd;$env:PATH"
    }
}

Add-ToPathIfMissing -PathToAdd 'C:\Users\ojii3\.local\bin'

Initialize-StarshipCached
Set-PSReadLineOption -BellStyle None -EditMode Emacs

function ghqfzf {
    $repo = $(ghq list | fzf)
    Set-Location ( Join-Path $(ghq root) $repo)
}

Set-PSReadLineKeyHandler -Chord Ctrl+] -ScriptBlock {
    ghqfzf
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

function Import-OptionalModule {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [switch]$ForceImport
    )

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
Import-OptionalModule -Name 'Microsoft.WinGet.CommandNotFound' -ForceImport > $null
#f45873b3-b655-43a6-b217-97c00aa0db58

# Abbr
$abbrModuleLoaded = Import-OptionalModule -Name 'Abbr' -ForceImport
if ($abbrModuleLoaded) {
    ealias g 'git'
    ealias gb 'git branch'
    ealias gcmt 'git commit -m'
    ealias gf 'git fetch'
    ealias gfp 'git fetch --prune'
    ealias glg 'git log --oneline --graph --decorate'
    ealias gph 'git push'
    ealias gpl 'git pull'
    ealias gw 'git switch'
    ealias gwc 'git switch -c'

    ealias t 'tig status'
    ealias ghpc 'gh pr create'
    ealias ghpm 'gh pr merge'
    ealias ghpv 'gh pr view'
}

# PSFzf
$psFzfModuleLoaded = Import-OptionalModule -Name 'PSFzf' -ForceImport
if ($psFzfModuleLoaded) {
    Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
}

Import-OptionalModule -Name 'posh-git' -ForceImport > $null

(&mise activate pwsh) | Out-String | Invoke-Expression