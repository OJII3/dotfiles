{
  config,
  pkgs,
  lib,
  ...
}:
{
  sops.secrets."github-runners-tuatmcc-wand" = { };
  services.github-runners = {
    tuatmcc-wand = {
      enable = true;
      name = "ojii3-server-nixos";
      tokenFile = config.sops.secrets."github-runners-tuatmcc-wand".path;
      url = "https://github.com/tuatmcc/SchoolFestival2025_Unity";
      nodeRuntimes = "node20";
      extraEnvironment = {
        ACTIONS_RUNNER_FORCE_ACTIONS_NODE_VERSION = "20";
      };
      extraLabels = [
        "nixos"
        "ojii3"
      ];
      extraPackages = with pkgs; [
        nodejs_24
        docker
        docker-compose
        rsync
      ];
      serviceOverrides = {
        ProcSubset = lib.mkForce "all";
        ProtectProc = lib.mkForce "default";
        PrivateUsers = lib.mkForce false;
        ProtectKernelTunables = lib.mkForce false;
        ProtectControlGroups = lib.mkForce false;
        SupplementaryGroups = [ "docker" ];
        Environment = [
          "ACTIONS_RUNNER_FORCE_ACTIONS_NODE_VERSION=20"
        ];
      };
    };
  };
}
