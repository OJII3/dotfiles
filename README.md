# dotfiles

## NixOS

When adding a new host, 

- Clone dotfiles. `nix run nixpkgs#git clone https://github.com/ojii3/dotfiles`
- Copy `/etc/nixos/hardware-configuration.nix` into `hosts/<hostname>/` dir.
- Create `./nixos/<hostname>/nixos.nix` from other host's config, and edit it.

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

## Home Manager

```bash
home-manager switch --flake .#<username>@<hostname>
```

## Without Nix

old dotfiles is in `./home`.

## Apps & Tools

- Hyprland
  - Waybar
  - Anyrun (launcher)
- Neovim
  - Lazy.nvim (plugin manager)
  - Mason.nvim (lsp manager, if not nix exist)
  - Image.nvim (image viewr for Kitty Graphic Protocol)
- Zsh
  - Starship
  - fzf (for extended history search)
  - yazi (tui filer with graphical preview)
- tdf
  - In-terminal PDF Viewer (works with Kitty Graphic Protocol)
- Bottles (wine manager)
- Fcitx5
  - skk
- Kitty (terminal which has own image protocol)


## Memo

It was not so smooth for me to install Nix and Home Manager to Raspberry Pi OS.

- `DeterminateSystems/nix-installer`: easy installer, with flakes and nix-command enabled.

```bash
nix run nixpkgs#home-manager -- switch --flake .#<myflake>
```

Then erorr occured, so I tried below commands.

```bash
sudo mkdir -m -755 -p /nix/var/nix/{profiles,gcroots}/per-user/$USER
sudo chown -R $USER:nixbld /nix/var/nix/{profiles,gcroots}/per-user/$USER
```

Then I run home-manager command and it worked.
