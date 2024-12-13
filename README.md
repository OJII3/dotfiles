# dotfiles

## NixOS

```bash
nix run nixpkgs#git clone https://github.com/ojii3/dotfiles
cd dotfiles
mkdir -p ./nixos/<hostname>
cp /etc/nixos/hardware-configuration.nix ./nixos/<hostname>/
# create ./nixos/<hostname>/default.nix from other host's config, and edit it
sudo nixos-rebuild switch --flake .#<hostname>
home-manager switch --flake .#myHomeManager
```

## Without Nix

old dotfiles is in `./home`.

```bash
sudo pacman -S git
git clone https://github.com/ojii3/dotfiles
cd ./dotfiles/home
./home/install.sh
```

## Awesome Apps

- Hyprland
  - Waybar
  - Anyrun (launcher)
- Neovim
  - Lazy.nvim (plugin manager)
  - Mason.nvim (lsp manager)
  - Image.nvim (image viewr for kitty)
- Zsh
  - Starship
  - fzf (for extended history search)
  - yazi (tui filer with graphical preview)
- Bottles (wine manager)
- Fcitx5
  - skk
- Kitty (terminal which has own image protocol)

