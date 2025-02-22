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

Old dotfiles are in `home`, but it's gradually being moved to `home-manager`.

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
- Kitty | Ghostty (terminal which has own image protocol)

