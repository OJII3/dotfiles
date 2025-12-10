{ pkgs, lib, ... }:
{
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
}
