{ config, lib, ... }:
let
  cfg = config.my.home.terminal;
in
{
  config = lib.mkIf cfg.wezterm.enable {
    programs.wezterm.enable = true;
    home.file.".config/wezterm" = {
      source = ./.;
      recursive = true;
    };
  };
}
