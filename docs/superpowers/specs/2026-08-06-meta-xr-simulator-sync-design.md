# Meta XR Simulator User Runtime Synchronization Design

## Goal

Make the Darwin VR module copy the Homebrew-installed Meta XR Simulator into
the user library directory expected by the existing `XR_RUNTIME_JSON`
configuration. The synchronized copy must follow the currently installed
Homebrew version and must not leave obsolete versions behind.

## Scope

The implementation will modify only `modules/darwin/desktop/vr.nix`.

It will:

- keep `meta-xr-simulator` managed by the existing Homebrew configuration;
- copy the already expanded Homebrew package into the user's
  `~/Library/MetaXR/MetaXRSimulator/<version>` directory;
- maintain a `current` symlink to the active version;
- point `XR_RUNTIME_JSON` at the stable `current` path;
- remove old synchronized versions after a successful update.

It will not change the Homebrew tap or formula, download the archive a second
time, or run Meta's global `/usr/local/share/openxr` setup script.

## Current Context

The Homebrew formula installs the archive contents into its Cellar directory
and exposes the active version through:

```text
<homebrew-prefix>/opt/meta-xr-simulator
```

The current module instead points `XR_RUNTIME_JSON` at a hard-coded
`71.0.0` path and contains an empty custom activation-script attribute. The
nix-darwin activation script runs its built-in `homebrew` fragment followed by
`postActivation`; arbitrary attributes under `system.activationScripts` are not
automatically executed by that activation entry point.

## Design

### Source and Destination

The activation script will use the `homebrew.prefix` module option rather than
hard-coding `/opt/homebrew` or `/usr/local`:

```text
source link: <homebrew-prefix>/opt/meta-xr-simulator
source real path: readlink -f(source link)
version: basename(source real path)
destination: /Users/<username>/Library/MetaXR/MetaXRSimulator/<version>
stable link: /Users/<username>/Library/MetaXR/MetaXRSimulator/current
runtime: /Users/<username>/Library/MetaXR/MetaXRSimulator/current/meta_openxr_simulator.json
```

The source is already expanded by Homebrew, so `/usr/bin/ditto` will copy the
directory as a unit. This preserves the relative `SIMULATOR.so` reference in
`meta_openxr_simulator.json`.

### Activation Ordering

The synchronization logic will be assigned to
`system.activationScripts.postActivation.text`. nix-darwin emits the built-in
Homebrew activation before this hook, so the formula is installed or upgraded
before the source path is inspected.

The script will verify that the resolved source directory and
`meta_openxr_simulator.json` exist. It will derive the version from the
resolved Cellar directory rather than from a Nix evaluation-time constant.

### Update Algorithm

1. Resolve and validate the current Homebrew package.
2. Create a temporary sibling directory under `~/Library/MetaXR`.
3. Copy the package into the temporary directory with `ditto`.
4. Create the `current` symlink in the temporary directory.
5. Assign the copied tree to the configured user and primary group.
6. Replace the managed `MetaXRSimulator` directory with the prepared tree.

The copy is prepared before the existing destination is removed. This keeps a
previously working installation available if source validation or copying
fails. Once replacement succeeds, only the current version and its `current`
symlink remain.

If the destination already contains the current version, its runtime manifest
is valid, and `current` points to that version, the expensive copy is skipped;
cleanup still removes obsolete version directories.

## Error Handling

Activation runs with `set -e`. Missing Homebrew source files, an invalid source
path, failed copying, failed ownership changes, or failed replacement abort the
activation with a non-zero status. A temporary directory is removed on exit.

The script runs as root as required by nix-darwin activation, then explicitly
sets ownership of the synchronized tree to the configured user and that user's
primary group so normal development tools can read and update it.

## Testing

Verification will include:

- formatting the changed Nix file with the repository formatter;
- `nix flake check --no-build`;
- checking the generated Darwin activation script to confirm the synchronization
  code is in `postActivation` after Homebrew;
- checking the generated shell fragment with `bash -n`;
- running the copy logic against a temporary source and destination to verify
  version detection, `ditto` layout, `current` resolution, old-version cleanup,
  and idempotent re-execution.

## Alternatives Considered

### Re-download and Extract the Archive

This duplicates Homebrew's installation work and requires independently
tracking the download URL and checksum. It is more fragile on Homebrew updates
and is not needed because the formula already expands the archive.

### Run `post_installation_macos.sh` Only

This leaves the runtime in the Cellar and modifies the global OpenXR runtime
link. It does not provide the requested user-library copy and introduces a
global side effect outside this module's existing environment-variable setup.
