# AI module options
# All option definitions for dot.home.ai.*
{ lib, ... }:
{
  options.dot.home.ai = {
    enable = lib.mkEnableOption "AI assistant configuration";

    claude = {
      enable = lib.mkEnableOption "Claude Code AI assistant";
    };

    codex = {
      enable = lib.mkEnableOption "Codex AI assistant";
    };

    chatgpt = {
      enable = lib.mkEnableOption "ChatGPT Desktop";
    };

    opencode = {
      enable = lib.mkEnableOption "OpenCode AI assistant";
    };

    orca = {
      enable = lib.mkEnableOption "Orca agentic development environment";

      backgroundService = {
        enable = lib.mkEnableOption "Orca headless runtime service";

        bind = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = "Address for the Orca runtime to listen on.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 6768;
          description = "Port for the Orca runtime to listen on.";
        };

        pairingAddress = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "ws://100.96.0.14:6768";
          description = "Client-advertised endpoint written into pairing links. When null, Orca chooses the default LAN address.";
        };
      };
    };

    agy = {
      enable = lib.mkEnableOption "Antigravity AI assistant";
    };

    pi = {
      enable = lib.mkEnableOption "Pi coding agent";
    };

    dsh = {
      enable = lib.mkEnableOption "dsh coding agent";
    };

    t3code = {
      enable = lib.mkEnableOption "T3 Code coding agent";

      backgroundService = {
        enable = lib.mkEnableOption "T3 Code background service";

        host = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = "Address for the T3 Code background service to listen on.";
        };
      };
    };
  };
}
