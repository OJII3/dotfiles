{ ... }:
{
  imports = [
    ../../modules/home
  ];

  dot.home = {
    # Shell & Editor
    zsh.enable = true;
    neovim.enable = true;
    git.enable = true;
    gpg = {
      enable = true;
      pinentryPackage = "qt";
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
      mise.enable = true;
      ai = {
        enable = true;
        claude.enable = true;
        codex.enable = true;
        gemini.enable = true;
      };
    };

    # Apps
    apps.linux.common.enable = true;

    # Other
    bitwarden.enable = true;
    network.enable = true;
  };

  targets.genericLinux = {
    enable = true;
    gpu = {
      enable = true;
    };
  };

  programs.zsh.initContent = ''
    [ -f /opt/ros/humble/setup.zsh ] && source /opt/ros/humble/setup.zsh
  '';
}
