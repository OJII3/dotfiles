{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays."x86_64-linux"
  ];

  services.proxmox-ve = {
    enable = true;
  };

  nix.settings = {
    substituters = [
      "https://cache.saumon.network/proxmox-nixos"
    ];
    trusted-public-keys = [
      "proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="
    ];
  };
}
