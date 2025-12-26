{ pkgs, ... }:
let
  # claude-code を nodejs が使えるようにラップ
  claude-code-with-nodejs = pkgs.symlinkJoin {
    name = "claude-code";
    paths = [ pkgs.claude-code ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --prefix PATH : ${pkgs.nodejs-slim}/bin
    '';
  };
in
{
  imports = [
    ../.
    ./plugins.nix
  ];
  home.packages = [
    claude-code-with-nodejs
  ];

  # Claude Code設定ファイル
  home.file.".claude/settings.json".source = ./settings.json;
  home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;
  home.file.".claude/scripts/notify.sh" = {
    source = ./scripts/notify.sh;
    executable = true;
  };
  home.file.".claude/commands" = {
    source = ./commands;
    recursive = true;
  };
}
