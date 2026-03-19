# Minecraft Java Edition server
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.server.minecraft;
in
{
  options.dot.server.minecraft = {
    enable = lib.mkEnableOption "Minecraft Java Edition server";
  };

  config = lib.mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      eula = true;
      openFirewall = true;
      declarative = true;
      serverProperties = {
        server-port = 25565;
        difficulty = "normal";
        gamemode = "survival";
        max-players = 10;
        motd = "Cipher Minecraft Server";
        white-list = false;
      };
      jvmOpts = "-Xmx2G -Xms1G";
    };
  };
}
