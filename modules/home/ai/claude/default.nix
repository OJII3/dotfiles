{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dot.home.ai;
  commonPackages =
    with pkgs;
    [
      gomi
      bun
      uv
      (callPackage ../../../packages/gwq.nix { })
    ]
    ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isDarwin) [
      terminal-notifier
    ]
    ++ lib.lists.optionals (pkgs.stdenv.hostPlatform.isLinux) [
      libnotify
    ];
in
{
  imports = [
    ./commands.nix
    ./skills.nix
    ./ssh-client.nix
  ];

  config = lib.mkIf cfg.claude.enable {
    home.packages = commonPackages;
    programs.jq.enable = true;
    programs.claude-code = {
      enable = true;
      commandsDir = ./commands;
      skillsDir = ./skills;
    };

    home.file.".claude/settings.json".source = ./settings.json;
    home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;
    home.file.".claude/scripts" = {
      source = ./scripts;
      executable = true;
    };
  };
}
