# Obsidian note-taking app
# Applied when dot.home.obsidian.enable is true
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.dot.home.obsidian;
  isDarwin = pkgs.stdenv.isDarwin;

  # HI3 Starfall theme (from flake input)
  hi3-theme = inputs.obsidian-hi3-theme.packages.${pkgs.system}.default;

  themesDir = "${cfg.vaultPath}/.obsidian/themes";
in
{
  config = lib.mkIf cfg.enable {
    # Install Obsidian package (Linux only, macOS uses Homebrew cask)
    home.packages = lib.mkIf (!isDarwin) [ pkgs.obsidian ];

    # Copy theme to vault using activation script
    home.activation.obsidianThemes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "${themesDir}"
      run cp -rT "${hi3-theme}" "${themesDir}/HI3 Starfall"
    '';
  };
}
