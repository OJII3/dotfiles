{ config, lib, ... }:
let
  cfg = config.dot.home;
in
{
  config = lib.mkIf cfg.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
