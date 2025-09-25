{ inputs, config, ... }:
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
    secrets.anthropic_api_key = { };
    secrets.morph_api_key = { };
  };

  systemd.user.services.sops-nix = {
    Install = {
      WantedBy = [ "default.target" ]; # additiaonal target for no-gui sessions
    };
  };

  programs.zsh.initContent = ''
    export AVANTE_ANTHROPIC_API_KEY="$(<${config.sops.secrets.anthropic_api_key.path})"
    export GEMINI_API_KEY="$(<${config.sops.secrets.gemini_api_key.path})"
    export GOOGLE_SEARCH_API_KEY="$(<${config.sops.secrets.google_search_api_key.path})"
    export GOOGLE_SEARCH_ENGINE_ID="$(<${config.sops.secrets.google_search_engine_id.path})"
    export MORPH_API_KEY="$(<${config.sops.secrets.morph_api_key.path})"
  '';
}
