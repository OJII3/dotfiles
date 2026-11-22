{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.dot.home;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  config = lib.mkIf cfg.sops.enable {
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
      secrets.context7_api_key = { };
      secrets.onshape_access_key = { };
      secrets.onshape_secret_key = { };
      secrets.usage_token = { };
      secrets.kopia_repository_password = lib.mkIf config.dot.home.kopia.enable {
        sopsFile = ../../assets/secrets/kopia.yaml;
        format = "yaml";
      };
      secrets.kopia_server_control_password = lib.mkIf config.dot.home.kopia.enable {
        sopsFile = ../../assets/secrets/kopia.yaml;
        format = "yaml";
      };
    };

    systemd.user.services.sops-nix = {
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    programs.zsh.initContent = ''
      export AVANTE_ANTHROPIC_API_KEY="$(<${config.sops.secrets.anthropic_api_key.path})"
      export GOOGLE_SEARCH_API_KEY="$(<${config.sops.secrets.google_search_api_key.path})"
      export GOOGLE_SEARCH_ENGINE_ID="$(<${config.sops.secrets.google_search_engine_id.path})"
      export MORPH_API_KEY="$(<${config.sops.secrets.morph_api_key.path})"
      export CONTEXT7_API_KEY="$(<${config.sops.secrets.context7_api_key.path})"
      export ONSHAPE_ACCESS_KEY="$(<${config.sops.secrets.onshape_access_key.path})"
      export ONSHAPE_SECRET_KEY="$(<${config.sops.secrets.onshape_secret_key.path})"
    '';
  };
}
