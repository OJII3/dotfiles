# Container runtimes: Podman / Docker.
{ config, lib, ... }:
let
  cfg = config.dot.core;
in
{
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # Podman
      (lib.mkIf cfg.virtualisation.podman.enable {
        virtualisation.podman = {
          enable = true;
          dockerCompat = cfg.virtualisation.podman.dockerCompat;
          defaultNetwork.settings.dns_enabled = true;
        };
      })

      # Docker
      (lib.mkIf cfg.virtualisation.docker.enable {
        virtualisation.docker = {
          enable = true;
          rootless = {
            enable = cfg.virtualisation.docker.rootless.enable;
            setSocketVariable = cfg.virtualisation.docker.rootless.enable;
          };
        };
        # Disable podman dockerCompat when using Docker
        virtualisation.podman.dockerCompat = lib.mkForce false;

        # Add user to docker group for non-rootless mode
        users.users.${cfg.user.name}.extraGroups = lib.mkIf (!cfg.virtualisation.docker.rootless.enable) [
          "docker"
        ];
      })
    ]
  );
}
