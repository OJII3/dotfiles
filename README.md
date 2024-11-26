# NixOS & Arch Linux Dotfiles

I preserve non-nix config as possible.

## NixOS

```bash
sudo nixos-rebuild switch --flake .#myNixOS
home-manager switch --flake .#myHomeManager
```

## Arch Linux

Original dotfiles is `./home`

```bash
cd ./home
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
- Lutris (game launcher, installer)
- Fcitx5
  - skk
- Kitty (terminal which has own image protocol)
