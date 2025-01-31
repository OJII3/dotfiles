{ inputs, ... }: {
  imports = [
    ./hyprland.nix
    ./steam.nix
    ./flatpak.nix
  ]
  ++ [
    inputs.xremap.nixosModules.default
  ];
}
