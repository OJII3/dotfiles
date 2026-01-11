# Obsidian note-taking app with programs.obsidian
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

  # Self-hosted LiveSync plugin
  livesyncPlugin = pkgs.stdenvNoCC.mkDerivation {
    pname = "obsidian-livesync";
    version = "0.25.36";
    srcs = [
      (pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.36/main.js";
        hash = "sha256-rz2lmMRy1tO8LCEIfW2QCzze82MOjQnIpuo3y7p1BWw=";
        name = "main.js";
      })
      (pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.36/manifest.json";
        hash = "sha256-lBrV1DfPb+L+Bn70bFZ31Z2pbl+yT9Lsk8GptuStEcM=";
        name = "manifest.json";
      })
      (pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.36/styles.css";
        hash = "sha256-O9nrEIKaJ21tu1S9qRFSGeBD5bYdA/VEpByDUH0PM0U=";
        name = "styles.css";
      })
    ];
    sourceRoot = ".";
    dontUnpack = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      for src in $srcs; do
        cp $src $out/$(stripHash $src)
      done
      runHook postInstall
    '';
  };

  # HI3 Starfall theme (from flake input)
  hi3-theme = inputs.obsidian-hi3-theme.packages.${pkgs.system}.default;
in
{
  config = lib.mkIf cfg.enable {
    programs.obsidian = {
      enable = true;
      # macOS uses Homebrew cask, so set package = null
      package = lib.mkIf isDarwin (lib.mkForce null);

      vaults.${cfg.vaultName} = {
        target = cfg.vaultPath;
        settings = {
          appearance = {
            accentColor = "#FF6B35"; # HI3 Starfall orange
            baseFontSize = 16;
            cssTheme = "HI3 Starfall";
          };
          themes = [
            { pkg = hi3-theme; }
          ];
          communityPlugins = [
            { pkg = livesyncPlugin; }
          ];
          corePlugins = [
            "backlink"
            "bookmarks"
            "canvas"
            "command-palette"
            "daily-notes"
            "editor-status"
            "file-explorer"
            "file-recovery"
            "global-search"
            "graph"
            "markdown-importer"
            "note-composer"
            "outgoing-link"
            "outline"
            "page-preview"
            "properties"
            "slash-command"
            "switcher"
            "sync"
            "tag-pane"
            "templates"
            "word-count"
            "workspaces"
          ];
        };
      };
    };
  };
}
