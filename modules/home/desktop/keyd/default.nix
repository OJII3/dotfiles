{ config, lib, pkgs, ... }:
let
  cfg = config.my.home.desktop;
in
{
  config = lib.mkIf cfg.keyd.enable {
    home.file.".config/keyd/app.conf".source = ./app.conf;
    systemd.user.services.keyd = {
      Service = {
        ExecStart = "${pkgs.keyd}/bin/keyd-applicatoin-mapper -d";
      };
    };
  };
}
