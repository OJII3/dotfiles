{ config, lib, pkgs, ... }:
let
  cfg = config.dot.home.dev.ai;
  anyAiEnabled =
    cfg.enable
    || cfg.claude.enable
    || cfg.codex.enable
    || cfg.opencode.enable
    || cfg.gemini.enable;
in
{
  config = lib.mkIf anyAiEnabled {
    home.packages =
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
  };
}
