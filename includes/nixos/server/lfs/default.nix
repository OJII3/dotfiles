{ config, ... }:
{
  environment.etc."docker-env-lfs".source = config.sops.secrets.docker_env_lfs.path;
  imports = [
    ./lfs-server-compose.nix
  ];
}
