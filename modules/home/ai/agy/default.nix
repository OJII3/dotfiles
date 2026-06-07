{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  commonPackages =
    with pkgs;
    [
      gomi
      bun
      uv
      (callPackage ../../../packages/gwq.nix { })
    ]
    ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isDarwin) [
      terminal-notifier
    ]
    ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isLinux) [
      libnotify
    ];
in
{
  config = lib.mkIf cfg.agy.enable {
    home.packages = commonPackages ++ [
      inputs.antigravity-nix.packages."${pkgs.stdenv.hostPlatform.system}".google-antigravity-cli
    ];

    home.file.".gemini/antigravity-cli/settings.json".source = ./settings.json;
    home.file.".gemini/antigravity-cli/AGENTS.md".source = ./AGENTS.md;
  };
}
