{ config, lib, ... }:
let
  cfg = config.my.home.dev;
in
{
  config = lib.mkIf cfg.vscode.enable {
    programs.vscode = {
      enable = true;
    };
  };
}
