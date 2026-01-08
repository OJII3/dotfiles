{ config, ... }:
{
  imports = [
    ./nextcloud-compose.nix
  ];
  services.cloudflared = {
    enable = true;
    tunnels = {
      "c0c11e26-b958-4d94-8697-91e49d0b50bf" = {
        credentialsFile = config.sops.secrets."cloudflared_creds_nextcloud".path;
        default = "http_status:404";
      };
    };
  };
}
