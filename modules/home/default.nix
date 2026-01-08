# Home Manager modules entry point
# All modules are imported here and controlled via dot.home.* options.
#
# Usage example:
#   dot.home = {
#     zsh.enable = true;
#     neovim.enable = true;
#     git.enable = true;
#     desktop.hyprland.enable = true;
#     terminal.ghostty.enable = true;
#     dev.enable = true;
#   };
#
{ pkgs, ... }:
{
  imports = [
    # Options
    ./options.nix
    # Subdirectories (have their own options.nix)
    ./darwin
    ./desktop
    ./terminal
    ./dev
    # Root-level modules
    ./apps/linux/common.nix
    ./apps/linux/gnome.nix
    ./apps/linux/hyprland.nix
    ./bitwarden.nix
    ./direnv.nix
    ./git
    ./gnome-keyring.nix
    ./gpg
    ./kdeconnect.nix
    ./kdewallet.nix
    ./neovim
    ./network.nix
    ./ros2
    ./sops.nix
    ./vr.nix
    ./zsh
  ];

  # Base configuration (always applied)
  home.file.".assets" = {
    source = ../../assets;
    recursive = true;
  };

  home.packages = with pkgs; [
    nix-search-cli
  ];
}
