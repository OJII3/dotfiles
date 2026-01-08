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
    direnv.enable = true;
    sops.enable = true;

    # Desktop
    desktop = {
      enable = true;
      gnome.enable = true;
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
      vscode.enable = true;
      jetbrains.enable = true;
      mise.enable = true;
      ai = {
        enable = true;
        claude.enable = true;
        codex.enable = true;
        gemini.enable = true;
      };
    };

    # Other
    bitwarden.enable = true;
    network.enable = true;
    ros2.enable = true;
  };
}
