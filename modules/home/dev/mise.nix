{ config, lib, ... }:
let
  cfg = config.my.home.dev;
in
{
  config = lib.mkIf cfg.mise.enable {
    programs.mise = {
      enable = true;
      enableZshIntegration = true;
      globalConfig = {
        "tool_alias" = {
          node = "https://github.com/asdf-vm/asdf-nodejs";
        };
        settings = {
          idiomatic_version_file_enable_tools = [ "node" ];
        };
      };
    };
  };
}
