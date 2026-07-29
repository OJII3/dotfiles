$installerPath = Join-Path $PSScriptRoot '..\Install-PowerShellModules.ps1'
Import-Module PowerShellGet

Describe 'Install-PowerShellModules' {
    BeforeEach {
        $moduleListPath = Join-Path $TestDrive 'powershell.txt'
        $moduleRoot = Join-Path $TestDrive 'Modules'
        New-Item -Path $moduleRoot -ItemType Directory -Force | Out-Null
        $originalPSModulePath = $env:PSModulePath
        $env:PSModulePath = $moduleRoot
    }

    AfterEach {
        $env:PSModulePath = $originalPSModulePath
    }

    It 'ignores comments and blank lines and skips installed modules' {
        @(
            '# comment'
            ''
            'Abbr'
            '  '
        ) | Set-Content -LiteralPath $moduleListPath

        $abbrPath = Join-Path $moduleRoot 'Abbr\1.0.0\Abbr.psd1'
        New-Item -Path (Split-Path $abbrPath) -ItemType Directory | Out-Null
        New-ModuleManifest -Path $abbrPath -RootModule '' -ModuleVersion '1.0.0'
        Mock Install-Module {}

        & $installerPath -ModuleListPath $moduleListPath

        Assert-MockCalled Install-Module -Times 0 -Exactly
    }

    It 'accepts an empty manifest without installing anything' {
        Set-Content -LiteralPath $moduleListPath -Value @('# comment', '')
        Mock Install-Module {}

        & $installerPath -ModuleListPath $moduleListPath

        Assert-MockCalled Install-Module -Times 0 -Exactly
    }

    It 'installs a missing module for the current user' {
        Set-Content -LiteralPath $moduleListPath -Value 'PSFzf'
        Mock Install-Module {}

        & $installerPath -ModuleListPath $moduleListPath

        Assert-MockCalled Install-Module -Times 1 -Exactly -ParameterFilter {
            $Name -eq 'PSFzf' -and
            $Repository -eq 'PSGallery' -and
            $Scope -eq 'CurrentUser' -and
            $Force
        }
    }

    It 'attempts remaining modules and throws after an installation failure' {
        Set-Content -LiteralPath $moduleListPath -Value @('BrokenModule', 'posh-git')
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
}
