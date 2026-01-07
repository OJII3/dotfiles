{ inputs, username, ... }:
{
  imports = [
    ./.
    inputs.sops-nix.darwinModules.sops
  ];

  sops = {
    defaultSopsFile = ../../../assets/secrets/secrets.json;
    defaultSopsFormat = "json";
    gnupg.home = "/Users/${username}/.gnupg";
    gnupg.sshKeyPaths = [ ];
  };
}
