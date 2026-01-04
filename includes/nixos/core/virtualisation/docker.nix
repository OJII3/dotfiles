{ ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = false;
        setSocketVariable = false;
      };
    };
    # dockerと併用する場合はpodmanのdockerCompatを無効化
    podman.dockerCompat = false;
  };

  users.users.ojii3 = {
    extraGroups = [ "docker" ];
  };
}
