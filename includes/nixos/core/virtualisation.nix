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
    # virtualbox.host.enable = true;
  };

  users.users.ojii3 = {
    extraGroups = [ "docker" ];
  };
}
