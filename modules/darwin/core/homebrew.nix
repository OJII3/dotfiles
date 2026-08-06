{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.dot.darwin.core;
in
{
  config = lib.mkIf cfg.enable {
    nix-homebrew = {
      enable = true;
      enableRosetta = false;
      user = username;
      mutableTaps = false;
      autoMigrate = true;
    };

    homebrew = {
      enable = true;
      onActivation = {
        upgrade = true;
        autoUpdate = false;
        cleanup = "zap";
      };
    };
  };
}
