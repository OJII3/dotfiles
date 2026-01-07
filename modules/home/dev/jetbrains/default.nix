{ config, lib, ... }:
let
  cfg = config.my.home.dev;
in
{
  config = lib.mkIf cfg.jetbrains.enable {
    home.file.".ideavimrc".source = ./.ideavimrc;
  };
}
