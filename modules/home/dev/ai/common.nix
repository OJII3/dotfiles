{ config, lib, pkgs, ... }:
let
  cfg = config.dot.home.dev.ai;
in
{
  config = lib.mkIf cfg.enable {
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
