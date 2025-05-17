{ inputs, ... }: {
  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays."x86_64-linux"
  ];

  services.proxmox-ve = {
    enable = true;
    ipAddress = "192.168.0.1";
  };
}

