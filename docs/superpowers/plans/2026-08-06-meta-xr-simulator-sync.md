# Meta XR Simulator User Runtime Synchronization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Synchronize the currently installed Homebrew Meta XR Simulator into the user's versioned library directory and expose it through a stable `current` runtime path.

**Architecture:** Keep Homebrew responsible for installing and expanding the simulator. A nix-darwin `postActivation` shell fragment will resolve the Homebrew `opt` symlink, stage a copy with `ditto`, replace the managed user-library tree only after the copy succeeds, remove obsolete versions, and maintain a `current` symlink. `XR_RUNTIME_JSON` will point at that stable symlink instead of a hard-coded version.

**Tech Stack:** Nix, nix-darwin activation scripts, macOS `ditto`, Homebrew Cellar/`opt` symlinks, Bash-compatible shell commands.

---

## File Map

- Modify `modules/darwin/desktop/vr.nix`: define the source and destination paths, update `XR_RUNTIME_JSON`, and replace the unused custom activation attribute with a Homebrew-ordered `postActivation` hook.
- Do not modify the Homebrew tap, formula, `modules/home/vr.nix`, or any unrelated uncommitted files.
- No committed test file is needed because the behavior is an inline activation fragment; verification will extract the generated fragment and run it against a disposable temporary fixture.

### Task 1: Make the Runtime Path Version-Independent

**Files:**
- Modify: `modules/darwin/desktop/vr.nix:10-30`

- [ ] **Step 1: Capture the baseline evaluation**

Run:

```bash
nix eval --raw '.#darwinConfigurations.Himeko.config.environment.variables.XR_RUNTIME_JSON'
```

Expected before the change:

```text
/Users/ojii3/Library/MetaXR/MetaXRSimulator/71.0.0/meta_xr_simulator.json
```

This confirms the baseline is the hard-coded version that the implementation must remove.

- [ ] **Step 2: Add Nix-side path values**

Extend the existing `let` block in `modules/darwin/desktop/vr.nix` with these values:

```nix
  simulatorRoot = "/Users/${username}/Library/MetaXR/MetaXRSimulator";
  simulatorRuntime = "${simulatorRoot}/current/meta_openxr_simulator.json";
  simulatorSource = "${config.homebrew.prefix}/opt/meta-xr-simulator";
```

Keep `cfg = config.dot.darwin.desktop;` unchanged. `config.homebrew.prefix` must be used instead of hard-coding `/opt/homebrew`, because nix-darwin selects `/opt/homebrew` for Apple Silicon and `/usr/local` for Intel or custom configurations.

- [ ] **Step 3: Point the environment variable at `current`**

Replace the current environment block with:

```nix
    environment.variables = {
      XR_RUNTIME_JSON = simulatorRuntime;
    };
```

Do not keep `71.0.0` in the module. The activation fragment will create the `current` symlink before the configured runtime is used.

- [ ] **Step 4: Evaluate the new environment value**

Run:

```bash
nix eval --raw '.#darwinConfigurations.Himeko.config.environment.variables.XR_RUNTIME_JSON'
```

Expected:

```text
/Users/ojii3/Library/MetaXR/MetaXRSimulator/current/meta_openxr_simulator.json
```

- [ ] **Step 5: Commit the path change**

Run:

```bash
git add -- modules/darwin/desktop/vr.nix
git commit -m "feat: use stable Meta XR Simulator runtime path"
```

The commit must not stage `modules/home/vr.nix` or `modules/darwin/vr/`.

### Task 2: Implement the Homebrew-Ordered Synchronization Script

**Files:**
- Modify: `modules/darwin/desktop/vr.nix:32-39`

- [ ] **Step 1: Replace the unused activation attribute**

Replace the current empty `system.activationScripts.install-meta-xr-simulator` block with the following `postActivation` fragment:

```nix
    system.activationScripts.postActivation.text = lib.mkAfter ''
      simulator_source=${lib.escapeShellArg simulatorSource}
      simulator_root=${lib.escapeShellArg simulatorRoot}
      simulator_user=${lib.escapeShellArg username}

      if [ ! -d "$simulator_source" ]; then
        printf '%s\n' "Meta XR Simulator is not installed: $simulator_source" >&2
        exit 1
      fi

      if ! simulator_real_path="$(readlink -f -- "$simulator_source")"; then
        printf '%s\n' "Unable to resolve Meta XR Simulator: $simulator_source" >&2
        exit 1
      fi

      if [ ! -d "$simulator_real_path" ] || [ ! -f "$simulator_real_path/meta_openxr_simulator.json" ]; then
        printf '%s\n' "Meta XR Simulator runtime manifest is missing: $simulator_real_path" >&2
        exit 1
      fi

      simulator_version="$(basename -- "$simulator_real_path")"
      case "$simulator_version" in
        ""|"."|"/")
          printf '%s\n' "Unable to determine Meta XR Simulator version" >&2
          exit 1
          ;;
      esac

      simulator_parent="$(dirname -- "$simulator_root")"
      mkdir -p -- "$simulator_parent"

      current_version=""
      if [ -L "$simulator_root/current" ]; then
        current_version="$(readlink "$simulator_root/current")"
      fi

      needs_copy=true
      if [ "$current_version" = "$simulator_version" ] \
        && [ -f "$simulator_root/$simulator_version/meta_openxr_simulator.json" ]; then
        needs_copy=false
      fi

      if [ "$needs_copy" = true ]; then
        simulator_staging="$(mktemp -d "$simulator_parent/.MetaXRSimulator.XXXXXX")"
        trap 'rm -rf -- "$simulator_staging"' EXIT

        /usr/bin/ditto "$simulator_real_path" "$simulator_staging/$simulator_version"
        if [ ! -f "$simulator_staging/$simulator_version/meta_openxr_simulator.json" ]; then
          printf '%s\n' "Copied Meta XR Simulator is missing its runtime manifest" >&2
          exit 1
        fi
        ln -s "$simulator_version" "$simulator_staging/current"

        simulator_group="$(id -gn "$simulator_user")"
        chown -R "$simulator_user:$simulator_group" "$simulator_staging"

        rm -rf -- "$simulator_root"
        mv -- "$simulator_staging" "$simulator_root"
        trap - EXIT
      else
        simulator_group="$(id -gn "$simulator_user")"
        chown -R "$simulator_user:$simulator_group" "$simulator_root"
      fi

      for entry in "$simulator_root"/*; do
        if [ ! -e "$entry" ] && [ ! -L "$entry" ]; then
          continue
        fi
        entry_name="$(basename -- "$entry")"
        if [ "$entry_name" != "$simulator_version" ] && [ "$entry_name" != "current" ]; then
          rm -rf -- "$entry"
        fi
      done
    '';
```

The exact behaviors implemented by this fragment are:

- It runs after nix-darwin's built-in `homebrew` activation because the hook is `postActivation`.
- It resolves `<homebrew-prefix>/opt/meta-xr-simulator` with GNU `readlink` from the activation PATH and derives the version from the resolved Cellar directory name.
- It validates the source directory and `meta_openxr_simulator.json` before touching the destination.
- It stages the copy in a sibling temporary directory with `/usr/bin/ditto`, preserving the package's relative `SIMULATOR.so` reference.
- It only replaces the old tree after the staged copy and manifest check succeed.
- It skips the expensive copy when the current version and manifest are already present, but still removes obsolete non-`current` entries.
- It assigns the final tree to the configured user's primary group because nix-darwin runs activation as root.
- It does not call `brew`, `tar`, or `post_installation_macos.sh`.

- [ ] **Step 2: Format the Nix file and inspect the generated shell**

Run:

```bash
nix fmt -- modules/darwin/desktop/vr.nix
nix eval --raw '.#darwinConfigurations.Himeko.config.system.activationScripts.postActivation.text' > /tmp/meta-xr-post-activation.sh
bash -n /tmp/meta-xr-post-activation.sh
```

Expected: formatting completes, `nix eval` writes the fragment, and `bash -n` exits successfully. Do not run the generated fragment against the real user library during this step.

- [ ] **Step 3: Verify activation ordering and required commands**

Run:

```bash
activation_script="$(nix eval --raw '.#darwinConfigurations.Himeko.config.system.build.activationScript')"
rg -n -U 'Homebrew Bundle.*Meta XR|Homebrew Bundle|Meta XR Simulator|postActivation' "$activation_script"
```

Expected: the generated activation script contains the built-in `Homebrew Bundle` text before the Meta XR synchronization text. The `postActivation` fragment must contain `readlink`, `/usr/bin/ditto`, `mktemp`, `chown`, and the `current` symlink creation.

- [ ] **Step 4: Exercise version detection and cleanup with a temporary fixture**

Run the following disposable fixture test. It rewrites only the generated fragment's absolute source and destination paths, so the real Homebrew Cellar and user library are not modified:

```bash
fixture="$(mktemp -d)"
test_user="$(id -un)"
mkdir -p "$fixture/cellar/meta-xr-simulator/71.0.0" "$fixture/opt" "$fixture/library/MetaXR"
touch "$fixture/cellar/meta-xr-simulator/71.0.0/meta_openxr_simulator.json"
touch "$fixture/cellar/meta-xr-simulator/71.0.0/SIMULATOR.so"
ln -s "$fixture/cellar/meta-xr-simulator/71.0.0" "$fixture/opt/meta-xr-simulator"
perl -pe "s|/opt/homebrew/opt/meta-xr-simulator|$fixture/opt/meta-xr-simulator|g; s|/Users/ojii3/Library/MetaXR/MetaXRSimulator|$fixture/library/MetaXR/MetaXRSimulator|g; s|simulator_user='ojii3'|simulator_user='$test_user'|g" /tmp/meta-xr-post-activation.sh > "$fixture/run.sh"
bash "$fixture/run.sh"
test -f "$fixture/library/MetaXR/MetaXRSimulator/71.0.0/meta_openxr_simulator.json"
test "$(readlink "$fixture/library/MetaXR/MetaXRSimulator/current")" = 71.0.0

mkdir -p "$fixture/library/MetaXR/MetaXRSimulator/70.0.0"
bash "$fixture/run.sh"
test ! -e "$fixture/library/MetaXR/MetaXRSimulator/70.0.0"
test -f "$fixture/library/MetaXR/MetaXRSimulator/71.0.0/meta_openxr_simulator.json"

mkdir -p "$fixture/cellar/meta-xr-simulator/72.0.0"
touch "$fixture/cellar/meta-xr-simulator/72.0.0/meta_openxr_simulator.json"
touch "$fixture/cellar/meta-xr-simulator/72.0.0/SIMULATOR.so"
ln -sfn "$fixture/cellar/meta-xr-simulator/72.0.0" "$fixture/opt/meta-xr-simulator"
bash "$fixture/run.sh"
test -f "$fixture/library/MetaXR/MetaXRSimulator/72.0.0/meta_openxr_simulator.json"
test "$(readlink "$fixture/library/MetaXR/MetaXRSimulator/current")" = 72.0.0
test ! -e "$fixture/library/MetaXR/MetaXRSimulator/71.0.0"
```

Expected: every `test` succeeds; the first run copies 71.0.0, the second run skips copying and removes the old 70.0.0 directory, and the third run switches to 72.0.0 while removing 71.0.0.

- [ ] **Step 5: Commit the activation implementation**

Run:

```bash
git add -- modules/darwin/desktop/vr.nix
git commit -m "feat: synchronize Meta XR Simulator runtime"
```

The commit should contain only the related `vr.nix` changes. Leave the pre-existing `modules/home/vr.nix` and `modules/darwin/vr/` changes unstaged.

### Task 3: Run Repository-Level Verification

**Files:**
- Verify: `modules/darwin/desktop/vr.nix`
- Verify: `docs/superpowers/specs/2026-08-06-meta-xr-simulator-sync-design.md`
- Verify: `docs/superpowers/plans/2026-08-06-meta-xr-simulator-sync.md`

- [ ] **Step 1: Run formatting and flake checks**

Run:

```bash
nix fmt -- modules/darwin/desktop/vr.nix
nix flake check --no-build
```

Expected: the formatter makes no further changes after the implementation commit, and all flake checks pass, including `darwin-modules` evaluation and formatting.

- [ ] **Step 2: Review the final diff and worktree**

Run:

```bash
git diff --check
git status --short
git diff HEAD~1..HEAD -- modules/darwin/desktop/vr.nix
```

Confirm that the final implementation:

- uses the Homebrew prefix option and no hard-coded Homebrew architecture path;
- uses `current/meta_openxr_simulator.json` in `XR_RUNTIME_JSON`;
- runs from `postActivation` rather than the unused custom activation attribute;
- validates before replacing the old tree;
- removes old versions and preserves only the current version plus `current`;
- does not stage unrelated pre-existing changes.
