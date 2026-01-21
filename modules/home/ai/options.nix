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

    opencode = {
      enable = lib.mkEnableOption "OpenCode AI assistant";
    };

    gemini = {
      enable = lib.mkEnableOption "Gemini AI assistant";
    };
  };
}
