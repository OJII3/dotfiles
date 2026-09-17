{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  settingsFile = ./settings.json;
  generateSettingsScript = ./generate_settings.sh;
  settingsPath = "${config.home.homeDirectory}/.gemini/antigravity-cli/settings.json";
  commonPackages =
    with pkgs;
    [
      gomi
      bun
      uv
    ]
    ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isDarwin) [
      terminal-notifier
    ]
    ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isLinux) [
      libnotify
    ];
in
{
  config = lib.mkIf (cfg.enable && cfg.agy.enable) {
    home.packages = commonPackages ++ [
      inputs.antigravity-nix.packages."${pkgs.stdenv.hostPlatform.system}".google-antigravity-cli
    ];

    home.file.".gemini/antigravity-cli/AGENTS.md".source = ./AGENTS.md;

    home.activation.agySettingsGenerate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PATH="${pkgs.ghq}/bin:${pkgs.git}/bin:${pkgs.jq}/bin:$PATH" \
        ${pkgs.bash}/bin/bash ${generateSettingsScript} \
        '${settingsFile}' \
        '${settingsPath}'
    '';
  };
}
