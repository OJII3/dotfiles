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
    gpg.enable = true;
    gpg.pinentryPackage = "gnome3";
    gnomeKeyring.enable = true;
    direnv.enable = true;
    sops.enable = true;

    # Desktop
    desktop = {
      enable = true;
      gnome.enable = true;
      fcitx5.enable = true;
      keyd.enable = true;
      theme.enable = true;
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
    };

    ai = {
      agy.enable = true;
      claude.enable = true;
      codex.enable = true;
      codexDesktop.enable = true;
      opencode.enable = true;
    };

    apps = {
      common.enable = true;
      linux = {
        common.enable = true;
        gnome.enable = true;
      };
    };

    # Other
    bitwarden.enable = true;
    blenderLauncher.enable = true;
    network.enable = true;
  };

  home.stateVersion = "26.05";
}
