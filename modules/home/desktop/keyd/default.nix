{ pkgs, ... }:
{
  # keyd application specific configuration
  home.file.".config/keyd/app.conf".source = ./app.conf;
  systemd.user.services.keyd = {
    Service = {
      ExecStart = "${pkgs.keyd}/bin/keyd-applicatoin-mapper -d";
    };
  };
}
