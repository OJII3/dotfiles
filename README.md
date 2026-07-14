# dotfiles

Multi-platform dotfiles powered by Nix Flakes.
Declarative configuration management using the `dot.*` options namespace.

## Module Structure

```
modules/
├── nixos/    # NixOS modules (dot.core, dot.desktop, dot.hardware, dot.networking, dot.server)
├── darwin/   # nix-darwin modules (dot.darwin.core, dot.darwin.desktop)
├── home/     # Home Manager modules (dot.home.*)
└── windows/  # Windows setup scripts and dotter-managed files
```

See each directory's README for details:
- [modules/nixos/README.md](modules/nixos/README.md)
- [modules/darwin/README.md](modules/darwin/README.md)
- [modules/home/README.md](modules/home/README.md)
- [modules/home/ai/skills/README.md](modules/home/ai/skills/README.md)

## Hosts

| Host | Type | Hardware | Configuration |
|------|------|----------|---------------|
| **Aglaea** | Desktop | ThinkPad E14 Gen 6 | NixOS + GNOME |
| **Bronya** | Desktop | i5-13th + RTX 3060 | NixOS + Hyprland (decommissioned) |
| **Cipher** | Server | GMKTec G3 | NixOS + AdGuard Home |
| **Cyrene** | WSL | i5-13th + RTX 3060 | NixOS-WSL |
| **Himeko** | Laptop | MacBook Pro M2 | nix-darwin |
| **Lingsha** | Laptop | ThinkPad E14 Gen 6 | Ubuntu + Home Manager |
| **Welt** | SBC | Raspberry Pi 4B | Raspberry Pi OS + Home Manager |
| **SilverWolf** | Tablet | Xiaomi Pad 6s Pro | nix-on-droid |

### State Versions

Home Manager state versions are managed per host in `hosts/<Host>/home-manager.nix`.
Raise them when adopting the new Home Manager release defaults for that host.

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

### Windows

```powershell
# Run once from an elevated PowerShell session.
.\modules\windows\Setup.ps1
```

### Update Flake

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake update nixpkgs
```

## Secrets Management (sops-nix)

Secrets are encrypted with [sops-nix](https://github.com/Mic92/sops-nix) and stored in `assets/secrets/secrets.json`. The encryption key is defined in `.sops.yaml`.

### Prerequisites

- GnuPG installed
- Your GPG public key added to `.sops.yaml` under `keys`

### Adding a New Secret

1. **Edit the secrets file** (decrypts in your editor):

   ```bash
   sops assets/secrets/secrets.json
   ```

   Add a new key-value pair in the JSON:

   ```json
   {
     "my_new_secret": "super-secret-value",
     ...
   }
   ```

2. **Register the secret** in `modules/home/sops.nix`:

   ```nix
   secrets.my_new_secret = { };
   ```

3. **Use it as an environment variable** — add to `programs.zsh.initContent` in the same file:

   ```nix
   programs.zsh.initContent = ''
     export MY_NEW_SECRET="$(<${config.sops.secrets.my_new_secret.path})"
   '';
   ```

4. **Rebuild** to apply:

   ```bash
   home-manager switch --flake .#<username>@<hostname>
   ```

### Using Secrets in Other NixOS Modules

For system-level secrets (e.g. in NixOS or nix-darwin modules), use the same pattern with `config.sops.secrets.<name>.path` to reference the decrypted file at runtime.

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
