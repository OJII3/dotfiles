{ inputs, ... }: {
  imports = [
    ./flatpak.nix
    ./hyprland.nix
    ./steam.nix
    ./keymap.nix
  ];
}
