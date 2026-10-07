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
        key = "~/.ssh/id_ed25519.pub";
      };
    };
    gpg = {
      enable = true;
      pinentryPackage = "tty";
    };
    direnv.enable = true;
    sops.enable = true;

    # Desktop
    desktop = {
      enable = true;
      fcitx5.enable = true;
      keyd.enable = true;
      theme.enable = true;
      browser.vivaldi.enable = true;
    };

    # Terminal
    terminal = {
      enable = true;
      ghostty.enable = true;
    };

    # Development
    dev = {
      enable = true;
      jetbrains.enable = true;
      mise.enable = false;
      zellij.enable = true;
    };

    ai = {
      enable = true;
      codex.enable = true;
      chatgpt.enable = true;
      agy.enable = true;
      opencode.enable = true;
      dsh.enable = true;
      t3code = {
        enable = true;
        backgroundService = {
          enable = true;
          host = "100.96.0.10";
        };
      };
    };

    # Apps
    apps.linux.common.enable = true;

    # Other
    bitwarden.enable = true;
    network.enable = true;
  };

  home.stateVersion = "26.05";
}
