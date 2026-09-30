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

    agy = {
      enable = lib.mkEnableOption "Antigravity AI assistant";
    };

    pi = {
      enable = lib.mkEnableOption "Pi coding agent";
    };

    dsh = {
      enable = lib.mkEnableOption "dsh coding agent";
    };

    orca = {
      enable = lib.mkEnableOption "Orca AI orchestrator (Linux only)";
    };

    t3code = {
      enable = lib.mkEnableOption "T3 Code coding agent";

      backgroundService = {
        enable = lib.mkEnableOption "T3 Code background service";

        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Address for the T3 Code background service to listen on.";
        };
      };
    };
  };
}
