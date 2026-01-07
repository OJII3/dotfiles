{ ... }:
{
  imports = [ ../../modules/darwin ];

  my.darwin = {
    core = {
      enable = true;
      fonts.enable = true;
      networking.enable = true;
      sops.enable = true;
    };
    desktop = {
      enable = true;
      apps.enable = true;
      vr.enable = true;
    };
  };

  system.stateVersion = 6;
}
