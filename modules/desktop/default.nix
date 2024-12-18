{ inputs, ... }: {
  imports = [
    ./hyprland.nix
    ./steam.nix
  ]
  ++ [
    inputs.xremap.nixosModules.default
  ];
}
