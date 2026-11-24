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
  importGhq = pkgs.writeShellApplication {
    name = "orca-import-ghq";
    runtimeInputs = [
      orca
      pkgs.ghq
      pkgs.git
    ];
    text = builtins.readFile ./import-ghq.sh;
  };
in
{
  config = lib.mkIf (cfg.enable && cfg.orca.enable) {
    home.packages = [
      orca
      importGhq
    ];

    home.activation = lib.mkIf (service.enable && config.dot.home.git.enable) {
      orcaImportGhqRepos = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
        ${importGhq}/bin/orca-import-ghq
      '';
    };

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
