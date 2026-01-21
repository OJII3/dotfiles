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
      tty.enable = true;
    };
    gpg = {
      enable = true;
      pinentryPackage = "tty";
    };
    direnv.enable = true;
    sops.enable = true;

    # Terminal
    terminal = {
      enable = true;
      ghostty.enable = true;
    };

    # Development
    dev = {
      enable = true;
      vscode.enable = true;
      mise.enable = true;
    };

    ai = {
      claude.enable = true;
      codex.enable = true;
      gemini.enable = true;
    };

    # Other
    network.enable = true;
    gnomeKeyring.enable = true;
    kdeconnect.enable = true;
  };
}
