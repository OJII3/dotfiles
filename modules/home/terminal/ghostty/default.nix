{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.terminal;
in
{
  config = lib.mkIf cfg.ghostty.enable {
    programs.ghostty = {
      enable = true;
      package = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin pkgs.ghostty-bin;
    };
    home.file.".config/ghostty/config".source = ./config;
    home.packages = with pkgs; [
      udev-gothic-nf
    ];
  };
}
