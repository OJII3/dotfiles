# dotfiles

Multi-platform dotfiles powered by Nix Flakes.
Declarative configuration management using the `dot.*` options namespace.

## Module Structure

```
modules/
├── nixos/    # NixOS modules (dot.core, dot.desktop, dot.hardware, dot.networking, dot.server)
├── darwin/   # nix-darwin modules (dot.darwin.core, dot.darwin.desktop, dot.darwin.networking)
├── home/     # Home Manager modules (dot.home.*)
└── windows/  # Windows setup scripts and dotter-managed files
```

See each directory's README for details:
- [modules/nixos/README.md](modules/nixos/README.md)
- [modules/darwin/README.md](modules/darwin/README.md)
- [modules/home/README.md](modules/home/README.md)
- [modules/home/ai/skills/README.md](modules/home/ai/skills/README.md)

## Hosts

| Host | Type | Configuration |
|------|------|---------------|
| **Aglaea** (decommitioned) | Laptop | NixOS + Home Manager |
| **Bronya** (decommitioned) | Desktop | NixOS + Home Manager |
| **Cipher** | Server | GMKTec G3 | NixOS + AdGuard Home |
| **Cyrene** | WSL | NixOS-WSL + Home Manager |
| **Evanescia** | Laptop | Ubuntu + Home Manager |
| **Himeko** | MacBook | nix-darwin |
| **Lingsha** | Desktop | Ubuntu + Home Manager |
| **Welt** | Raspberry Pi 4B |  | Raspberry Pi OS + Home Manager |
| **SilverWolf** | Android | nix-on-droid |

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

Secrets are encrypted with [sops-nix](https://github.com/Mic92/sops-nix) and stored in `assets/secrets/secrets.json`.

```bash
# Edit secrets (decrypts in your editor)
sops assets/secrets/secrets.json

# Encrypt a new file
sops -e plaintext.json > encrypted.json

# Decrypt to stdout
sops -d assets/secrets/secrets.json
```
