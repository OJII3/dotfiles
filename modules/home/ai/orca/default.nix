{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  service = cfg.orca.backgroundService;
  orca = inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.orca;
in
{
  config = lib.mkIf (cfg.enable && cfg.orca.enable) {
    home.packages = [ orca ];

    systemd.user.services.orca-serve = lib.mkIf service.enable {
      Unit.Description = "Orca headless runtime";
      Service = {
        WorkingDirectory = config.home.homeDirectory;
        ExecStart = lib.concatStringsSep " " (
          [
            "${orca}/bin/orca"
            "serve"
            "--bind"
            service.bind
            "--port"
            (toString service.port)
          ]
          ++ lib.optionals (service.pairingAddress != null) [
            "--pairing-address"
            service.pairingAddress
          ]
        );
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
