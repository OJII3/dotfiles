{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dot.core.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.kwallet
      kdePackages.kwallet-pam
    ];
    # Kwallet for no GUI sessions
    security.pam.services.login.kwallet = {
      enable = true;
      forceRun = true;
    };
  };
}
