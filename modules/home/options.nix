# Home Manager module options
# All option definitions for my.home.*
{ lib, ... }:
{
  options.my.home = {
    # Shell
    zsh = {
      enable = lib.mkEnableOption "Zsh shell configuration";
    };

    # Editor
    neovim = {
      enable = lib.mkEnableOption "Neovim editor";
    };

    # Version control
    git = {
      enable = lib.mkEnableOption "Git configuration";
    };

    # GPG
    gpg = {
      enable = lib.mkEnableOption "GPG configuration";
      pinentryPackage = lib.mkOption {
        type = lib.types.enum [ "tty" "qt" "gnome3" ];
        default = "gnome3";
        description = "Pinentry package type: tty, qt, or gnome3";
      };
    };

    # Environment
    direnv = {
      enable = lib.mkEnableOption "Direnv integration";
    };

    # Secrets
    sops = {
      enable = lib.mkEnableOption "Sops secrets management";
    };

    # Password manager
    bitwarden = {
      enable = lib.mkEnableOption "Bitwarden password manager";
    };

    # Network
    network = {
      enable = lib.mkEnableOption "Network utilities";
    };

    kdewallet = {
      enable = lib.mkEnableOption "KDE wallet integration";
    };

    kdeconnect = {
      enable = lib.mkEnableOption "KDE Connect";
    };

    gnomeKeyring = {
      enable = lib.mkEnableOption "GNOME Keyring";
    };

    vr = {
      enable = lib.mkEnableOption "VR support (OpenComposite)";
    };

    # Linux apps
    apps = {
      linux = {
        common = {
          enable = lib.mkEnableOption "Common Linux desktop apps";
        };
        hyprland = {
          enable = lib.mkEnableOption "Hyprland-specific apps";
        };
      };
    };

    # ROS2
    ros2 = {
      enable = lib.mkEnableOption "ROS2 robotics framework";
    };
  };
}
