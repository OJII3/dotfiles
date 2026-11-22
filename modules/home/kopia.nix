# Kopia repository server as a Home Manager user service.
# Clients connect with `kopia repository connect server --url=http://<host>:<port>`
# and authenticate with their own `kopia server user` account.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home;

  configFile = "${cfg.kopia.dataDir}/kopia.config";
  repositoryDir = "${cfg.kopia.dataDir}/repository";

  # Kopia only accepts both passwords through the environment. Reading them from
  # files keeps secrets out of the Nix store and out of the systemd command line.
  exportPasswords = ''
    export KOPIA_PASSWORD="$(cat ${lib.escapeShellArg cfg.kopia.repositoryPasswordFile})"
    export KOPIA_SERVER_CONTROL_PASSWORD="$(cat ${lib.escapeShellArg cfg.kopia.serverControlPasswordFile})"
  '';

  initScript = pkgs.writeShellScript "kopia-repository-init" ''
    set -eu
    mkdir -p ${lib.escapeShellArg cfg.kopia.dataDir}
    ${exportPasswords}
    if ! ${cfg.kopia.package}/bin/kopia --config-file ${lib.escapeShellArg configFile} repository status >/dev/null 2>&1; then
      ${cfg.kopia.package}/bin/kopia --config-file ${lib.escapeShellArg configFile} repository create filesystem \
        --path ${lib.escapeShellArg repositoryDir}
    fi
  '';

  startScript = pkgs.writeShellScript "kopia-server-start" ''
    set -eu
    ${exportPasswords}
    exec ${cfg.kopia.package}/bin/kopia --config-file ${lib.escapeShellArg configFile} server start \
      --address ${lib.escapeShellArg "${cfg.kopia.listenAddress}:${toString cfg.kopia.port}"} \
      --server-control-username ${lib.escapeShellArg cfg.kopia.controlUsername} \
      --ui=${lib.boolToString cfg.kopia.ui}
  '';
in
{
  config = lib.mkIf cfg.kopia.enable {
    assertions = [
      {
        assertion = cfg.kopia.repositoryPasswordFile != null;
        message = "dot.home.kopia.repositoryPasswordFile must be set.";
      }
      {
        assertion = cfg.kopia.serverControlPasswordFile != null;
        message = "dot.home.kopia.serverControlPasswordFile must be set.";
      }
      {
        assertion = lib.hasPrefix "/" cfg.kopia.dataDir;
        message = "dot.home.kopia.dataDir must be an absolute path.";
      }
    ];

    # systemd applies WorkingDirectory before ExecStartPre, so the directory must
    # exist before Home Manager starts the user services.
    home.activation.kopiaDataDir = lib.hm.dag.entryBefore [ "reloadSystemd" ] ''
      run mkdir -p ${lib.escapeShellArg cfg.kopia.dataDir}
    '';

    systemd.user.services.kopia-server = {
      Unit = {
        Description = "Kopia repository server";
        Wants = [ "sops-nix.service" ];
        After = [ "sops-nix.service" ];
      };

      Service = {
        Type = "simple";
        ExecStartPre = initScript;
        ExecStart = startScript;
        WorkingDirectory = cfg.kopia.dataDir;
        Restart = "on-failure";
        RestartSec = 5;

        NoNewPrivileges = true;
        PrivateTmp = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
