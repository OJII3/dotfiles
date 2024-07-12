# NixOS & Arch Linux Dotfiles

## NixOS

```bash
sudo nixos-rebuild switch --flake .#myNixOS
home-manager switch --flake .#myHomeManager
```

## Arch Linux

```bash
./home-manager/dotfiles/install.sh
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
- termpdf.py (graphical pdf viewer which works inside kitty)
