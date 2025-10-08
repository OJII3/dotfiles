{ ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = false;
        setSocketVariable = true;
      };
    };
    # virtualbox.host.enable = true;
  };

  users.users.ojii3 = {
    extraGroups = [ "docker" ];
  };
}
