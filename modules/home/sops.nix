{ inputs, config, lib, ... }:
let
  cfg = config.dot.home;
  sopsSecrets = config.sops.secrets;
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

      # Obsidian Sync secrets
      secrets.obsidian_sync_couchdb_password = lib.mkIf cfg.obsidianSync.enable { };
      secrets.obsidian_sync_cloudflared_token = lib.mkIf cfg.obsidianSync.enable { };

      # Obsidian Sync templates (generate env files from secrets)
      templates."obsidian-sync-couchdb.env" = lib.mkIf cfg.obsidianSync.enable {
        content = ''
          COUCHDB_PASSWORD=${config.sops.placeholder.obsidian_sync_couchdb_password}
        '';
      };
      templates."obsidian-sync-cloudflared.env" = lib.mkIf cfg.obsidianSync.enable {
        content = ''
          TUNNEL_TOKEN=${config.sops.placeholder.obsidian_sync_cloudflared_token}
        '';
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
    '';
  };
}
