{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.desktop;
in
{
  config = lib.mkIf (cfg.kanata.enable && pkgs.stdenv.hostPlatform.isLinux) {
    home.packages = [ pkgs.kanata ];
    home.file.".config/kanata/linux.kbd".source = ./linux.kbd;

    systemd.user.services.kanata = {
      Unit = {
        Description = "Kanata keyboard remapper";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.kanata}/bin/kanata --no-wait --cfg ${config.xdg.configHome}/kanata/linux.kbd";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
