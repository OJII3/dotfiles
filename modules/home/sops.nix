{ inputs, config, username, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = "home/${username}/.config/sops/age/keys.txt"; # must not have a password
    age.generateKey = true;
    defaultSopsFile = ../../assets/secrets/secrets.json;
    defaultSopsFormat = "json";
    secrets.gemini_api_key = { };
  };

  programs.zsh.initExtra = ''
    export GEMINI_API_KEY="$(<${config.sops.secrets.gemini_api_key.path})"
  '';
}

