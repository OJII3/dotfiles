{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  system = pkgs.stdenv.hostPlatform.system;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  t3code = inputs.llm-agents-nix.packages.${system}.t3code;
  t3codeDesktop = inputs.llm-agents-nix.packages.${system}.t3code-desktop;
  serviceHome = "${config.home.homeDirectory}/.t3-service";
in
{
  config = lib.mkIf (cfg.enable && cfg.t3code.enable) {
    home.sessionVariables.T3CODE_HOME = serviceHome;

    home.packages = [
      t3code
      t3codeDesktop
    ];

    systemd.user.services.t3code = lib.mkIf (cfg.t3code.backgroundService.enable && isLinux) {
      Unit.Description = "T3 Code background service";
      Service = {
        Type = "simple";
        WorkingDirectory = config.home.homeDirectory;
        Environment = [
          "T3CODE_HOME=${serviceHome}"
          "SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt"
        ];
        ExecStart = "${t3code}/bin/t3 serve --host ${cfg.t3code.backgroundService.host} --port 3773";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = [ "default.target" ];
    };

    launchd.agents.t3code = lib.mkIf (cfg.t3code.backgroundService.enable && isDarwin) {
      enable = true;
      config = {
        Label = "com.ojii3.t3code.service";
        ProgramArguments = [
          "${t3code}/bin/t3"
          "serve"
          "--host"
          cfg.t3code.backgroundService.host
          "--port"
          "3773"
        ];
        EnvironmentVariables.T3CODE_HOME = serviceHome;
        WorkingDirectory = config.home.homeDirectory;
        RunAtLoad = true;
        KeepAlive = true;
        ProcessType = "Background";
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/t3code.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/t3code-error.log";
      };
    };
  };
}
