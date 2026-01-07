{ config, lib, ... }:
let
  cfg = config.my.home.terminal;
in
{
  config = lib.mkIf cfg.kitty.enable {
    programs.kitty.enable = true;
    home.file.".config/kitty" = {
      source = ./.;
      recursive = true;
    };
  };
}
