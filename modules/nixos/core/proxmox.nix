{ inputs, ... }: {
  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays."x86_64-linux"
  ];

  services.proxmox-ve = {
    enable = true;
  };

  nix.settings = inputs.proxmox-nixos.nixConfigs;
}

