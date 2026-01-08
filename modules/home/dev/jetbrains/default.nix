{ config, lib, ... }:
let
  cfg = config.dot.home.dev;
in
{
  config = lib.mkIf cfg.jetbrains.enable {
    home.file.".ideavimrc".source = ./.ideavimrc;
  };
}
