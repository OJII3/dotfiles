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
    ./agy
    ./chatgpt
    ./claude
    ./codex
    ./dsh
    ./herdr
    ./opencode
    ./options.nix
    ./pi
    ./skills.nix
    ./t3code
  ];

  config = lib.mkIf cfg.enable {

    home.packages =
      with pkgs;
      [
        gomi
        python3Packages.pyyaml
        bun
        uv
      ]
      ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isDarwin) [
        terminal-notifier
      ]
      ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isLinux) [
        libnotify
      ];

    programs.zsh.shellAliases = {
      "rm" = "gomi";
    };
  };
}
