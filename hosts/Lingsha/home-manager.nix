{ pkgs, pkgs-stable, ... }:
{
  imports = [
    ../../includes/home
    ../../includes/home/ai/codex
    ../../includes/home/apps/linux/ubuntu.nix
    ../../includes/home/bitwarden.nix
    ../../includes/home/desktop/theme.nix
    ../../includes/home/dev
    ../../includes/home/dev/mise.nix
    ../../includes/home/direnv.nix
    ../../includes/home/git
    ../../includes/home/gpg/linux-desktop.nix
    ../../includes/home/im
    ../../includes/home/neovim
    ../../includes/home/network.nix
    ../../includes/home/sops.nix
    ../../includes/home/terminal/ghostty
    ../../includes/home/zsh
  ];

  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    discord
    jetbrains-toolbox
    logisim-evolution
    pkgs-stable.blender
    slack
  ];

  programs = {
    vscode.enable = true;
  };
}
