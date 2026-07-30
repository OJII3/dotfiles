# PowerShell Module Installation Design

## Goal

Ensure the Windows setup installs every PowerShell module required by the
managed PowerShell profile before the profile attempts to import it.

## Scope

The setup will manage these modules:

- `Microsoft.WinGet.CommandNotFound`
- `Abbr`
- `PSFzf`
- `posh-git`

The profile will continue to import modules and configure their features. It
will not install modules during shell startup.

## Design

Add a PowerShell-module manifest alongside the existing winget package
manifest. Add a dedicated installer script that reads the manifest, ignores
blank lines and comments, checks each module with `Get-Module -ListAvailable`,
and installs only missing modules for the current user.

`modules/windows/Setup.ps1` will run the PowerShell-module installer in the
existing package phase. Passing `-SkipPackages` will skip both winget packages
and PowerShell modules.

Keeping the module installer separate from the winget installer avoids mixing
two package managers and gives each script one responsibility.

## Error Handling

Failure to install one PowerShell module will produce a warning and will not
prevent attempts to install the remaining modules. The setup will finish the
module phase with a non-success result if any requested module could not be
installed, so a partially configured environment is visible to the caller.

An absent manifest is a setup error. An empty manifest is valid and results in
no installation work.

## Testing

Pester tests will cover:

- installed modules are skipped;
- missing modules are installed for `CurrentUser`;
- comments and blank lines in the manifest are ignored;
- one failed installation does not prevent later modules from being attempted;
- the installer reports failure after any module installation fails;
- the setup integration remains inside the existing `-SkipPackages` guard.

Tests will use temporary manifests and replace package-manager commands at the
PowerShell command boundary, without accessing the network or changing the
user's installed modules. The one-line setup integration is verified through
PowerShell parsing and diff review rather than a source-text assertion.

## Success Criteria

After running the normal Windows setup successfully, all four modules are
discoverable through `PSModulePath`, and a new PowerShell session starts without
the current missing-module warnings.
