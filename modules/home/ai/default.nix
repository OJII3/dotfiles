# Home Manager AI modules
# AI assistant configuration with customizable options.
#
# Options are defined in ./options.nix
#
{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.dot.home.ai;
in
{
  imports = [
    ./options.nix
    ./skills.nix
    ./claude
    ./codex
    ./opencode
    ./gemini
  ];

  config =
    lib.mkIf (cfg.claude.enable || cfg.codex.enable || cfg.opencode.enable || cfg.gemini.enable)
      {

        home.packages =
          with pkgs;
          [
            gomi
            bun
            uv
            (callPackage ../../packages/gwq.nix { })
          ]
          ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isDarwin) [
            terminal-notifier
          ]
          ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isLinux) [
            libnotify
          ];
      };
}
