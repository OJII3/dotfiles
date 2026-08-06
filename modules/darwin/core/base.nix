# Base darwin configuration
# Applied when dot.darwin.core.enable is true
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
    system.primaryUser = username;
    environment.pathsToLink = [
      "/share/zsh"
    ];
  };
}
