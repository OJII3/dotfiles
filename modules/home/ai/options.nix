# AI module options
# All option definitions for dot.home.ai.*
{ lib, ... }:
{
  options.dot.home.ai = {
    claude = {
      enable = lib.mkEnableOption "Claude Code AI assistant";
    };

    codex = {
      enable = lib.mkEnableOption "Codex AI assistant";
    };

    codexDesktop = {
      enable = lib.mkEnableOption "Codex Desktop for Linux (Electron)";
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
  };
}
