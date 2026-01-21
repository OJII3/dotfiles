{ config, lib, pkgs, ... }:
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
  config = lib.mkIf cfg.gemini.enable {
    home.packages = commonPackages ++ [
      gemini-cli-bin
    ];

    home.file.".gemini/settings.json".source = ./settings.json;
    home.file.".gemini/AGENTS.md".source = ./AGENTS.md;
  };
}
