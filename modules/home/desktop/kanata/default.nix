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
  config = lib.mkIf cfg.kanata.enable {
    home.packages = [ pkgs.kanata ];

    # kanata config file
    home.file.".config/kanata/kanata.kbd".source = ./kanata.kbd;

    # macOS: LaunchAgent for auto-start
    launchd.agents.kanata = lib.mkIf pkgs.stdenv.isDarwin {
      enable = true;
      config = {
        Label = "org.kanata.daemon";
        ProgramArguments = [
          "${pkgs.kanata}/bin/kanata"
          "-c"
          "${config.home.homeDirectory}/.config/kanata/kanata.kbd"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/kanata.out.log";
        StandardErrorPath = "/tmp/kanata.err.log";
      };
    };

    # Linux: systemd user service
    systemd.user.services.kanata = lib.mkIf pkgs.stdenv.isLinux {
      Unit = {
        Description = "Kanata keyboard remapper";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.kanata}/bin/kanata -c ${config.home.homeDirectory}/.config/kanata/kanata.kbd";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
