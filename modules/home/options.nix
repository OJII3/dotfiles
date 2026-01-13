# Home Manager module options
# All option definitions for dot.home.*
{ lib, ... }:
{
  options.dot.home = {
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
        type = lib.types.enum [
          "tty"
          "qt"
          "gnome3"
          "mac"
        ];
        default = "tty";
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

    # Note-taking
    obsidian = {
      enable = lib.mkEnableOption "Obsidian note-taking app";
      vaultName = lib.mkOption {
        type = lib.types.str;
        default = "OJII3Vault";
        description = "Name of the Obsidian vault";
      };
      vaultPath = lib.mkOption {
        type = lib.types.str;
        default = "Documents/Obsidian/OJII3Vault";
        description = "Path to the Obsidian vault relative to home directory";
      };
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

    # Apps
    apps = {
      # Cross-platform (macOS & Linux)
      common = {
        enable = lib.mkEnableOption "Common cross-platform apps (JetBrains Toolbox, Slack, etc.)";
      };
      # Linux-specific
      linux = {
        common = {
          enable = lib.mkEnableOption "Common Linux desktop apps";
        };
        hyprland = {
          enable = lib.mkEnableOption "Hyprland-specific apps";
        };
        gnome = {
          enable = lib.mkEnableOption "GNOME-specific apps";
        };
      };
      # macOS-specific apps
      darwin = {
        enable = lib.mkEnableOption "macOS-specific apps";
      };
    };

    # ROS2
    ros2 = {
      enable = lib.mkEnableOption "ROS2 robotics framework";
    };

    # Obsidian Self-hosted LiveSync
    obsidianSync = {
      enable = lib.mkEnableOption "Obsidian Self-hosted LiveSync (CouchDB + Cloudflare Tunnel)";
      couchdb = {
        user = lib.mkOption {
          type = lib.types.str;
          default = "admin";
          description = "CouchDB admin username";
        };
        dataDir = lib.mkOption {
          type = lib.types.str;
          default = "couchdb/data";
          description = "CouchDB data directory relative to home";
        };
        memoryLimit = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "512m";
          description = "Memory limit for CouchDB container (e.g., '512m', '1g'). Set to null to disable.";
        };
      };
      autoUpdate = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable automatic container updates via podman auto-update";
        };
      };
      exposePort = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Expose CouchDB port 5984 to localhost for debugging";
      };
    };
  };
}
