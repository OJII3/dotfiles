{ inputs, username, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../../assets/secrets/secrets.json;
    defaultSopsFormat = "json";
    gnupg.home = "/home/${username}/.gnupg";
    gnupg.sshKeyPaths = [ ];
    secrets."cloudflared_creds_nextcloud" = { };
    secrets."nextcloud_admin_pass" = { };
  };
}
