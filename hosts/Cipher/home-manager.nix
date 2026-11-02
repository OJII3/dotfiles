{ ... }:
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
