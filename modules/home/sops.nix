{ inputs, config, username, pkgs, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../../assets/secrets/secrets.json;
    defaultSopsFormat = "json";
    gnupg.home = "${config.home.homeDirectory}/.gnupg";
    gnupg.sshKeyPaths = [ ];
    secrets.gemini_api_key = { };
    secrets.google_search_api_key = { };
    secrets.google_search_engine_id = { };
  };

systemd.user.services.sops-nix = {
  Install = {
    WantedBy = [ "default.target" ];
  };
};

  programs.zsh.initContent = ''
    export GEMINI_API_KEY="$(<${config.sops.secrets.gemini_api_key.path})"
    export GOOGLE_SEARCH_API_KEY="$(<${config.sops.secrets.google_search_api_key.path})"
    export GOOGLE_SEARCH_ENGINE_ID="$(<${config.sops.secrets.google_search_engine_id.path})"
  '';
}

