{ pkgs, lib, ... }:
{
  home.packages =
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
}
