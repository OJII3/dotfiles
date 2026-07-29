# PowerShell Module Installation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Install the PowerShell modules required by the managed Windows profile during Windows setup.

**Architecture:** Keep PowerShell startup free of installation side effects. A dedicated installer reads a manifest, skips discoverable modules, installs missing modules for the current user, continues after individual failures, and reports aggregate failure; the existing setup package phase invokes it next to the winget installer.

**Tech Stack:** PowerShell 7, PowerShellGet `Install-Module`, Pester 3.4

## Global Constraints

- Manage `Microsoft.WinGet.CommandNotFound`, `Abbr`, `PSFzf`, and `posh-git`.
- Do not install modules while loading the PowerShell profile.
- Install only modules missing from `Get-Module -ListAvailable`.
- Install modules with `-Scope CurrentUser`.
- Continue attempting later modules after an individual installation failure.
- Fail the module phase after all attempts if any installation failed.
- `Setup.ps1 -SkipPackages` skips both winget and PowerShell-module installation.

---

## File Map

- Create: `modules/windows/packages/powershell.txt` — declarative PowerShell-module manifest.
- Create: `modules/windows/packages/Install-PowerShellModules.ps1` — manifest reader and module installer.
- Create: `modules/windows/packages/tests/Install-PowerShellModules.Tests.ps1` — installer behavior tests.
- Modify: `modules/windows/Setup.ps1` — invoke the module installer in the package phase.

### Task 1: PowerShell Module Installer

**Files:**

- Create: `modules/windows/packages/powershell.txt`
- Create: `modules/windows/packages/Install-PowerShellModules.ps1`
- Test: `modules/windows/packages/tests/Install-PowerShellModules.Tests.ps1`

**Interfaces:**

- Consumes: optional `-ModuleListPath <string>`; defaults to `powershell.txt` beside the script.
- Produces: installs missing manifest entries through `Install-Module`; returns normally on complete success; throws one aggregate error after attempting all entries when any installation fails.

- [ ] **Step 1: Write tests for manifest parsing and installed-module skipping**

Create `modules/windows/packages/tests/Install-PowerShellModules.Tests.ps1`:

```powershell
$installerPath = Join-Path $PSScriptRoot '..\Install-PowerShellModules.ps1'

Describe 'Install-PowerShellModules' {
    BeforeEach {
        $moduleListPath = Join-Path $TestDrive 'powershell.txt'
    }

    It 'ignores comments and blank lines and skips installed modules' {
        @(
            '# comment'
            ''
            'Abbr'
            '  '
        ) | Set-Content -LiteralPath $moduleListPath

        Mock Get-Module {
            [pscustomobject]@{ Name = 'Abbr' }
        } -ParameterFilter { $ListAvailable -and $Name -eq 'Abbr' }
        Mock Install-Module {}

        & $installerPath -ModuleListPath $moduleListPath

        Assert-MockCalled Get-Module -Times 1 -Exactly -ParameterFilter {
            $ListAvailable -and $Name -eq 'Abbr'
        }
        Assert-MockCalled Install-Module -Times 0 -Exactly
    }

    It 'accepts an empty manifest without installing anything' {
        Set-Content -LiteralPath $moduleListPath -Value @('# comment', '')
        Mock Get-Module {}
        Mock Install-Module {}

        & $installerPath -ModuleListPath $moduleListPath

        Assert-MockCalled Get-Module -Times 0 -Exactly
        Assert-MockCalled Install-Module -Times 0 -Exactly
    }
}
```

- [ ] **Step 2: Run the tests and verify RED**

Run:

```powershell
Invoke-Pester .\modules\windows\packages\tests\Install-PowerShellModules.Tests.ps1
```

Expected: FAIL because `Install-PowerShellModules.ps1` does not exist.

- [ ] **Step 3: Add the minimal manifest reader and installed-module skip**

Create `modules/windows/packages/Install-PowerShellModules.ps1`:

```powershell
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

foreach ($moduleName in $moduleNames) {
    if (Get-Module -ListAvailable -Name $moduleName) {
        Write-Host "  $moduleName already installed, skipping." -ForegroundColor Yellow
        continue
    }
}
```

- [ ] **Step 4: Run the tests and verify GREEN**

Run:

```powershell
Invoke-Pester .\modules\windows\packages\tests\Install-PowerShellModules.Tests.ps1
```

Expected: 2 tests PASS.

- [ ] **Step 5: Add failing tests for installation and aggregate failure**

Append inside the existing `Describe` block:

```powershell
    It 'installs a missing module for the current user' {
        Set-Content -LiteralPath $moduleListPath -Value 'PSFzf'
        Mock Get-Module {}
        Mock Install-Module {}

        & $installerPath -ModuleListPath $moduleListPath

        Assert-MockCalled Install-Module -Times 1 -Exactly -ParameterFilter {
            $Name -eq 'PSFzf' -and
            $Repository -eq 'PSGallery' -and
            $Scope -eq 'CurrentUser' -and
            $Force -and
            $Confirm -eq $false
        }
    }

    It 'attempts remaining modules and throws after an installation failure' {
        Set-Content -LiteralPath $moduleListPath -Value @('BrokenModule', 'posh-git')
        Mock Get-Module {}
        Mock Install-Module {
            if ($Name -eq 'BrokenModule') {
                throw 'installation failed'
            }
        }

        { & $installerPath -ModuleListPath $moduleListPath } |
            Should Throw 'Failed to install PowerShell modules: BrokenModule'

        Assert-MockCalled Install-Module -Times 1 -Exactly -ParameterFilter {
            $Name -eq 'BrokenModule'
        }
        Assert-MockCalled Install-Module -Times 1 -Exactly -ParameterFilter {
            $Name -eq 'posh-git'
        }
    }

    It 'throws when the manifest does not exist' {
        $missingPath = Join-Path $TestDrive 'missing.txt'

        { & $installerPath -ModuleListPath $missingPath } |
            Should Throw "PowerShell module list not found: $missingPath"
    }
```

- [ ] **Step 6: Run the tests and verify RED**

Run:

```powershell
Invoke-Pester .\modules\windows\packages\tests\Install-PowerShellModules.Tests.ps1
```

Expected: installed-module and empty-manifest tests PASS; missing-module installation and aggregate-failure tests FAIL because installation is not implemented.

- [ ] **Step 7: Implement installation and aggregate failure**

Replace the installer loop with:

```powershell
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
```

Create `modules/windows/packages/powershell.txt`:

```text
# PowerShell Gallery modules required by the Windows PowerShell profile.
# One module name per line.

Microsoft.WinGet.CommandNotFound
Abbr
PSFzf
posh-git
```

- [ ] **Step 8: Run installer tests and verify GREEN**

Run:

```powershell
Invoke-Pester .\modules\windows\packages\tests\Install-PowerShellModules.Tests.ps1
```

Expected: 5 tests PASS.

- [ ] **Step 9: Commit the installer**

```powershell
git add modules/windows/packages/powershell.txt modules/windows/packages/Install-PowerShellModules.ps1 modules/windows/packages/tests/Install-PowerShellModules.Tests.ps1
git commit -m "feat: install required PowerShell modules"
```

### Task 2: Windows Setup Integration

**Files:**

- Modify: `modules/windows/Setup.ps1:52-54`

**Interfaces:**

- Consumes: the existing `Setup.ps1 -SkipPackages` switch and `packages\Install-PowerShellModules.ps1`.
- Produces: normal setup invokes winget installation followed by PowerShell-module installation; `-SkipPackages` bypasses both calls.

- [ ] **Step 1: Wire the module installer into the existing package phase**

Change the package phase in `modules/windows/Setup.ps1` to:

```powershell
if (-not $SkipPackages) {
    & (Join-Path -Path $windowsDir -ChildPath 'packages\Install.ps1')
    & (Join-Path -Path $windowsDir -ChildPath 'packages\Install-PowerShellModules.ps1')
}
```

- [ ] **Step 2: Run all Windows package tests and verify GREEN**

Run:

```powershell
Invoke-Pester .\modules\windows\packages\tests
```

Expected: 5 tests PASS with no failed tests.

- [ ] **Step 3: Run static validation**

Run:

```powershell
$files = @(
    '.\modules\windows\Setup.ps1'
    '.\modules\windows\packages\Install-PowerShellModules.ps1'
    '.\modules\windows\packages\tests\Install-PowerShellModules.Tests.ps1'
)

foreach ($file in $files) {
    $tokens = $null
    $errors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile(
        (Resolve-Path $file),
        [ref]$tokens,
        [ref]$errors
    )
    if ($errors.Count -gt 0) {
        throw "PowerShell parse errors in $file`: $($errors.Message -join '; ')"
    }
}
```

Expected: command completes without errors.

- [ ] **Step 4: Review the setup diff**

Run:

```powershell
git diff -- modules/windows/Setup.ps1
```

Expected: the only setup change is the module installer invocation directly
after the winget installer and inside the existing `if (-not $SkipPackages)`
block.

- [ ] **Step 5: Commit setup integration**

```powershell
git add modules/windows/Setup.ps1
git commit -m "feat: integrate PowerShell modules into Windows setup"
```

### Task 3: Final Verification

**Files:**

- Verify only: all files from Tasks 1 and 2.

**Interfaces:**

- Consumes: completed installer and setup integration.
- Produces: evidence that tests pass and the manifest contains every profile dependency.

- [ ] **Step 1: Run the complete test suite**

```powershell
Invoke-Pester .\modules\windows\packages\tests
```

Expected: 5 tests PASS and 0 tests FAIL.

- [ ] **Step 2: Verify manifest/profile consistency**

```powershell
$manifest = Get-Content .\modules\windows\packages\powershell.txt |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and -not $_.StartsWith('#') }
$profile = Get-Content .\modules\windows\powershell\profile.ps1 -Raw

@('Microsoft.WinGet.CommandNotFound', 'Abbr', 'PSFzf', 'posh-git') |
    ForEach-Object {
        if ($_ -notin $manifest -or $profile -notmatch [regex]::Escape($_)) {
            throw "Missing module mapping: $_"
        }
    }
```

Expected: command completes without errors.

- [ ] **Step 3: Check the final diff**

```powershell
git diff --check HEAD~2
git status --short
```

Expected: no whitespace errors; only intended files are changed.
