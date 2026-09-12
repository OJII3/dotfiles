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
      enable = lib.mkEnableOption "Orca AI orchestrator";
    };
  };
}
