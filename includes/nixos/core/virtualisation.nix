{ ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    # virtualbox.host.enable = true;
  };

  users.users.ojii3 = {
    extraGroups = [ "docker" ];
  };
}
