# Desktop VR Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extract VR config from `gaming.nix` into a standalone `vr.nix` with `dot.desktop.vr` option namespace, matching Darwin module structure.

**Architecture:** Move VR settings (Monado, Immersed, wayvr, GPU graphics) out of `gaming.nix` into a new `vr.nix` file. Option path changes from `dot.desktop.gaming.vr.enable` to `dot.desktop.vr.enable`. The `gaming.nix` becomes Steam-only.

**Tech Stack:** NixOS module system, services.monado, programs.immersed

---

### Task 1: Add `dot.desktop.vr` option and remove `gaming.vr`

**Files:**
- Modify: `modules/nixos/desktop/options.nix:36-48`

- [ ] **Edit `options.nix`**: Add `vr.enable = lib.mkEnableOption "VR support (Monado, Immersed, wayvr)";` to the top-level `dot.desktop` block. Remove the `vr` block inside `gaming`.

  Change:
  ```nix
      gaming = {
        enable = lib.mkEnableOption "gaming support";

        steam = {
          enable = lib.mkEnableOption "Steam" // {
            default = true;
          };
        };

        vr = {
          enable = lib.mkEnableOption "VR support (Monado, etc.)";
        };
      };
  ```

  To:
  ```nix
      vr = {
        enable = lib.mkEnableOption "VR support (Monado, Immersed, wayvr)";
      };

      gaming = {
        enable = lib.mkEnableOption "gaming support";

        steam = {
          enable = lib.mkEnableOption "Steam" // {
            default = true;
          };
        };
      };
  ```

- [ ] **Verify edit**: Read `options.nix` to confirm `dot.desktop.vr.enable` exists and `gaming.vr` is gone.

---

### Task 2: Create `modules/nixos/desktop/vr.nix`

**Files:**
- Create: `modules/nixos/desktop/vr.nix`

- [ ] **Write `vr.nix`**

  ```nix
  {
    config,
    lib,
    pkgs,
    ...
  }:
  let
    cfg = config.dot.desktop;
  in
  {
    config = lib.mkIf (cfg.enable && cfg.vr.enable) {
      environment.systemPackages = [ pkgs.wayvr ];
      programs.immersed.enable = true;

      services.monado = {
        enable = true;
        defaultRuntime = true;
      };
      systemd.user.services.monado.environment = {
        STEAMVR_LH_ENABLE = "1";
        XRT_COMPOSITOR_COMPUTE = "1";
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [ pkgs.libva ];
      };
    };
  }
  ```

---

### Task 3: Remove VR section from `gaming.nix`

**Files:**
- Modify: `modules/nixos/desktop/gaming.nix:24-43`

- [ ] **Edit `gaming.nix`**: Remove the VR block (lines 24-43), leaving only the Steam block.

  Before (`lib.mkMerge` with two items):
  ```nix
    config = lib.mkIf cfg.enable (
      lib.mkMerge [
        # Steam
        (lib.mkIf (cfg.gaming.enable && cfg.gaming.steam.enable) {
          programs.steam = {
            enable = true;
            dedicatedServer.openFirewall = true;
            fontPackages = [ pkgs.migu ];
            extraCompatPackages = [ pkgs.proton-ge-bin ];
          };
        })

        # VR (Monado, etc.)
        (lib.mkIf (cfg.gaming.enable && cfg.gaming.vr.enable) {
          environment.systemPackages = [ pkgs.wayvr ];
          programs.immersed.enable = true;

          services.monado = {
            enable = true;
            defaultRuntime = true;
          };
          systemd.user.services.monado.environment = {
            STEAMVR_LH_ENABLE = "1";
            XRT_COMPOSITOR_COMPUTE = "1";
          };

          hardware.graphics = {
            enable = true;
            enable32Bit = true;
            extraPackages = [ pkgs.libva ];
          };
        })
      ]
    );
  ```

  After:
  ```nix
    config = lib.mkIf (cfg.enable && cfg.gaming.enable && cfg.gaming.steam.enable) {
      programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        fontPackages = [ pkgs.migu ];
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
    };
  ```

  Also remove the `lib.mkMerge` wrapper since there's only one item left.

---

### Task 4: Add `./vr.nix` to desktop's module imports

**Files:**
- Modify: `modules/nixos/desktop/default.nix`

- [ ] **Edit `default.nix`**: Add `./vr.nix` to the imports list (alphabetically between `./sunshine.nix` and `./waydroid.nix`).

  ```nix
    imports = [
      ./options.nix
      ./android-dev.nix
      ./bitwarden.nix
      ./flatpak.nix
      ./fonts.nix
      ./gaming.nix
      ./greetd.nix
      ./hyprland.nix
      ./keyd.nix
      ./peripheral.nix
      ./sunshine.nix
      ./vr.nix
      ./waydroid.nix
      ./gnome.nix
    ];
  ```

---

### Task 5: Update host config to use new option path

**Files:**
- Modify: `hosts/Aglaea/nixos.nix:34-37`

- [ ] **Edit `Aglaea/nixos.nix`**: Change `gaming.vr.enable = true;` to `vr.enable = true;`.

  Before:
  ```nix
      gaming = {
        enable = true;
        vr.enable = true;
      };
  ```

  After:
  ```nix
      gaming.enable = true;
      vr.enable = true;
  ```

---

### Task 6: Verify the build

- [ ] **Run `nix flake check`** to verify module evaluation succeeds.

  ```bash
  nix flake check --no-build
  ```

  Expected: No errors related to removed options or missing files.

- [ ] **Build Aglaea config** to verify full evaluation.

  ```bash
  nix build .#nixosConfigurations.Aglaea.config.system.build.toplevel --no-link
  ```

  Expected: Build succeeds.
