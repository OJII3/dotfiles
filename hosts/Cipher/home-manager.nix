{ config, ... }:
{
  imports = [
    ../../modules/home
  ];

  dot.home = {
    # Shell & Editor
    zsh.enable = true;
    neovim.enable = true;
    git = {
      enable = true;
      signing = {
        format = "ssh";
      };
    };
    gpg = {
      enable = true;
      pinentryPackage = "tty";
    };
    direnv.enable = true;
    sops.enable = true;

    # Kopia repository server
    kopia = {
      enable = true;
      repositoryPasswordFile = config.sops.secrets.kopia_repository_password.path;
      serverControlPasswordFile = config.sops.secrets.kopia_server_control_password.path;
    };

    # Terminal
    terminal = {
      enable = false;
    };

    # Development
    dev = {
      enable = true;
      mise.enable = false;
      zellij.enable = false;
    };

    ai = {
      enable = true;
      claude.enable = false;
      codex.enable = true;
      agy.enable = true;
      opencode.enable = true;
      orca = {
        enable = false;
        backgroundService = {
          enable = true;
          pairingAddress = "ws://100.96.0.14:6768";
        };
      };
      dsh.enable = false;
      t3code = {
        enable = true;
        backgroundService = {
          enable = true;
        };
      };
    };

    apps.linux.common.enable = true;

    # Other
    network.enable = true;
    gnomeKeyring.enable = false;
    kdeconnect.enable = false;
  };

  targets.genericLinux = {
    enable = true;
    gpu = {
      enable = false;
    };
  };

  home.stateVersion = "26.05";
}
