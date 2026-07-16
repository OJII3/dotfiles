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
    };
    networking = {
      enable = true;
      tailscale.enable = true;
      openssh.enable = true;
      cloudflared.enable = true;
    };
  };

  system.stateVersion = 6;
}
