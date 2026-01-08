# dotfiles

Multi-platform dotfiles powered by Nix Flakes.
Declarative configuration management using the `dot.*` options namespace.

## Module Structure

```
modules/
├── nixos/    # NixOS modules (dot.core, dot.desktop, dot.hardware, dot.networking, dot.server)
├── darwin/   # nix-darwin modules (dot.darwin.core, dot.darwin.desktop)
└── home/     # Home Manager modules (dot.home.*)
```

See each directory's README for details:
- [modules/nixos/README.md](modules/nixos/README.md)
- [modules/darwin/README.md](modules/darwin/README.md)
- [modules/home/README.md](modules/home/README.md)

## Hosts

| Host | Type | Hardware | Configuration |
|------|------|----------|---------------|
| **Aglaea** | Desktop | ThinkCentre (AMD GPU) | NixOS + GNOME |
| **Bronya** | Desktop | i5-13th + RTX 3060 | NixOS + Hyprland (decommissioned) |
| **Cipher** | Server | GMKTec G3 | NixOS + AdGuard Home |
| **Cyrene** | WSL | i5-13th + RTX 3060 | NixOS-WSL |
| **Himeko** | Laptop | MacBook Pro M2 | nix-darwin |
| **Lingsha** | Laptop | ThinkPad E14 Gen 6 | Ubuntu + Home Manager |
| **Welt** | SBC | Raspberry Pi 4B | Raspberry Pi OS + Home Manager |
| **SilverWolf** | Tablet | Xiaomi Pad 6s Pro | nix-on-droid |

## Commands

### Check

```bash
nix flake check
```

### Build (dry-run)

```bash
# NixOS
nixos-rebuild build --flake .#<hostname> --dry-run

# nix-darwin
darwin-rebuild build --flake .#<hostname> --dry-run

# Home Manager
home-manager build --flake .#<username>@<hostname> --dry-run
```

### Build & Apply

```bash
# NixOS
sudo nixos-rebuild switch --flake .#<hostname>

# nix-darwin
darwin-rebuild switch --flake .#<hostname>

# Home Manager
home-manager switch --flake .#<username>@<hostname>
```

### Update Flake

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake update nixpkgs
```

## Favorite Apps & Tools

- **Hyprland** - Wayland compositor (custom animations & workspace config)
- **Neovim** - Lua-based config with LSP/DAP/Treesitter integration
- **Zsh** - zinit + p10k, custom functions & aliases
- **Ghostty** - GPU-accelerated terminal
- **fcitx5 + SKK** - Japanese input (custom SKK dictionaries)
- **keyd** - Key remapping (CapsLock → Ctrl/Esc)
- **Waybar** - Status bar (custom CSS/modules)
- **swaync** - Notification center
- **anyrun** - App launcher
- **mise** - Runtime version manager
- **direnv** - Per-directory environment variables
- **Tailscale** - Mesh VPN
- **sops-nix** - Secrets management

