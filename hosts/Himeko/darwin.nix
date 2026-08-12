{ ... }:
{
  imports = [ ../../modules/darwin ];

  dot.darwin = {
    core = {
      enable = true;
      fonts.enable = true;
      sops.enable = true;
    };
    desktop = {
      enable = true;
      apps.enable = true;
      vr.enable = true;
      hammerspoon.enable = true;
      rift.enable = true;
    };
    networking = {
      enable = true;
      tailscale.enable = true;
      openssh.enable = true;
      cloudflared.enable = false;
      cloudflareOne.enable = true;
    };
  };

  system.stateVersion = 6;
}
