# Minecraft Java Edition server
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.server.minecraft;
  opsFile = pkgs.writeText "ops.json" (builtins.toJSON [
    {
      uuid = "00d75b68-b321-4484-a8ba-2f52ac4fc551";
      name = "ojii3dev";
      level = 4;
      bypassesPlayerLimit = true;
    }
  ]);
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

    systemd.services.minecraft-server.preStart = lib.mkAfter ''
      ln -sf ${opsFile} ${config.services.minecraft-server.dataDir}/ops.json
    '';
  };
}
